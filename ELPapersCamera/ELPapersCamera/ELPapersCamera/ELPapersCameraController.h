//
//  ELPapersCameraController.h
//  ELPapersCamera
//
//  Created by Elvist on 2020/6/13.
//  Copyright © 2020 xiaoxiao. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ELPapersMacro.h"

NS_ASSUME_NONNULL_BEGIN

/// 拍摄画面
@interface ELPapersCameraController : UIViewController

/// 拍摄的证件类型
@property (nonatomic, assign) ELCameraTypeCode typeCode;
/// 拍照并确定后的回调
@property (nonatomic, copy) ELPapersCameraImageBlock imageBlock;

@end

NS_ASSUME_NONNULL_END
