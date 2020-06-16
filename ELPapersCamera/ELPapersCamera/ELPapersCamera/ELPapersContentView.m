//
//  ELPapersContentView.m
//  ELPapersCamera
//
//  Created by Elvist on 2020/6/13.
//  Copyright © 2020 xiaoxiao. All rights reserved.
//

#import "ELPapersContentView.h"

@interface ELPapersContentView ()

@property (nonatomic, strong) UIImageView *idFrontView;
@property (nonatomic, strong) UIImageView *idBackView;

@property (nonatomic, strong) UIView *driverFrontView;
@property (nonatomic, strong) UIView *driverBackView;

@end

@implementation ELPapersContentView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
                
        self.clipsToBounds = NO;
        
        [self setupSubviews];
        [self setupLayout];
    }
    return self;
}
- (void)setupSubviews
{
    _titleLabel = [UILabel new];
    _titleLabel.font = [UIFont systemFontOfSize:16];
    _titleLabel.textColor = [[UIColor grayColor] colorWithAlphaComponent:0.7];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_titleLabel];
    
    _descLabel = [UILabel new];
    _descLabel.font = [UIFont systemFontOfSize:12];
    _descLabel.textColor = [UIColor whiteColor];
    _descLabel.textAlignment = NSTextAlignmentCenter;
    _descLabel.backgroundColor = [UIColor colorWithWhite:0 alpha:0.31];
    [self addSubview:_descLabel];
}
- (void)setupLayout
{
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(@0);
        make.centerX.equalTo(self);
        make.height.equalTo(@45);
    }];
    [_descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.mas_bottom).offset(15);
        make.centerX.equalTo(self);
        make.left.lessThanOrEqualTo(@30);
        make.right.greaterThanOrEqualTo(@-30);
        make.height.equalTo(@25);
    }];
}

#pragma mark - setter
- (void)setTypeCode:(ELCameraTypeCode)typeCode
{
    _typeCode = typeCode;
    
    switch (typeCode) {
        case ELCameraTypeIdFront:
        {
            _idFrontView = [UIImageView new];
            _idFrontView.image = [UIImage imageNamed:@"ELPapersCamera.bundle/img_id_front"];
            [self addSubview:_idFrontView];
            
            [_idFrontView mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.top.bottom.left.right.equalTo(@0);
            }];
        }
            break;
        case ELCameraTypeIdBack:
        {
            _idBackView = [UIImageView new];
            _idBackView.image = [UIImage imageNamed:@"ELPapersCamera.bundle/img_id_back"];
            [self addSubview:_idBackView];
            
            [_idBackView mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.top.bottom.left.right.equalTo(@0);
            }];
        }
            break;
        case ELCameraTypeDriverFront:
        {
            _driverFrontView = [UIView new];
            _driverFrontView.layer.cornerRadius = 3;
            _driverFrontView.layer.borderWidth = 1;
            _driverFrontView.layer.borderColor = [UIColor whiteColor].CGColor;
            [self addSubview:_driverFrontView];
            
            [_driverFrontView mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.bottom.equalTo(@-20);
                make.left.equalTo(@20);
                make.width.height.equalTo(@90);
            }];
        }
            break;
        case ELCameraTypeDriverBack:
        {
            _driverBackView = [UIView new];
            _driverBackView.layer.cornerRadius = 3;
            _driverBackView.layer.borderWidth = 1;
            _driverBackView.layer.borderColor = [UIColor whiteColor].CGColor;
            [self addSubview:_driverBackView];
            
            [_driverBackView mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.bottom.equalTo(@-20);
                make.left.equalTo(@20);
                make.width.equalTo(@170);
                make.height.equalTo(@30);
            }];
        }
            break;
            
        default:
            break;
    }
}

@end
