//
//  SLSampleDataProvider.m
//  读取和写入媒体
//
//  Created by mac on 2018/11/29.
//  Copyright © 2018 FengMap. All rights reserved.
//

#import "SLSampleDataProvider.h"

@implementation SLSampleDataProvider
+ (void)loadAudioSampleDataFromAsset:(AVAsset *)asset complete:(SLSampleDataCompleteBolck)complete {
    NSString *tracks = @"tracks";
    [asset loadValuesAsynchronouslyForKeys:@[tracks] completionHandler:^{
        NSError *error;
        AVKeyValueStatus status = [asset statusOfValueForKey:tracks error:&error];
        NSData *data = nil;
        if (status == AVKeyValueStatusLoaded) {
            data = [self readAudioSampleFromAsset:asset];
        }
        //可能异步队列
        dispatch_async(dispatch_get_main_queue(), ^{
            complete(data);
        });
        
    }];
}

+ (NSData *)readAudioSampleFromAsset:(AVAsset *)asset {
    NSError *error;
    AVAssetReader *reader = [[AVAssetReader alloc] initWithAsset:asset error:&error];
    if (error) {
        return nil;
    }
    
    
    AVAssetTrack *track = [asset tracksWithMediaType:AVMediaTypeAudio].firstObject;
    
    NSDictionary *outputSetting = @{AVFormatIDKey: @(kAudioFormatLinearPCM),
                                    AVLinearPCMIsBigEndianKey: @NO,
                                    AVLinearPCMIsFloatKey: @NO,
                                    AVLinearPCMBitDepthKey: @16
                                    };
    AVAssetReaderTrackOutput *output = [AVAssetReaderTrackOutput assetReaderTrackOutputWithTrack:track outputSettings:outputSetting];
    [reader addOutput:output];
    [reader startReading];
    
    NSMutableData *data = [NSMutableData data];
    
    while (reader.status == AVAssetReaderStatusReading) {
        CMSampleBufferRef buffer = [output copyNextSampleBuffer];
        if (buffer) {
            CMBlockBufferRef blockBuffer = CMSampleBufferGetDataBuffer(buffer);
            
            size_t length = CMBlockBufferGetDataLength(blockBuffer);
            
            SInt16 sampleBytes[length];
            
            CMBlockBufferCopyDataBytes(blockBuffer, 0, length, sampleBytes);
            
            [data appendBytes:sampleBytes length:length];
            
            CMSampleBufferInvalidate(buffer);
            CFRelease(buffer);
        }
    }
    return [data copy];
}

@end
