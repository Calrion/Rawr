//
//  CNRAppDelegate.h
//  Rawr
//
//  Created by Greg W on 2013-10-30.
//  Copyright (c) 2013 G Waterhouse. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CNRViewController.h"

@interface CNRAppDelegate : UIResponder <UIApplicationDelegate,NSURLConnectionDataDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) CNRViewController *viewController;
@property (nonatomic, assign, readonly) BOOL registeredForPushNotifications;

- (BOOL)playBundleResourceSound:(NSString *)resource;
- (BOOL)playBundleResourceSound:(NSString *)resource forRequestID:(NSUInteger)requestID;

@end
