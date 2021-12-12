//
//  ELPapersPhotographer.m
//  ELPapersPhotographer
//
//  Created by Elvist on 2020/6/13.
//  Copyright © 2020 xiaoxiao. All rights reserved.
//

#import "ELPapersPhotographer.h"
#import <AVFoundation/AVFoundation.h>

@interface ELPapersPhotographer ()

@property (nonatomic, strong) AVCaptureSession *session;

@end

@implementation ELPapersPhotographer

#pragma mark - public
- (void)setupCameraWithViewController:(UIViewController *)vc {
    
    AVCaptureSession *session = [[AVCaptureSession alloc]init];
    _session = session;
 
    AVCaptureDevice *device = nil;
    NSArray *cameras = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *camera in cameras) {
        
        if(camera.position == AVCaptureDevicePositionBack) {
            
            device = camera;
        }
    }
    if(!device) {
        NJLog(@"取得后置摄像头错误");
        return;
    }
    NSError *error = nil;
    AVCaptureDeviceInput *captureInput = [[AVCaptureDeviceInput alloc] initWithDevice:device error:&error];
    if(error) {
        NJLog(@"创建输入数据对象错误");
        return;
    }
    
    AVCaptureStillImageOutput *imageOutput = [[AVCaptureStillImageOutput alloc] init];
    NSDictionary *setting = @{AVVideoCodecKey:AVVideoCodecJPEG};
    [imageOutput setOutputSettings:setting];
    
    if ([session canAddInput:captureInput]) {
        [session addInput:captureInput];
    }
    if ([session canAddOutput:imageOutput]) {
        [session addOutput:imageOutput];
    }
    
    AVCaptureVideoPreviewLayer *videoLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:session];
    videoLayer.frame = vc.view.bounds;
    videoLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    vc.view.layer.masksToBounds = YES;
    [vc.view.layer insertSublayer:videoLayer atIndex:0];
    
    [session startRunning];
}

- (void)takeImage:(ELPapersPhotographerBlock)block {
    
    AVCaptureStillImageOutput *output = _session.outputs.firstObject;
    AVCaptureConnection *connection = [output connectionWithMediaType:AVMediaTypeVideo];
    [output captureStillImageAsynchronouslyFromConnection:connection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error){
        
        if (imageDataSampleBuffer) {
            
            NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
            UIImage *image = [[UIImage alloc] initWithData:imageData];
            
            [self.session stopRunning];
            if (block) {
                block(image);
            }
        }
    }];
}

- (void)start {
    [_session startRunning];
}

- (void)stop {
    [_session stopRunning];
}

@end
