//
//  ELPapersContentView.h
//  ELPapersCamera
//
//  Created by Elvist on 2020/6/13.
//  Copyright © 2020 xiaoxiao. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ELPapersMacro.h"

NS_ASSUME_NONNULL_BEGIN

@interface ELPapersContentView : UIView

@property (nonatomic, strong) UILabel *titleLabel;  ///< 描述
@property (nonatomic, strong) UILabel *descLabel;   ///< 描述

@property (nonatomic,assign) ELCameraTypeCode typeCode;

@end

NS_ASSUME_NONNULL_END
