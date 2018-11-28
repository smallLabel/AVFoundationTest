//
//  ViewController.m
//  读取和写入媒体
//
//  Created by smallLabel on 2018/11/28.
//  Copyright © 2018 FengMap. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>


@interface ViewController ()
@property (nonatomic, strong) AVAssetReader *reader;
@property (nonatomic, strong) AVAssetWriter *writer;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"test.mov" withExtension:nil];
    AVAsset *asset = [AVAsset assetWithURL:url];
    AVAssetTrack *track = [asset tracksWithMediaType:AVMediaTypeVideo].firstObject;
    
    NSError *error;
    self.reader = [[AVAssetReader alloc] initWithAsset:asset error:&error];
    
    NSDictionary *readerOutputSetting = @{(id)kCVPixelBufferPixelFormatTypeKey: @(kCVPixelFormatType_32BGRA)};
    
    AVAssetReaderTrackOutput *trackOutput = [AVAssetReaderTrackOutput assetReaderTrackOutputWithTrack:track outputSettings:readerOutputSetting];
    
    [self.reader addOutput:trackOutput];
    [self.reader startReading];
    
    while (self.reader.status == AVAssetReaderStatusReading) {
        
    }
    
}




@end
