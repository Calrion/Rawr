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

@end

@implementation CNRViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(didTapView:)]];
}

- (void)didTapView:(UITapGestureRecognizer *)sender
{
  [(CNRAppDelegate *)[[UIApplication sharedApplication] delegate]
   playBundleResourceSound:nil];
}

#pragma mark - Memory Management
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
