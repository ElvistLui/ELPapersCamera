//
//  ELPapersCameraViewController.h
//  ELPapersCamera
//
//  Created by Elvist on 2020/6/13.
//  Copyright © 2020 xiaoxiao. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ELPapersMacro.h"

NS_ASSUME_NONNULL_BEGIN

@interface ELPapersCameraViewController : UIViewController

@property (nonatomic, assign) ELCameraTypeCode typeCode;    ///< 拍摄的证件类型
@property (nonatomic, copy) void (^imageBlock)(ELCameraTypeCode typeCode, UIImage * _Nullable image);  ///< 拍照并确定后的回调

@end

NS_ASSUME_NONNULL_END
