//
//  ELPapersPhotographer.h
//  ELPapersPhotographer
//
//  Created by Elvist on 2020/6/13.
//  Copyright © 2020 xiaoxiao. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ELPapersMacro.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^ELPapersPhotographerBlock)(UIImage * _Nullable image);

@interface ELPapersPhotographer : NSObject

/// 设置相机
- (void)setupCameraWithViewController:(UIViewController *)vc;
/// 拍摄
- (void)takeImage:(ELPapersPhotographerBlock)block;
/// 开始/恢复拍摄
- (void)start;
/// 停止拍摄
- (void)stop;

@end

NS_ASSUME_NONNULL_END
