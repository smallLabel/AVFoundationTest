//
//  ViewController.m
//  Audio
//
//  Created by FengMapMBP2014 on 2018/10/30.
//  Copyright © 2018年 FengMap. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface ViewController ()

@property (nonatomic, strong) AVAudioPlayer *audioPlayer;
@property (nonatomic, strong) AVAudioRecorder *audioRecorder;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self record];
}
- (IBAction)playRecord:(id)sender {
    [self play];
}
- (IBAction)startRecord:(id)sender {
    UIButton *button = (UIButton *)sender;
    button.selected = !button.selected;
    if (button.selected) {
        [_audioRecorder record];  
    } else {
        [_audioRecorder stop];
    }
}

//录音
- (void)record {

    NSString *directory = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    directory = [directory stringByAppendingPathComponent:@"voi.caf"];
    NSURL *url = [NSURL URLWithString:directory];
    NSDictionary *setting = @{AVFormatIDKey: @(kAudioFormatAppleIMA4),
                              AVSampleRateKey: @44100.0f,
                              AVNumberOfChannelsKey: @1,
                              AVEncoderBitDepthHintKey: @16,
                              AVEncoderAudioQualityKey: @(AVAudioQualityMedium)
                              };
    NSError *error = nil;
    _audioRecorder = [[AVAudioRecorder alloc] initWithURL:url settings:setting error:&error];
    if (_audioRecorder) {
        [_audioRecorder prepareToRecord];
    } else {
        //创建失败
        NSLog(@"%@", error.localizedDescription);
    }
}
//播放音频
- (void)play {
//    NSURL *url = [[NSBundle mainBundle] URLForResource:@"awake" withExtension:@"wav"];
    NSString *directory = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    directory = [directory stringByAppendingPathComponent:@"voi.caf"];
    NSURL *url = [NSURL URLWithString:directory];
    NSError *error = nil;
    _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    
    if (error) {
        NSLog(@"create error:%@", error.localizedDescription);
        return;
    }
    //允许控制播放速率 注意调用此方法要在prepareToPlay之前
    //set this property to YES after you initialize the player and before you call the prepareToPlay instance method for the player.
    _audioPlayer.enableRate = YES;
    //准备播放 建议显式调用
    [_audioPlayer prepareToPlay];
    //播放
    [_audioPlayer play];
    //循环次数  -1无限循环
    _audioPlayer.numberOfLoops = -1;
    
    NSNotificationCenter *nsnc = [NSNotificationCenter defaultCenter];
    [nsnc addObserver:self
             selector:@selector(handleInterrupt:)
                 name:AVAudioSessionInterruptionNotification
               object:[AVAudioSession sharedInstance]];
    [nsnc addObserver:self
             selector:@selector(handleRouteChanged:)
                 name:AVAudioSessionRouteChangeNotification
               object:[AVAudioSession sharedInstance]];
}

- (void)handleRouteChanged:(NSNotification *)notification {
    NSDictionary *userInfo = notification.userInfo;
    //线路发生变更原因
    AVAudioSessionRouteChangeReason reason = [userInfo[AVAudioSessionRouteChangeReasonKey] unsignedIntegerValue];
    if (reason == AVAudioSessionRouteChangeReasonOldDeviceUnavailable) {
        //获取上一次路线状态
        AVAudioSessionRouteDescription *previousRoute = userInfo[AVAudioSessionRouteChangePreviousRouteKey];
        //获取第一个输出接口
        AVAudioSessionPortDescription *portDescription = previousRoute.outputs[0];
        if ([portDescription.portType isEqualToString:AVAudioSessionPortHeadphones]) {
            //判断上一次是耳机状态
        }
    }
    
}

- (void)handleInterrupt:(NSNotification *)notification {
    NSDictionary *userInfo = notification.userInfo;
    AVAudioSessionInterruptionType type = [userInfo[AVAudioSessionInterruptionTypeKey] unsignedIntegerValue];
    
    
    if (type == AVAudioSessionInterruptionTypeBegan) {
        //中断开始
    } else if (type == AVAudioSessionInterruptionTypeEnded) {
        //中断恢复
    }
}
//播放速率
- (IBAction)rateChanged:(id)sender {
    UISlider *slider = (UISlider *)sender;
    _audioPlayer.rate = slider.value;
    
}
//立体声道
- (IBAction)panChanged:(id)sender {
    UISlider *slider = (UISlider *)sender;
    _audioPlayer.pan = slider.value;
}
//音量
- (IBAction)volumeChanged:(id)sender {
    UISlider *slider = (UISlider *)sender;
    _audioPlayer.volume = slider.value;
}


@end
