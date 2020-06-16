//
//  ELPapersClipViewController.h
//  ELPapersCamera
//
//  Created by Elvist on 2020/6/13.
//  Copyright © 2020 xiaoxiao. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ELPapersMacro.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ELPapersClipViewControllerDelegate <NSObject>

/// 重拍
- (void)ELPapersClipViewControllerClickRemake;
/// 完成
- (void)ELPapersClipViewControllerClickDetermine;

@end

@interface ELPapersClipViewController : UIViewController

@property (nonatomic, weak) id<ELPapersClipViewControllerDelegate> delegate;

/// 显示裁切后的图片
/// @param image 裁切后的图片
/// @param typeCode 拍摄类型
- (void)setImage:(UIImage *)image typeCode:(ELCameraTypeCode)typeCode;

@end

NS_ASSUME_NONNULL_END
