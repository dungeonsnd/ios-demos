//
//  demo_port_libeventUITests.m
//  demo_port_libeventUITests
//
//  Created by jeffery on 15/8/25.
//  Copyright © 2015年 jeffery. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface demo_port_libeventUITests : XCTestCase

@end

@implementation demo_port_libeventUITests

- (void)setUp {
    [super setUp];
    
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    // In UI tests it is usually best to stop immediately when a failure occurs.
    self.continueAfterFailure = NO;
    // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
    [[[XCUIApplication alloc] init] launch];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // Use recording to get started writing UI tests.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

@end
