//
//  USFNetworkTool.m
//  LibeventT
//
//  Created by jeffery on 16/3/13.
//  Copyright © 2016年 jeffery. All rights reserved.
//
//
//bufferevent_socket_connect_hostname和 evdns_getaddrinfo 这两种方式貌似在 iOS 真机上似乎都有BUG，而在模拟器上是没问题的。
//用这个 Low-level DNS interfaces 才行。
//



// 注意要处理 SIGPIPE 信号，否则 会崩溃!
// https://developer.apple.com/library/ios/documentation/NetworkingInternetWeb/Conceptual/NetworkingOverview/CommonPitfalls/CommonPitfalls.html
//
// http://www.cnblogs.com/decwang/archive/2013/03/26/2983127.html
// XCode调试时依然会显示中断，但是点击几次继续就可以正常往下执行了。 打包后传到越狱设备上执行不会崩溃。
// 还有一种方法是在 applicationDidEnterBackground stopLoop来停止网络连接.
//
// 尽量使用信号的方式，
//struct sigaction sa;
//sa.sa_handler = SIG_IGN;
//sigaction( SIGPIPE, &sa, 0 );
//
// 只使用下面的方式不用 sigaction 时，应该是 libevent内部有127.0.0.1的相互连接的管道没有设置，所以打包到越狱设备上运行是会闪退! 只使用上面提到的 SIGPIPE SIG_IGN 方式在真机上 没有问题。
// int nosigpipe = 1;
// setsockopt(bufferevent_getfd(bev), SOL_SOCKET, SO_NOSIGPIPE, &nosigpipe, sizeof(nosigpipe));
//


#import "USFNetworkTool.h"

#include <stdio.h>
#include <string>
#include <sys/socket.h>

#import <netinet/in.h>
#import <arpa/inet.h>
#import <unistd.h>

#include "event2/dns.h"
#include "event2/bufferevent.h"
#include "event2/buffer.h"
#include "event2/util.h"
#include "event2/event.h"


enum usfnwtConnectionStatus{
    usfnwt_NotConnected =1,
    usfnwt_Connecting =2,
    usfnwt_Connected =3
};

typedef struct _tagUsfnwtGlobalData{
    
    struct event_base *base;
    struct evdns_base *dnsBase;
    
    int timerSeconds;
    struct event *evTimer;
    
    std::string host;
    std::string resolvedIp;
    int port;
    struct bufferevent *bev;
    int connStatus;
    
    long long sentHeartBeatTime;
}usfnwtGlobalData;

long long getTimeNow()
{
    struct  timeval    tv;
    struct  timezone   tz;
    gettimeofday(&tv,&tz);
    return tv.tv_sec*1000*1000+tv.tv_usec;
}


// 判断是IP地址还是域名。当IP地址时返回1，域名返回0，错误返回-1.
int isIpAddr(const char * addr)
{
    int rt =1;
    do{
        const char *p =addr;
        int dotCount =0;
        int len =0;
        for (; *p!='\0'; p++) {
            len++;
            
            // 含非数字及点.
            if (*p<'0' || *p>'0' || *p!='.') {
                rt =0;
                break;
            }
            
            // 点的数量太多.
            if (*p=='.') {
                dotCount++;
                if (dotCount>=8) {
                    rt =0;
                    break;
                }
            }
        }
        if (1!=rt) {
            break;
        }
        
        // 没有点.
        if (dotCount<1) {
            rt =-1;
            break;
        }
        // 点的数量太小.
        if (dotCount<3) {
            rt =0;
            break;
        }
        // 总长度太短.
        if (len<7) {
            rt =0;
            break;
        }
        // 首尾是点.
        if (addr[0]=='.'||addr[len-1]=='.') {
            rt =0;
            break;
        }
        
    }while(0);
    
    return rt;
}

@interface USFNetworkTool(){
    usfnwtGlobalData * _globaData;

}

@property (assign, nonatomic) NSInteger i;
@end


@implementation USFNetworkTool


void usfnwtSocketConnect(struct bufferevent *bev, usfnwtGlobalData &globaData)
{
    globaData.bev =bev;
    globaData.connStatus =usfnwt_Connecting;
}
void usfnwtSocketConnected(usfnwtGlobalData &globaData)
{
    globaData.connStatus =usfnwt_Connected;
}
void usfnwtSocketClosed(struct bufferevent *bev, usfnwtGlobalData &globaData)
{
    NSLog(@"Closed");
    bufferevent_free(bev);
    globaData.bev =NULL;
    globaData.connStatus =usfnwt_NotConnected;
}



void usfnwtReadCb(struct bufferevent *bev, void *arg)
{
    usfnwtGlobalData *globaData = (usfnwtGlobalData *)(arg);
    
    struct evbuffer *input = bufferevent_get_input(bev);
    size_t inputLen =evbuffer_get_length(input);
    
    long long usingTimeUSec =getTimeNow()-globaData->sentHeartBeatTime;
    long long msec =usingTimeUSec/1000;
    long long usec =usingTimeUSec%1000;
    NSLog(@">>>> Recved Heartbeat, len=%d, using %lld.%lld msec",
          (int)(inputLen), msec, usec);
    
    NSString *msg =[[NSString alloc]initWithFormat:@">>>> Recved Heartbeat, len=%d, using %lld.%lld msec",
                    (int)(inputLen), msec, usec];
    [[USFNetworkTool sharedInstance] notifyUI:@"ReadCb" msg:msg];
    
    char buf[1024];
    bufferevent_read(bev, buf, 9);
}

void usfnwtWriteCb(struct bufferevent *bev, void *arg)
{
    //    NSLog(@"usfnwtWriteCb");
}

void usfnwtEventCb(struct bufferevent *bev, short events, void *arg)
{
    int errorcode =EVUTIL_SOCKET_ERROR();
    usfnwtGlobalData *globaData = (usfnwtGlobalData *)(arg);
    if (NULL==globaData) {
        NSLog(@"Error in usfnwtEventCb, NULL==globaData ! \n");
        return;
    }
    
    if (events & BEV_EVENT_CONNECTED)
    {
        NSLog(@"Connected.");
        NSString *msg =[[NSString alloc]initWithFormat:@"Server connected {%s --> %s}.",
                        globaData->host.c_str(), globaData->resolvedIp.c_str()];
        [[USFNetworkTool sharedInstance] notifyUI:@"EventCB" msg:msg];
        
        usfnwtSocketConnected(*globaData);
        
    }
    else if (events & (BEV_EVENT_EOF))
    {
        NSLog(@"BEV_EVENT_EOF from %s\n", globaData->host.c_str() );
        NSString *msg =[[NSString alloc]initWithFormat:@"BEV_EVENT_EOF from %s", globaData->host.c_str()];
        [[USFNetworkTool sharedInstance] notifyUI:@"EventCB" msg:msg];
        
        usfnwtSocketClosed(bev, *globaData);
    }
    else if (events & (BEV_EVENT_TIMEOUT))
    {
        NSLog(@"BEV_EVENT_TIMEOUT from %s \n",
              globaData->host.c_str() );
        NSString *msg =[[NSString alloc]initWithFormat:@"BEV_EVENT_TIMEOUT from %s",globaData->host.c_str()];
        [[USFNetworkTool sharedInstance] notifyUI:@"EventCB" msg:msg];
        
        usfnwtSocketClosed(bev, *globaData);
    }
    else if (events & (BEV_EVENT_ERROR))
    {
        NSLog(@"BEV_EVENT_ERROR from %s: %s\n",
              globaData->host.c_str(),
              evutil_socket_error_to_string(errorcode));
        NSString *msg =[[NSString alloc]initWithFormat:@"BEV_EVENT_ERROR from %s: %s",
                        globaData->host.c_str(),
                        evutil_socket_error_to_string(errorcode)];
        [[USFNetworkTool sharedInstance] notifyUI:@"EventCB" msg:msg];
        
        int err = bufferevent_socket_get_dns_error(bev);
        if (err)
        {
            NSLog(@"DNS error{%d}: %s\n", err, evutil_gai_strerror(err));
            NSString *msg =[[NSString alloc]initWithFormat:@"DNS error{%d}: %s", err, evutil_gai_strerror(err)];
            [[USFNetworkTool sharedInstance] notifyUI:@"EventCB" msg:msg];
            
            usfnwtStartDnsResolve(*globaData);
        }
        usfnwtSocketClosed(bev, *globaData);
    }
    else
    {
        NSLog(@"OTHER error from %s \n",
              globaData->host.c_str() );
        NSString *msg =[[NSString alloc]initWithFormat:@"OTHER error from %s ",
                        globaData->host.c_str()];
        [[USFNetworkTool sharedInstance] notifyUI:@"EventCB" msg:msg];
        
        usfnwtSocketClosed(bev, *globaData);
    }
}

void usfnwtTimerCb(evutil_socket_t fd, short what, void *arg)
{
    NSLog(@"usfnwtTimerCb");
    
    usfnwtGlobalData *globaData = (usfnwtGlobalData *)(arg);
    
    if (usfnwt_Connected==globaData->connStatus)
    {
        char heartBeart[9];
        memset(heartBeart, 0, sizeof(heartBeart));
        bufferevent_write(globaData->bev, heartBeart, sizeof(heartBeart));
        NSLog(@"<<<< Sent Heartbeat, len=%d", (int)(sizeof(heartBeart)));
        globaData->sentHeartBeatTime =getTimeNow();
        
        NSString *msg =[[NSString alloc]initWithFormat:@"<<<< Sent Heartbeat, len=%d", (int)(sizeof(heartBeart))];
        [[USFNetworkTool sharedInstance] notifyUI:@"TimerCb" msg:msg];
    } else if (usfnwt_NotConnected==globaData->connStatus)
    {
        
    }
}


void usfnwtDnsResolveCb(int result, char type, int count,
                        int ttl, void *addresses, void *arg)
{
    usfnwtGlobalData *globaData = (usfnwtGlobalData *)(arg);
    //    DNS_ERR_NONE
    //    DNS_IPv4_A
    NSLog(@"usfnwtDnsResolveCb, result=%d, type=%d, count=%d, ttl=%d \n",
          result, type, count, ttl);
    if (DNS_ERR_NONE==result) {
        NSLog(@"usfnwtDnsResolveCb DNS_ERR_NONE\n");
        
        char buf[128];
        const char *s = NULL;
        if (DNS_IPv4_A == type) {
            
            struct sockaddr_in sin;
            memset(&sin, 0, sizeof(sin));
            sin.sin_addr.s_addr = *((unsigned*)(addresses));
            s = evutil_inet_ntop(AF_INET, &sin.sin_addr, buf, 128);
        } else if (DNS_IPv6_AAAA == type) {
            //struct sockaddr_in6 *sin6 = (struct sockaddr_in6 *)ai->ai_addr;
            //s = evutil_inet_ntop(AF_INET6, &sin6->sin6_addr, buf, 128);
        }
        if (s)
        {
            globaData->resolvedIp =s;
            NSLog(@"            %s-> %s\n", globaData->host.c_str(), s);
            usfnwtConnectServer(*globaData);
        }
    }
}


int usfnwtConnectServer(usfnwtGlobalData & globaData)
{
    int res =-1;
    do{
        struct bufferevent *bev = bufferevent_socket_new(globaData.base, -1, BEV_OPT_CLOSE_ON_FREE);
        if (!bev) {
            break;
        }
        
// 设置了 SIGPIPE SIG_IGN 就可以不用下面的设置了。
//        int nosigpipe = 1;
//        setsockopt(bufferevent_getfd(bev), SOL_SOCKET, SO_NOSIGPIPE, &nosigpipe, sizeof(nosigpipe));
        
        bufferevent_setcb(bev, usfnwtReadCb, usfnwtWriteCb, usfnwtEventCb, &globaData);
        bufferevent_enable(bev, EV_READ|EV_WRITE);
        
        int isIp =isIpAddr( globaData.host.c_str() );
        if ( globaData.resolvedIp.length()>0 || 1==isIp) {
            struct sockaddr_in sin;
            memset(&sin, 0, sizeof(sin));
            sin.sin_family = AF_INET;
            struct in_addr s;
            int rt =evutil_inet_pton(AF_INET,
                                     globaData.resolvedIp.length()>0?globaData.resolvedIp.c_str():globaData.host.c_str(),
                                     &s);
            if (rt!= 1) {
                bufferevent_free(bev);
                break;
            }
            sin.sin_addr =s;
            sin.sin_port = htons(globaData.port);
            
            rt =bufferevent_socket_connect(bev,
                                           (struct sockaddr *)&sin,
                                           sizeof(sin));
            if (rt!= 0) {
                bufferevent_free(bev);
                break;
            }
        }
        else if (0==isIp)
        {
            int rt =bufferevent_socket_connect_hostname(bev,
                                                        globaData.dnsBase,
                                                        AF_UNSPEC,
                                                        globaData.host.c_str(),
                                                        globaData.port);
            if (rt!= 0) {
                bufferevent_free(bev);
                break;
            }
        }
        else if (0==isIp)
        {
            NSLog(@"wrong host");
            break;
        }
        
        usfnwtSocketConnect(bev, globaData);
        res =0;
    }while(0);
    return res;
}

int usfnwtStartDnsResolve(usfnwtGlobalData & globaData)
{
    NSLog(@"Try Low-level DNS interfaces now ......");
    NSString *msg =[[NSString alloc]initWithFormat:@"Try Low-level DNS interfaces now ......"];
    [[USFNetworkTool sharedInstance] notifyUI:@"InfoCB" msg:msg];
    struct evdns_request * r=evdns_base_resolve_ipv4(globaData.dnsBase,
                                                     globaData.host.c_str(),
                                                     0,
                                                     usfnwtDnsResolveCb,
                                                     &globaData);
    if (!r)
        return  -1;
    return 0;
}

void initNetworkBase(usfnwtGlobalData &globaData)
{
    
    struct event_base *base = event_base_new();
    globaData.base =base;
    
    struct evdns_base *dnsBase = evdns_base_new(base, 1);
    evdns_base_nameserver_ip_add(dnsBase, "114.114.114.114");
    evdns_base_nameserver_ip_add(dnsBase, "8.8.8.8");
    globaData.dnsBase =dnsBase;
}

void initNetworkTimer(usfnwtGlobalData &globaData)
{
    struct timeval intervalTimer = {globaData.timerSeconds, 0};
    struct event *evTimer= event_new(globaData.base, -1, EV_PERSIST,
                                     usfnwtTimerCb, &globaData);
    event_add(evTimer, &intervalTimer);
    globaData.evTimer =evTimer;
    
}

void startNetworkLoop(usfnwtGlobalData &globaData)
{
    event_base_dispatch(globaData.base);
    NSLog(@"event_base_free");
    evdns_base_free(globaData.dnsBase, 1);
    event_base_free(globaData.base);
    globaData.dnsBase =NULL;
    globaData.base =NULL;
}

+ (USFNetworkTool *)sharedInstance
{
    static USFNetworkTool *inst;
    
    if (!inst){
        inst = [[USFNetworkTool alloc] init];
        [inst setGlobal];
    }
    return inst;
}

- (void)setGlobal{
    _globaData =NULL;
}

- (void)resettimer:(NSInteger) timerSeconds{
    if (_globaData->evTimer) {
        event_del(_globaData->evTimer);
    }
    _globaData->timerSeconds =(int)(timerSeconds);
    initNetworkTimer(*_globaData);
}

-(void) doNotifyUI:(NSDictionary*)info{
    
    dispatch_async( dispatch_get_main_queue() , ^{
        //主线程中执行Observer.
        [[NSNotificationCenter defaultCenter] postNotificationName:@"usfnt" object:self userInfo:info];
    });
}

-(void) notifyUI:(NSString*)cmd msg:(NSString*)msg{
    
    struct timeval tv;
    gettimeofday(&tv, NULL);
    struct tm gmt;
    gmtime_r(&tv.tv_sec, &gmt);
    
    NSString *s =[[NSString alloc]initWithFormat:@"[%02d%02d %02d:%02d:%02d] %@",
                  gmt.tm_mon+1, gmt.tm_mday,
                  gmt.tm_hour, gmt.tm_min,
                  gmt.tm_sec,msg];
    [[USFNetworkTool sharedInstance] doNotifyUI:@{@"cmd":cmd, @"msg":s}];
}

    
-(NSInteger) startLoop:(NSString *)hostOrIp port:(NSUInteger) port{
    if (hostOrIp.length <=0 ) {
        return -1;
    }
    
    struct sigaction sa;
    sa.sa_handler = SIG_IGN;
    sigaction( SIGPIPE, &sa, 0 );
    
    __weak  __typeof(self) weakSelf =self;
//    dispatch_queue_t q = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_queue_t q =dispatch_queue_create("com.mtzijin.usfnwt", DISPATCH_QUEUE_SERIAL);
    dispatch_async(q,^{
        
        NSLog(@"startLoop");
        __strong __typeof(weakSelf) strongSelf =weakSelf;
        
        [[USFNetworkTool sharedInstance] notifyUI:@"InfoCB" msg:@"startLoop"];
        
        usfnwtGlobalData globaData;
        strongSelf->_globaData =&globaData;
        globaData.timerSeconds =15;
        globaData.evTimer =NULL;
        globaData.host =[hostOrIp cStringUsingEncoding:NSUTF8StringEncoding];
        globaData.port =(int)(port);
        
        initNetworkBase(globaData);
        initNetworkTimer(globaData);
        usfnwtConnectServer(globaData);
        startNetworkLoop(globaData);
    });
    
    return 0;
}


-(void) stopLoop{
    if (_globaData && _globaData->base) {
        event_base_loopbreak(_globaData->base);
    }
}

@end
