//
//  MyCustomFormatter.m
//  iosLogDemo
//
//  Created by mxw on 15/11/5.
//  Copyright © 2015年 mtzijin. All rights reserved.
//

#import "MyCustomFormatter.h"
#import <libkern/OSAtomic.h>


@implementation MyCustomFormatter
- (NSString *)stringFromDate:(NSDate *)date {
    int32_t loggerCount = OSAtomicAdd32(0, &atomicLoggerCount);
    NSString *dateFormatString =@"yyyy-MM-dd HH:mm:ss";
    
    if (loggerCount <= 1) {
        // Single-threaded mode.
        
        if (threadUnsafeDateFormatter == nil) {
            threadUnsafeDateFormatter = [[NSDateFormatter alloc] init];
            [threadUnsafeDateFormatter setDateFormat:dateFormatString];
            [threadUnsafeDateFormatter setTimeZone:[NSTimeZone  timeZoneWithName:@"Asia/Shanghai"]];
            threadUnsafeDateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
        }
        
        return [threadUnsafeDateFormatter stringFromDate:date];
    } else {
        // Multi-threaded mode.
        // NSDateFormatter is NOT thread-safe.
        
        NSString *key = @"MyCustomFormatter_NSDateFormatter";
        
        NSMutableDictionary *threadDictionary = [[NSThread currentThread] threadDictionary];
        NSDateFormatter *dateFormatter = [threadDictionary objectForKey:key];
        
        if (dateFormatter == nil) {
            dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:dateFormatString];
            [dateFormatter setTimeZone:[NSTimeZone  timeZoneWithName:@"Asia/Shanghai"]];
            dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
            
            [threadDictionary setObject:dateFormatter forKey:key];
        }
        
        return [dateFormatter stringFromDate:date];
    }
}

- (NSString *)formatLogMessage:(DDLogMessage *)logMessage {
    NSString *logLevel;
    switch (logMessage->_flag) {
        case DDLogFlagError    : logLevel = @"E"; break;
        case DDLogFlagWarning  : logLevel = @"W"; break;
        case DDLogFlagInfo     : logLevel = @"I"; break;
        case DDLogFlagDebug    : logLevel = @"D"; break;
        default                : logLevel = @"V"; break;
    }
    
    NSString *dateAndTime = [self stringFromDate:(logMessage.timestamp)];
    
    return [NSString stringWithFormat:@"%@ [%@] %@\n    [tid:%@ %@:%@ %@]",
            dateAndTime, logLevel, logMessage->_message,
            logMessage->_threadID,
            logMessage->_fileName,@(logMessage->_line),
            logMessage->_function
            ];
}

- (void)didAddToLogger:(id <DDLogger>)logger {
    OSAtomicIncrement32(&atomicLoggerCount);
}

- (void)willRemoveFromLogger:(id <DDLogger>)logger {
    OSAtomicDecrement32(&atomicLoggerCount);
}


@end
