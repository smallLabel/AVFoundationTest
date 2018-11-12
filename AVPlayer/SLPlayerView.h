//
//  SLPlayerView.h
//  AVPlayer
//
//  Created by mac on 2018/11/12.
//  Copyright © 2018 FengMap. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SLPlayerView : UIView

- (instancetype)initWithPlayer:(AVPlayer *)player;

@end

NS_ASSUME_NONNULL_END
