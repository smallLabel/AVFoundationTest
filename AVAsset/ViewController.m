//
//  ViewController.m
//  AVAsset
//
//  Created by FengMapMBP2014 on 2018/10/30.
//  Copyright © 2018年 FengMap. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSURL *URL;
    AVAsset *asset = [AVAsset assetWithURL:URL];
    AVURLAsset *urlAsset = [[AVURLAsset alloc] initWithURL:URL options:@{}];
}


@end
