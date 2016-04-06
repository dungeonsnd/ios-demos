//
//  USFNetworkTool.h
//  LibeventT
//
//  Created by jeffery on 16/3/13.
//  Copyright © 2016年 jeffery. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface USFNetworkTool : NSObject


+ (USFNetworkTool *)sharedInstance;


-(NSInteger) startLoop:(NSString *)hostOrIp port:(NSUInteger) port;
- (void)resettimer:(NSInteger) timerSeconds;

-(void) stopLoop;

@end
