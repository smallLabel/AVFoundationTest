//
//  ViewController.m
//  媒体组合
//
//  Created by smallLabel on 2018/12/2.
//  Copyright © 2018 FengMap. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSURL *wav = [[NSBundle mainBundle] URLForResource:@"awake.wav" withExtension:nil];
    NSURL *mov = [[NSBundle mainBundle] URLForResource:@"test.mov" withExtension:nil];
    
    AVAsset *asset1 = [AVURLAsset URLAssetWithURL:wav options:@{AVURLAssetPreferPreciseDurationAndTimingKey: @YES}];
    AVAsset *asset2 = [AVURLAsset URLAssetWithURL:mov options:@{AVURLAssetPreferPreciseDurationAndTimingKey: @YES}];
    
    NSArray *keys = @[@"tracks", @"duration", @"commonMetadata"];
    [asset1 loadValuesAsynchronouslyForKeys:keys completionHandler:^{
        
    }];
    [asset2 loadValuesAsynchronouslyForKeys:keys completionHandler:^{
        
    }];
    
    
    NSDictionary *time = CFBridgingRelease(CMTimeCopyAsDictionary(kCMTimeZero, NULL));
    CMTimeMakeFromDictionary((__bridge CFDictionaryRef)(time));
    


}


@end
