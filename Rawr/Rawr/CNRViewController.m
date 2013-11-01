//
//  CNRViewController.m
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
#import "CNRViewController.h"
#import "CNRAppDelegate.h"

@interface CNRViewController ()

@property (strong, nonatomic, readonly) AVAudioPlayer *audioPlayer;

@end

@implementation CNRViewController
@synthesize audioPlayer = _audioPlayer;

- (void)viewDidLoad
{
  [super viewDidLoad];
  [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(didTapView:)]];

//  AVAudioSession *session = [AVAudioSession sharedInstance];
//  if (![session setCategory:AVAudioSessionCategoryPlayback error:nil]) {
//    NSLog(@"Unable to set playback audio session!");
//  }
//  [self.audioPlayer prepareToPlay];
}

- (void)didTapView:(UITapGestureRecognizer *)sender
{
  [(CNRAppDelegate *)[[UIApplication sharedApplication] delegate] playBundleResourceSound:nil];
//  if (!self.audioPlayer.playing) {
//    [self.audioPlayer play];
//  }
}

#pragma mark - Properties
- (AVAudioPlayer *)audioPlayer
{
  NSURL * const wavFile = [[[NSBundle mainBundle] resourceURL]
                           URLByAppendingPathComponent:@"T Rex Roar-SoundBible.com-394562851.wav"];

  if (!_audioPlayer) {
    _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:wavFile
                                                          error:nil];
  }
  return _audioPlayer;
}

#pragma mark - Memory Management
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
