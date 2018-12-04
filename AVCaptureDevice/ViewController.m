//
//  ViewController.m
//  AVCaptureDevice
//
//  Created by mac on 2018/11/13.
//  Copyright © 2018 FengMap. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface ViewController () <AVCapturePhotoCaptureDelegate, AVCaptureMetadataOutputObjectsDelegate, AVCaptureVideoDataOutputSampleBufferDelegate>

@property (nonatomic, strong) AVCaptureSession *session;
@property (nonatomic, strong) AVCaptureDeviceInput *input;
@property (nonatomic, strong) AVCapturePhotoOutput *output;
@property (nonatomic, strong) AVCaptureMovieFileOutput *movieOutput;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *layer;
@property (nonatomic, strong) AVCaptureMetadataOutput *metadataOutput;
@property (nonatomic, strong) AVCaptureVideoDataOutput *videoOutput;
@property (nonatomic, strong) AVCaptureDevice *device;
@property (nonatomic, strong) UILabel *label;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    NSError *error;
    self.input = [AVCaptureDeviceInput deviceInputWithDevice:_device error:&error];
    
//    AVCaptureDeviceDiscoverySession *discoverySession = [AVCaptureDeviceDiscoverySession discoverySessionWithDeviceTypes:@[AVCaptureDeviceTypeBuiltInWideAngleCamera] mediaType:AVMediaTypeVideo position:AVCaptureDevicePositionBack];
//    NSArray<AVCaptureDevice *> *devices = discoverySession.devices;
    if ([_device isAutoFocusRangeRestrictionSupported]) {
        NSError *error;
        [_device lockForConfiguration:&error];
        _device.autoFocusRangeRestriction = AVCaptureAutoFocusRangeRestrictionNear;
        [_device unlockForConfiguration];
    }
    
    self.session.sessionPreset = AVCaptureSessionPreset640x480;
    
    if ([self.session canAddInput:_input]) {
        [_session addInput:_input];
    }
    
    _output = [[AVCapturePhotoOutput alloc] init];
    if ([_session canAddOutput:_output]) {
        [_session addOutput:_output];
    }
    
    _videoOutput = [[AVCaptureVideoDataOutput alloc] init];
    if ([self.session canAddOutput:_videoOutput]) {
        [self.session addOutput:_videoOutput];
        _videoOutput.videoSettings = @{(id)kCVPixelBufferPixelFormatTypeKey: @(kCVPixelFormatType_32BGRA)};
        [_videoOutput setSampleBufferDelegate:self queue:dispatch_get_main_queue()];
    }
    
    _metadataOutput = [[AVCaptureMetadataOutput alloc] init];
    if ([self.session canAddOutput:_metadataOutput]) {
        [self.session addOutput:_metadataOutput];
        _metadataOutput.metadataObjectTypes = @[AVMetadataObjectTypeFace, AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeQRCode];
        [_metadataOutput setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    }
    
    _movieOutput = [[AVCaptureMovieFileOutput alloc] init];
    if ([self.session canAddOutput:_movieOutput]) {
//        [self.session addOutput:_movieOutput];
    }
    
    _layer = [AVCaptureVideoPreviewLayer layerWithSession:_session];
    _layer.frame = self.view.bounds;
    [self.view.layer addSublayer:_layer];
    
    //启动捕捉
    [self.session startRunning];

    _label = [[UILabel alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - 30, CGRectGetWidth(self.view.bounds), 30)];
    [self.view addSubview:_label];
}

//切换
- (AVCaptureDeviceInput *)switchCameraWithPosition:(AVCaptureDevicePosition)position {
    
    if (![[self class] canSwitchCamera]) {
        return self.input;
    }
    
    AVCaptureDevice *device = [[self class] cameraWithPosition:position];
    
    NSError *error;
    AVCaptureDeviceInput *input  = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
    _device = device;
    return input;
}
//切换相机
+ (AVCaptureDevice *)cameraWithPosition:(AVCaptureDevicePosition)position {
    if (position == AVCaptureDevicePositionBack) {
        position = AVCaptureDevicePositionFront;
    } else if (position == AVCaptureDevicePositionFront) {
        position = AVCaptureDevicePositionBack;
    } else {
        position = AVCaptureDevicePositionUnspecified;
    }
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    AVCaptureDevice *newDevice;
    for (AVCaptureDevice *device in devices) {
        if (device.position == position) {
            newDevice = device;
            break;
        }
    }
    return newDevice;
}

+ (BOOL)canSwitchCamera {
    return [[AVCaptureDevice  devicesWithMediaType:AVMediaTypeVideo] count] > 1;
}

- (AVCaptureSession *)session {
    if (!_session) {
        _session = [[AVCaptureSession alloc] init];
    }
    return _session;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    [self.output capturePhotoWithSettings:[AVCapturePhotoSettings photoSettings] delegate:self];
}

//切换摄像头
- (void)switchCamera {
    [self.session beginConfiguration];
    //删除原来的输入
    [self.session removeInput:_input];
    
    _input = [self switchCameraWithPosition:_device.position];
    //添加新的输入
    if ([self.session canAddInput:_input]) {
        [self.session addInput:_input];
    }
    
    //切换完成后提交
    [self.session commitConfiguration];
}

- (void)captureOutput:(AVCapturePhotoOutput *)output didFinishProcessingPhoto:(AVCapturePhoto *)photo error:(NSError *)error  API_AVAILABLE(ios(11.0)){
    if (@available(iOS 11.0, *)) {
        NSData *data = [photo fileDataRepresentation];
        UIImage *image = [UIImage imageWithData:data];
        UIImageWriteToSavedPhotosAlbum(image, self, nil, nil);
    }
}

- (void)captureOutput:(AVCapturePhotoOutput *)output didFinishProcessingPhotoSampleBuffer:(CMSampleBufferRef)photoSampleBuffer previewPhotoSampleBuffer:(CMSampleBufferRef)previewPhotoSampleBuffer resolvedSettings:(AVCaptureResolvedPhotoSettings *)resolvedSettings bracketSettings:(AVCaptureBracketedStillImageSettings *)bracketSettings error:(NSError *)error {
    
    NSData *data = [AVCapturePhotoOutput JPEGPhotoDataRepresentationForJPEGSampleBuffer:photoSampleBuffer previewPhotoSampleBuffer:previewPhotoSampleBuffer];
    UIImage *image = [UIImage imageWithData:data];
    UIImageWriteToSavedPhotosAlbum(image, self, nil, nil);
}

- (void)captureOutput:(AVCaptureOutput *)output didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {
//    CVPixelBufferRef buffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    
    CMFormatDescriptionRef formatDescription = CMSampleBufferGetFormatDescription(sampleBuffer);
    CMMediaType type = CMFormatDescriptionGetMediaType(formatDescription);
    CFDictionaryRef info = (CFDictionaryRef)CMGetAttachment(sampleBuffer, kCGImagePropertyExifDictionary, NULL);
    NSLog(@"%@", info);
        
    if (type == kCMMediaType_Video) {
        NSLog(@"video");
    }
    
//    CVPixelBufferLockBaseAddress(buffer, 0);
//
//    size_t width = CVPixelBufferGetWidth(buffer);
//    size_t height = CVPixelBufferGetHeight(buffer);
//    unsigned char *pixel = (unsigned char *)CVPixelBufferGetBaseAddress(buffer);
//    unsigned char grayPixel;
//
//    for (int i = 0; i< height; i++) {
//        for (int j = 0; j<width; j++) {
//            grayPixel = (pixel[0] + pixel[1] + pixel[2]) / 3;
//            pixel[0] = pixel[1] = pixel[2] = grayPixel;
//            pixel += 4;
//        }
//    }
//    CVPixelBufferUnlockBaseAddress(buffer, 0);
}

- (void)captureOutput:(AVCaptureOutput *)output didDropSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {
    NSLog(@"丢帧");
    CVPixelBufferRef buffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    
//    CVPixelBufferLockBaseAddress(buffer, 0);
//
//    size_t width = CVPixelBufferGetWidth(buffer);
//    size_t height = CVPixelBufferGetHeight(buffer);
//    unsigned char *pixel = (unsigned char *)CVPixelBufferGetBaseAddress(buffer);
//    unsigned char grayPixel;
//
//    for (int i = 0; i< height; i++) {
//        for (int j = 0; j<width; j++) {
//            grayPixel = (pixel[0] + pixel[1] + pixel[2]) / 3;
//            pixel[0] = pixel[1] = pixel[2] = grayPixel;
//            pixel += 4;
//        }
//    }
//    CVPixelBufferUnlockBaseAddress(buffer, 0);
}

//人脸识别的回调
- (void)captureOutput:(AVCaptureOutput *)output didOutputMetadataObjects:(NSArray<__kindof AVMetadataObject *> *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    
//    for (AVMetadataFaceObject *face in metadataObjects) {                   // 2
//        NSLog(@"Face detected with ID: %li", (long)face.faceID);
//        NSLog(@"Face bounds: %@", NSStringFromCGRect(face.bounds));
//    }
//    for (AVMetadataMachineReadableCodeObject *obj in metadataObjects) {
//        NSLog(@"%@", obj.stringValue);
//        _label.text = obj.stringValue;
//    }
    
}


@end


