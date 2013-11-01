//
//  CNRAppDelegate.m
//  Rawr
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


#import <AVFoundation/AVFoundation.h>
#import "CNRAppDelegate.h"

#define REST_ENDPOINT @"https://secure.rgweb.org/rest/rawr/didPlaySound?deviceName=%@&deviceModel=%@&soundFile=%@&requestID=%ld"
#define REST_ENDPOINT_FAILURE @"https://secure.rgweb.org/rest/rawr/didPlaySound?deviceName=%@&deviceModel=%@&soundFile=%@&requestID=%ld&reason=%@"
#define DEFAULT_SOUND_FILENAME @"dinosaur.wav"

@interface CNRAppDelegate ()

@property (nonatomic, strong) AVAudioPlayer *player;
@property (nonatomic, strong) NSMutableData *restResponse;

- (void)postDidPlaySound:(NSString *)soundFile
            forRequestID:(NSUInteger)requestID;
- (void)postFailedToPlaySound:(NSString *)soundFile
             forRequestID:(NSUInteger)requestID
                   reason:(NSString *)reason;

@end

@implementation CNRAppDelegate {
  NSURLConnection *webService;
}
@synthesize registeredForPushNotifications = _registeredForPushNotifications;
@synthesize player = _player;
@synthesize restResponse = _restResponse;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  self.window = [[UIWindow alloc]
                 initWithFrame:[[UIScreen mainScreen] bounds]];
  self.viewController = [[CNRViewController alloc]
                         initWithNibName:@"Main"
                         bundle:nil];
  self.window.rootViewController = self.viewController;

  [UIApplication sharedApplication].idleTimerDisabled = YES;
  _registeredForPushNotifications = NO;
  [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeSound)];

  // Let's go!
  [self.window makeKeyAndVisible];
  return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
  // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
  // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
  // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
  // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
  // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
  // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
  // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - Properties


#pragma mark - Helpers
- (BOOL)playBundleResourceSound:(NSString *)resource
{
  return [self playBundleResourceSound:resource forRequestID:0];
}

- (BOOL)playBundleResourceSound:(NSString *)resource forRequestID:(NSUInteger)requestID
{
  BOOL didPlaySound = NO;

  if (!resource) resource = DEFAULT_SOUND_FILENAME;

  NSURL *soundToPlay = [[[NSBundle mainBundle] resourceURL]
                        URLByAppendingPathComponent:resource];

  AVAudioSession *session = [AVAudioSession sharedInstance];
  if (![session setCategory:AVAudioSessionCategoryPlayback error:nil]) {
    NSLog(@"Unable to set playback audio session!");
  }

  if (!self.player.playing) {
    self.player = [[AVAudioPlayer alloc]
                   initWithContentsOfURL:soundToPlay
                   error:nil];

    if (self.player) {
      [self.player prepareToPlay];
      [self.player play];
      NSLog(@"Played sound '%@'.", soundToPlay);
      [self postDidPlaySound:resource forRequestID:requestID];
      didPlaySound = YES;
    }
  }
  else {
    [self postFailedToPlaySound:resource
                   forRequestID:requestID
                         reason:@"alreadyPlaying"];
  }
  return didPlaySound;
}

#pragma mark - RESTful Web Service
- (void)postDidPlaySound:(NSString *)soundFile
            forRequestID:(NSUInteger)requestID
{
  if (requestID != 0) {
    NSString *escapedFile = [soundFile
              stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *requestURL = [NSString stringWithFormat:REST_ENDPOINT,
                            [[UIDevice currentDevice] name],
                            [[UIDevice currentDevice] model],
                            escapedFile,
                            (unsigned long)requestID];

    NSURLRequest *restRequest = [NSURLRequest
                                 requestWithURL:[NSURL
                                                 URLWithString:requestURL]];
    if (webService) {
      NSLog(@"Cancelling existing connection.");
      [webService cancel];
      webService = nil;
    }

    // These need to be separate statements; the if
    // statement above should enable the one below.
    if (!webService) {
      NSLog(@"Sending did play sound notification for '%@' and request %ld.",
            soundFile, (unsigned long)requestID);
      webService = [[NSURLConnection alloc] initWithRequest:restRequest delegate:self];
    }
  }
}

- (void)postFailedToPlaySound:(NSString *)soundFile
             forRequestID:(NSUInteger)requestID
                   reason:(NSString *)reason
{
  if (requestID != 0) {
    NSString *escapedFile = [soundFile
                             stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *requestURL = [NSString stringWithFormat:REST_ENDPOINT_FAILURE,
                            [[UIDevice currentDevice] name],
                            [[UIDevice currentDevice] model],
                            escapedFile,
                            (unsigned long)requestID,
                            reason];

    NSURLRequest *restRequest = [NSURLRequest
                                 requestWithURL:[NSURL
                                                 URLWithString:requestURL]];
    if (webService) {
      NSLog(@"Cancelling existing connection.");
      [webService cancel];
      webService = nil;
    }
    else {
      NSLog(@"Sending failed to play sound notification for '%@' and request %ld.",
            soundFile, (unsigned long)requestID);
      webService = [[NSURLConnection alloc] initWithRequest:restRequest delegate:self];
    }
  }
}

#pragma mark - NSURLConnectionDelegate
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
  if (![response isKindOfClass:[NSHTTPURLResponse class]]) {
    NSLog(@"Received non-HTTP response!");
    return;
  }

  NSLog(@"Received REST response with status %ld - %@.",
        ((long)(((NSHTTPURLResponse *)response).statusCode)),
        [NSHTTPURLResponse localizedStringForStatusCode:((NSHTTPURLResponse *)response).statusCode]);
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
  if (!self.restResponse) {
    self.restResponse = [[NSMutableData alloc] initWithData:data];
  }
  else {
    [self.restResponse appendData:data];
  }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
  //NSLog(@"REST response body is: %@", self.restResponse);
  NSString *body = [[NSString alloc] initWithData:self.restResponse
                                         encoding:NSUTF8StringEncoding];
  NSLog(@"REST response body is: \"%@\"", body);
  self.restResponse = nil;
  [webService cancel];
  webService = nil;
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
  NSLog(@"REST request failed with error %@", error);
  self.restResponse = nil;
  [webService cancel];
  webService = nil;
}

#pragma mark - Push Notifications
- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)devToken
{
  _registeredForPushNotifications = YES;
  NSLog(@"APNS Device token is: \"%@\".", devToken);
}

- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)err
{
  NSLog(@"Error in registration. Error: %@", err);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
  NSLog(@"Received APNS with userInfo %@", userInfo);
  NSDictionary *apnsPayload = [NSDictionary dictionaryWithDictionary:userInfo];
  if ([apnsPayload valueForKey:@"aps"] != nil) {
    NSDictionary *aps = [apnsPayload valueForKey:@"aps"];
    if ([aps valueForKey:@"sound"] != nil) {
      NSString *sound = [aps valueForKey:@"sound"];
      NSLog(@"Playing '%@' in response to APNS message.", sound);
      if ([self playBundleResourceSound:sound
                       forRequestID:[[apnsPayload valueForKey:@"request_id"]
                                     unsignedIntegerValue]]) {
        NSLog(@"PLAYED APNS SOUND");
      }
      else {
        NSLog(@"NO PLAY APNS SOUND");
      }
    }
  }
}

@end
