//
//  ELPapersCamera.h
//  ELPapersCamera
//
//  Created by Elvist on 2020/6/22.
//  Copyright © 2020 xiaoxiao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "ELPapersMacro.h"

NS_ASSUME_NONNULL_BEGIN

@interface ELPapersCamera : NSObject

@property (nonatomic, copy) ELPapersCameraImageBlock imageBlock;  ///< 拍照并确定后的回调

+ (instancetype)shared;
- (void)showFromViewController:(UIViewController *)viewController typeCode:(ELCameraTypeCode)typeCode;

@end

NS_ASSUME_NONNULL_END
