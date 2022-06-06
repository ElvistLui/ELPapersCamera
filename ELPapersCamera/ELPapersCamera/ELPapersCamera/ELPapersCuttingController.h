//
//  ELPapersCuttingController.h
//  ELPapersCamera
//
//  Created by Shitao Lv on 2021/12/12.
//  Copyright © 2021 xiaoxiao. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ELPapersMacro.h"

NS_ASSUME_NONNULL_BEGIN

/// 选择照片后手动裁切
@interface ELPapersCuttingController : UIViewController

/// 要裁切的图片
@property (nonatomic, strong) UIImage *originalImage;
/// 拍摄的证件类型
@property (nonatomic, assign) ELCameraTypeCode typeCode;
/// 拍照并确定后的回调
@property (nonatomic, copy) ELPapersCameraImageBlock imageBlock;

@end

NS_ASSUME_NONNULL_END
