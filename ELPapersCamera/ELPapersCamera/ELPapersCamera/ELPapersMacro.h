//
//  ELPapersMacro.h
//  ELPapersCamera
//
//  Created by Elvist on 2020/6/13.
//  Copyright © 2020 xiaoxiao. All rights reserved.
//

#ifndef ELPapersMacro_h
#define ELPapersMacro_h

#ifdef __OBJC__

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#if __has_include(<Masonry/Masonry.h>)
#import <Masonry/Masonry.h>
#else
#import "Masonry.h"
#endif

#endif

typedef NS_ENUM(NSUInteger, ELCameraTypeCode) {
    ELCameraTypeNormal = 0, ///< 默认
    ELCameraTypeIdFront,    ///< 身份证正面
    ELCameraTypeIdBack,     ///< 身份证背面
    ELCameraTypeDriverFront,    ///< 驾驶证正面
    ELCameraTypeDriverBack,     ///< 驾驶证背面
};

//****** Frame相关 ******//
#define kScreenWidth    [UIScreen mainScreen].bounds.size.width
#define kScreenHeight   [UIScreen mainScreen].bounds.size.height

#define kWindow_StatusBarHeight     (kDevice_Is_iPhoneX ? 44 : 20)
#define kWindow_NavigationBarHeight (kWindow_StatusBarHeight + 44.f)

#define kWindow_IndicatorHeight (kDevice_Is_iPhoneX ? 34.f : 0)
#define kWindow_TabBarHeight    (49.f + kWindow_IndicatorHeight)

//****** 颜色相关 ******//
#define kRGBAColor(R,G,B,A) [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:A]
#define kRGBColor(A,B,C)    kRGBAColor(A,B,C,1.0)

//****** 判断当前iOS设备屏幕类型 ******//
#define kDevice_Is_iPhone4  ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)
#define kDevice_Is_iPhone5  ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define kDevice_Is_iPhone6  ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)
#define kDevice_Is_iPhone6Plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)
#define kDevice_Is_iPhoneX  (((int)((kScreenHeight/kScreenWidth)*100) == 216) ? YES : NO)

#define kELSafeValue(Value) Value ? Value : @""


#ifndef weakify
    #if DEBUG
        #if __has_feature(objc_arc)
            #define weakify(object) autoreleasepool{} __weak __typeof__(object) weak##_##object = object;
        #else
            #define weakify(object) autoreleasepool{} __block __typeof__(object) block##_##object = object;
        #endif
    #else
        #if __has_feature(objc_arc)
            #define weakify(object) try{} @finally{} {} __weak __typeof__(object) weak##_##object = object;
        #else
            #define weakify(object) try{} @finally{} {} __block __typeof__(object) block##_##object = object;
        #endif
    #endif
#endif

#ifndef strongify
    #if DEBUG
        #if __has_feature(objc_arc)
            #define strongify(object) autoreleasepool{} __typeof__(object) object = weak##_##object;
        #else
            #define strongify(object) autoreleasepool{} __typeof__(object) object = block##_##object;
        #endif
    #else
        #if __has_feature(objc_arc)
            #define strongify(object) try{} @finally{} __typeof__(object) object = weak##_##object;
        #else
            #define strongify(object) try{} @finally{} __typeof__(object) object = block##_##object;
        #endif
    #endif
#endif

#ifndef DDLog
#ifdef DEBUG
#   define DDLog(fmt, ...) NSLog((@"[Line %d] " fmt), __LINE__, ##__VA_ARGS__)    // 这个替换方法可以打印所在类
#else
#   define DDLog(...)
#endif
#endif

#endif /* ELPapersMacro_h */
