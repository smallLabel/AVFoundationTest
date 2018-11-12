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
    NSURL *URL = [[NSBundle mainBundle] URLForResource:@"test" withExtension:@"mp4"];
    AVAsset *asset = [AVAsset assetWithURL:URL];
    //获取文件中所有的元数据
    NSArray *keys = @[@"metadata"];
    [asset loadValuesAsynchronouslyForKeys:keys completionHandler:^{
        
        NSArray *items = asset.metadata;
        NSString *keySpace = AVMetadataKeySpaceiTunes;
        NSString *artitsKey = AVMetadataiTunesMetadataKeyArtist;
        NSString *albumKey = AVMetadataiTunesMetadataKeyAlbum;
        NSArray *artistData = [AVMetadataItem metadataItemsFromArray:items withKey:artitsKey keySpace:keySpace];
        NSArray *albumData = [AVMetadataItem metadataItemsFromArray:items withKey:albumKey keySpace:keySpace];
        
        if (artistData.count > 0) {
            NSLog(@"%@", artistData.firstObject);
        }
        if (albumData.count > 0) {
            NSLog(@"%@", albumData.firstObject);
        }
        
    }];
    
    
    
}


@end
