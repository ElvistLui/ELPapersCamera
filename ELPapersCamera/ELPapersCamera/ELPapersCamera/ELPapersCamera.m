//
//  ELPapersCamera.m
//  ELPapersCamera
//
//  Created by Elvist on 2020/6/22.
//  Copyright © 2020 xiaoxiao. All rights reserved.
//

#import "ELPapersCamera.h"
#import "ELPapersCameraController.h"

@interface ELPapersCamera ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@end

@implementation ELPapersCamera

+ (instancetype)shared {
    
    static ELPapersCamera *obj = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        obj = [[[self class] alloc] init];
    });
    return obj;
}

- (void)showFromViewController:(UIViewController *)viewController typeCode:(ELCameraTypeCode)typeCode {
    
    if (typeCode == ELCameraTypeAvatar) {
        
        UIImagePickerController *vc = [[UIImagePickerController alloc] init];
        vc.sourceType = UIImagePickerControllerSourceTypeCamera;
        vc.allowsEditing = YES;
        vc.delegate = self;
        [viewController presentViewController:vc animated:YES completion:nil];
    } else {
        
        @weakify(self);
        ELPapersCameraController *vc = [[ELPapersCameraController alloc] init];
        vc.typeCode = typeCode;
        vc.imageBlock = ^(ELCameraTypeCode typeCode, UIImage * _Nullable image) {
            
            if (weak_self.imageBlock) weak_self.imageBlock(typeCode, image);
        };
        [viewController presentViewController:vc animated:YES completion:nil];
    }
}

#pragma mark - UINavigationControllerDelegate
 
#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info {
    
    NJLog(@"%@", info);
    UIImage *image = info[UIImagePickerControllerEditedImage];
    [picker dismissViewControllerAnimated:YES completion:nil];
    if (self.imageBlock) {
        self.imageBlock(ELCameraTypeAvatar, image);
    }
}

@end
