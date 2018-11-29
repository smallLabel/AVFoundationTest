//
//  SLSampleDataProvider.h
//  读取和写入媒体
//
//  Created by mac on 2018/11/29.
//  Copyright © 2018 FengMap. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^SLSampleDataCompleteBolck) (NSData *data);

@interface SLSampleDataProvider : NSObject

+ (void)loadAudioSampleDataFromAsset:(AVAsset *)asset complete:(SLSampleDataCompleteBolck)complete;

@end

NS_ASSUME_NONNULL_END
