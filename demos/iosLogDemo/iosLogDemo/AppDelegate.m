//
//  AppDelegate.m
//  iosLogDemo
//
//  Created by mxw on 15/11/5.
//  Copyright © 2015年 mtzijin. All rights reserved.
//

#import "AppDelegate.h"

#import "MyCustomFormatter.h"
#import <CocoaLumberjack/CocoaLumberjack.h>
#import <SSZipArchive/SSZipArchive.h>



@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    MyCustomFormatter *logFormatter = [[MyCustomFormatter alloc] init];
    
    DDLogLevel ddLogLevel = DDLogLevelDebug;
    
    DDFileLogger *fileLogger = [[DDFileLogger alloc] init];
    [fileLogger setLogFormatter:logFormatter];
    fileLogger.maximumFileSize =1024 * 1024 * 10;  // 10 MB每个文件.
    fileLogger.logFileManager.maximumNumberOfLogFiles = 3; // 最多三个文件.
    
    [DDLog addLogger:fileLogger withLevel:ddLogLevel];
    
    DDLogError(@"Error msg.");
    DDLogWarn(@"Warn msg.");
    DDLogInfo(@"Info msg.");
    DDLogDebug(@"Debug msg.");
    DDLogVerbose(@"Verbose msg.");
    
    
    
    NSString * logFilePath =[[[fileLogger currentLogFileInfo] filePath] stringByDeletingLastPathComponent];
    NSString * archivePath =[logFilePath stringByDeletingLastPathComponent];
    NSLog(@"logFilePath:%@, archivePath:%@", logFilePath, archivePath);
    
    NSString *archiveFile = [archivePath stringByAppendingPathComponent:@"log.zip"];
    
    // Create
    [SSZipArchive createZipFileAtPath: archiveFile withContentsOfDirectory: logFilePath];
    
    // Unzip
    //    [SSZipArchive unzipFileAtPath:zipPath toDestination: unzipPath];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
