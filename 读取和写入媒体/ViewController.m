//
//  ViewController.m
//  读取和写入媒体
//
//  Created by smallLabel on 2018/11/28.
//  Copyright © 2018 FengMap. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "SLSampleDataProvider.h"

@interface ViewController ()
@property (nonatomic, strong) AVAssetReader *reader;
@property (nonatomic, strong) AVAssetWriter *writer;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self audioVisualization];
}

//音频可视化
- (void)audioVisualization {
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"test.mov" withExtension:nil];
    AVAsset *asset = [AVAsset assetWithURL:url];
    [SLSampleDataProvider loadAudioSampleDataFromAsset:asset complete:^(NSData * _Nonnull data) {
        
    }];
}

//按帧读取数据和写入数据
- (void)readAndWrite {
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"test.mov" withExtension:nil];
    AVAsset *asset = [AVAsset assetWithURL:url];
    AVAssetTrack *track = [asset tracksWithMediaType:AVMediaTypeVideo].firstObject;
    
    NSError *error;
    self.reader = [[AVAssetReader alloc] initWithAsset:asset error:&error];
    NSLog(@"%@", error.localizedDescription);
    
    NSDictionary *readerOutputSetting = @{(id)kCVPixelBufferPixelFormatTypeKey: @(kCVPixelFormatType_32BGRA)};
    
    AVAssetReaderTrackOutput *trackOutput = [AVAssetReaderTrackOutput assetReaderTrackOutputWithTrack:track outputSettings:readerOutputSetting];
    
    [self.reader addOutput:trackOutput];
    [self.reader startReading];
    
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:@"test.mov"];
    
    //用URLWithString:会崩溃
    self.writer = [[AVAssetWriter alloc] initWithURL:[NSURL fileURLWithPath:path] fileType:AVFileTypeQuickTimeMovie error:&error];
    NSLog(@"%@", error.localizedDescription);
    
    NSDictionary *inputSetting = @{AVVideoCodecKey: AVVideoCodecTypeH264, AVVideoWidthKey: @1280, AVVideoHeightKey: @720, AVVideoCompressionPropertiesKey: @{AVVideoMaxKeyFrameIntervalKey:@1, AVVideoAverageBitRateKey: @10500000, AVVideoProfileLevelKey: AVVideoProfileLevelH264Main31}};
    AVAssetWriterInput *input = [[AVAssetWriterInput alloc] initWithMediaType:AVMediaTypeVideo outputSettings:inputSetting];
    [self.writer addInput:input];
    [self.writer startWriting];
    
    [self.writer startSessionAtSourceTime:kCMTimeZero];
    [input requestMediaDataWhenReadyOnQueue:dispatch_get_main_queue() usingBlock:^{
        BOOL complete = NO;
        while ([input isReadyForMoreMediaData] && !complete) {
            CMSampleBufferRef buffer = [trackOutput copyNextSampleBuffer];
            if (buffer) {
                BOOL result = [input appendSampleBuffer:buffer];
                CFRelease(buffer);
                complete = !result;
            } else {
                [input markAsFinished];
                complete = YES;
            }
        }
        
        if (complete) {
            [self.writer finishWritingWithCompletionHandler:^{
                NSLog(@"完成");
            }];
        }
        NSLog(@"%@", path);
    }];
}


@end
