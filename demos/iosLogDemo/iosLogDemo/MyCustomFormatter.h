//
//  MyCustomFormatter.h
//  iosLogDemo
//
//  Created by mxw on 15/11/5.
//  Copyright © 2015年 mtzijin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DDLog.h"

@interface MyCustomFormatter : NSObject <DDLogFormatter>{
    int atomicLoggerCount;
    NSDateFormatter *threadUnsafeDateFormatter;
}
@end
