//
//  SLPlayerView.m
//  AVPlayer
//
//  Created by mac on 2018/11/12.
//  Copyright © 2018 FengMap. All rights reserved.
//

#import "SLPlayerView.h"

@implementation SLPlayerView

+ (Class)class {
    return [AVPlayerLayer class];
}

- (instancetype)initWithPlayer:(AVPlayer *)player {
    if (self = [super initWithFrame:CGRectZero]) {
        self.backgroundColor = [UIColor blackColor];
        [(AVPlayerLayer *)[self layer] setPlayer:player];
    }
    return self;
}

@end
