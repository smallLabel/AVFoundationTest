//
//  ViewController.m
//  AVPlayer
//
//  Created by mac on 2018/11/12.
//  Copyright © 2018 FengMap. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>

static const NSString *PlayerItemStatusContext;

@interface ViewController ()

@property (nonatomic, strong) AVPlayer *player;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"test" withExtension:@"mov"];
    AVAsset *asset = [AVAsset assetWithURL:url];
    AVPlayerItem *playItem = [[AVPlayerItem alloc] initWithAsset:asset];
    AVPlayer *player = [[AVPlayer alloc] initWithPlayerItem:playItem];
    [player addPeriodicTimeObserverForInterval:kCMTimeZero queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        
    }];
    
    AVAssetImageGenerator
    
    self.player = player;
    AVPlayerLayer *playLayer = [AVPlayerLayer playerLayerWithPlayer:player];
    playLayer.frame = self.view.bounds;
    [self.view.layer addSublayer:playLayer];
    
    [playItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:&PlayerItemStatusContext];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if (context == &PlayerItemStatusContext) {
        AVPlayerItem *item = (AVPlayerItem *)object;
        if (item.status == AVPlayerItemStatusReadyToPlay) {
            [self.player play];
        }
    }
}


@end
