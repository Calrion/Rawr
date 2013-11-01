//
//  RawrTests.m
//  RawrTests
//
//  Created by Greg W on 2013-10-30.
//  Copyright (c) 2013 G Waterhouse. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface RawrTests : XCTestCase

@end

@implementation RawrTests

- (void)setUp
{
  [super setUp];
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testRemoteNotificationSound
{
  NSDictionary * const userInfo = @{@"aps": @{@"sound": @"dinosaur.wav"}, @"request_id": @23};
  UIApplication *app = [UIApplication sharedApplication];

  [[app delegate] application:app didReceiveRemoteNotification:userInfo];
}

@end
