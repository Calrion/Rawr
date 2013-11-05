//
//  RawrTests.m
//  RawrTests
//
//  Created by Greg W on 2013-10-30.
//  Copyright (c) 2013 Greg Waterhouse.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
// 
//     http://www.apache.org/licenses/LICENSE-2.0
// 
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

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
  NSDictionary * const userInfo = @{@"aps": @{@"sound": @"dinosaur.wav"},
                                    @"request_id": @23};
  UIApplication *app = [UIApplication sharedApplication];

  // This is really just an easier way to debug notifications
  [[app delegate] application:app didReceiveRemoteNotification:userInfo];
}

@end
