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
@property (nonatomic, strong) AVAssetImageGenerator *imageGenerator;
@property (nonatomic, strong) AVAsset *asset;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"test" withExtension:@"mov"];
    _asset = [AVAsset assetWithURL:url];
    NSArray *keys = @[
                      @"tracks",
                      @"duration",
                      @"commonMetadata",
                      @"availableMediaCharacteristicsWithMediaSelectionOptions"
                      ];
//    AVPlayerItem *playItem = [[AVPlayerItem alloc] initWithAsset:_asset automaticallyLoadedAssetKeys:keys];
//    AVPlayer *player = [[AVPlayer alloc] initWithPlayerItem:playItem];

    [self generatorThumbnails];
    
//    [asset loadValuesAsynchronouslyForKeys:@[@"availableMediaCharacteristicsWithMediaSelectionOptions"] completionHandler:^{
//        NSArray *options = asset.availableMediaCharacteristicsWithMediaSelectionOptions;
//        for (NSString *content in options) {
//            NSLog(@"%@", content);
//        }
//    }];
    
    
//    self.player = player;
//    AVPlayerLayer *playLayer = [AVPlayerLayer playerLayerWithPlayer:player];
//    playLayer.frame = self.view.bounds;
//    [self.view.layer addSublayer:playLayer];
//
//
//    [playItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:&PlayerItemStatusContext];
}


- (void)generatorThumbnails {
    self.imageGenerator = [AVAssetImageGenerator assetImageGeneratorWithAsset:_asset];
    self.imageGenerator.maximumSize = CGSizeMake(0.0f, 900000.0f);
    //视频总长
    CMTime duration = self.asset.duration;
    //转换为秒
    Float64 durationSeconds = CMTimeGetSeconds(duration);
    //保存每一帧的时间
    NSMutableArray *times = [NSMutableArray array];
    Float64 totalFrame = durationSeconds * 1;//24：fps
    
    for (int i = 1; i <= totalFrame ; i++) {
        //每一帧的时间
        CMTime timeFrame = CMTimeMake(i, totalFrame);//第i帧  总帧数
        NSValue *value = [NSValue valueWithCMTime:timeFrame];
        [times addObject:value];
    }
    
    //文档显示设置为kCMTimeZero 如果不设置，生成的图片可能有偏差
    self.imageGenerator.requestedTimeToleranceAfter = kCMTimeZero;
    self.imageGenerator.requestedTimeToleranceBefore = kCMTimeZero;
    
    [self.imageGenerator generateCGImagesAsynchronouslyForTimes:times completionHandler:^(CMTime requestedTime, CGImageRef  _Nullable image, CMTime actualTime, AVAssetImageGeneratorResult result, NSError * _Nullable error) {
        if (result == AVAssetImageGeneratorSucceeded) {
            //写入相册
            UIImage *uiimage = [UIImage imageWithCGImage:image];
            UIImageWriteToSavedPhotosAlbum(uiimage, self, nil, nil);
        } else if (result == AVAssetImageGeneratorFailed) {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
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
