//
//  CNRViewController.m
//  Rawr
//
//  Created by Greg W on 2013-10-30.
//  Copyright (c) 2013 G Waterhouse. All rights reserved.
//

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

  AVAudioSession *session = [AVAudioSession sharedInstance];
  if (![session setCategory:AVAudioSessionCategoryPlayback error:nil]) {
    NSLog(@"Unable to set playback audio session!");
  }
  [self.audioPlayer prepareToPlay];
}

- (void)didTapView:(UITapGestureRecognizer *)sender
{
  [(CNRAppDelegate *)[[UIApplication sharedApplication] delegate] playBundleResourceSound:@"T Rex Roar-SoundBible.com-394562851.wav"];
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
