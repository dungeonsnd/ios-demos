//
//  MyStatic.m
//  MyStatic
//
//  Created by jeffery on 15/9/24.
//  Copyright © 2015年 jeffery. All rights reserved.
//

#import "MyStatic.h"


#include "event2/bufferevent.h"
#include "event2/buffer.h"
#include "event2/listener.h"
#include "event2/util.h"
#include "event2/event.h"
//#include "sys/socket.h"
#include <string>
#include <errno.h>
#include <string.h>



@implementation MyStatic


- (NSInteger) add:(NSInteger) a B:(NSInteger)b{
    return a+b;
}


void eventcb(struct bufferevent *bev, short events, void *ptr)
{
    NSLog(@"eventcb");
    if (events & BEV_EVENT_CONNECTED) {
        /* We're connected to 127.0.0.1:8080.   Ordinarily we'd do
         something here, like start reading or writing. */
        NSLog(@"connected");
    } else if (events & BEV_EVENT_ERROR) {
        /* An error occured while connecting. */
        NSLog(@"An error occured while connecting! err=%d{%s}",errno,strerror(errno));
    }
}

-(int) main_loop
{
    int rt =-1;
    do{
        NSLog(@"main_loop");
        struct event_base * base =event_base_new();
        
        std::string ip_port ="192.168.1.10:19600";
        struct sockaddr saddr;
        int saddr_len =sizeof(saddr);
        if(0!=evutil_parse_sockaddr_port(ip_port.c_str(), &saddr, &saddr_len))
        {
            NSLog(@"evutil_parse_sockaddr_port return nonzero ! ");
            break;
        }
        
        
        struct bufferevent * bev = bufferevent_socket_new(base, -1, BEV_OPT_CLOSE_ON_FREE);
        
        bufferevent_setcb(bev, NULL, NULL, eventcb, NULL);
        
        if (bufferevent_socket_connect(bev,
                                       (struct sockaddr *)&saddr, sizeof(saddr)) < 0) {
            
            bufferevent_free(bev);
            NSLog(@"Failed of bufferevent_socket_connect! ");
            break;
        }
        
        NSLog(@"before dispatch");
        event_base_dispatch(base);
        NSLog(@"after dispatch");

        bufferevent_free(bev);
        
        event_base_free(base);
        
        rt =0;
    }while(0);
    return rt;}


@end
