//
//  RawrTests.m
//  RawrTests
//
//  Created by Greg W on 2013-10-30.
//  Copyright (c) 2013 G Waterhouse. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCMock.h>

@interface RawrTests : XCTestCase

@end

@implementation RawrTests

- (void)setUp
{
  [super setUp];
  _mockAudioPlayer = [OCMockObject mockForClass:[AVAudioPlayer class]];
  _objUnderTest.bouncePlayer = _mockAudioPlayer;
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testRemoteNotificationSound
{
  NSDictionary * const userInfo = @{@"aps": @{@"sound": @"T Rex Roar-SoundBible.com-394562851.wav"}};
  UIApplication *app = [UIApplication sharedApplication];

  [[app delegate] application:app didReceiveRemoteNotification:userInfo];
}

@end
