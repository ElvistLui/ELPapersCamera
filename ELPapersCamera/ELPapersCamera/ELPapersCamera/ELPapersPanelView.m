//
//  ELPapersPanelView.m
//  ELPapersCamera
//
//  Created by Elvist on 2020/6/13.
//  Copyright © 2020 xiaoxiao. All rights reserved.
//

#import "ELPapersPanelView.h"

@implementation ELPapersPanelView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    if (_typeCode == ELCameraTypeNormal) {
        
        UIBezierPath *path = [UIBezierPath bezierPathWithRect:[UIScreen mainScreen].bounds];
        [path fillWithBlendMode:kCGBlendModeClear alpha:1.0];
    } else {
    
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(15, 150, rect.size.width-30, (rect.size.width-30)*0.645)
                                                   byRoundingCorners:UIRectCornerAllCorners
                                                         cornerRadii:CGSizeMake(12, 12)];
        [path fillWithBlendMode:kCGBlendModeClear alpha:1.0];
        
        UIBezierPath *path2= [UIBezierPath bezierPathWithRoundedRect:CGRectMake(15, 150, rect.size.width-30, (rect.size.width-30)*0.645)
                                                   byRoundingCorners:UIRectCornerAllCorners
                                                         cornerRadii:CGSizeMake(12, 12)];
        path2.lineWidth = 1;
        [[UIColor whiteColor] set];
        [path2 stroke];
    }
}

@end
