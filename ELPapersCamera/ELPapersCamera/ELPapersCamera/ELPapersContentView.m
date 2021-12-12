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
@property (nonatomic, strong) UIView *driverCopyView;
@property (nonatomic, strong) UIView *vehicleFrontView;
@property (nonatomic, strong) UIView *vehicleCopyView;

@end

@implementation ELPapersContentView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
                
        self.clipsToBounds = NO;
        
        [self setupSubviews];
        [self setupLayout];
    }
    return self;
}

- (void)setupSubviews {
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.font = [UIFont systemFontOfSize:16];
    self.titleLabel.textColor = [[UIColor grayColor] colorWithAlphaComponent:0.7];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.titleLabel];
    
    self.descLabel = [[UILabel alloc] init];
    self.descLabel.font = [UIFont systemFontOfSize:12];
    self.descLabel.textColor = [UIColor whiteColor];
    self.descLabel.textAlignment = NSTextAlignmentCenter;
    self.descLabel.backgroundColor = [UIColor colorWithWhite:0 alpha:0.31];
    [self addSubview:self.descLabel];
}

- (void)setupLayout {
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(@0);
        make.centerX.equalTo(self);
        make.height.equalTo(@45);
    }];
    [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.mas_bottom).offset(15);
        make.centerX.equalTo(self);
        make.left.lessThanOrEqualTo(@30);
        make.right.greaterThanOrEqualTo(@-30);
        make.height.equalTo(@25);
    }];
}

#pragma mark - setter
- (void)setTypeCode:(ELCameraTypeCode)typeCode {
    _typeCode = typeCode;
    
    switch (typeCode) {
        case ELCameraTypeIdFront:
        {
            self.idFrontView = [[UIImageView alloc] init];
            self.idFrontView.image = [UIImage imageNamed:@"ELPapersCamera.bundle/img_id_front"];
            [self addSubview:self.idFrontView];
            
            [self.idFrontView mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.top.bottom.left.right.equalTo(@0);
            }];
        }
            break;
        case ELCameraTypeIdBack:
        {
            self.idBackView = [[UIImageView alloc] init];
            self.idBackView.image = [UIImage imageNamed:@"ELPapersCamera.bundle/img_id_back"];
            [self addSubview:self.idBackView];
            
            [self.idBackView mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.top.bottom.left.right.equalTo(@0);
            }];
        }
            break;
        case ELCameraTypeDriverFront:
        {
            self.driverFrontView =[[UIView alloc] init];
            self.driverFrontView.layer.cornerRadius = 3;
            self.driverFrontView.layer.borderWidth = 1;
            self.driverFrontView.layer.borderColor = [UIColor whiteColor].CGColor;
            [self addSubview:self.driverFrontView];
            
            [self.driverFrontView mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.bottom.equalTo(@-20);
                make.left.equalTo(@20);
                make.width.height.equalTo(@90);
            }];
        }
            break;
        case ELCameraTypeDriverBack:
        {
            self.driverBackView =[[UIView alloc] init];
            self.driverBackView.layer.cornerRadius = 3;
            self.driverBackView.layer.borderWidth = 1;
            self.driverBackView.layer.borderColor = [UIColor whiteColor].CGColor;
            [self addSubview:self.driverBackView];
            
            [self.driverBackView mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.bottom.equalTo(@-20);
                make.left.equalTo(@20);
                make.width.equalTo(@170);
                make.height.equalTo(@30);
            }];
        }
            break;
        case ELCameraTypeDriverCopy:
        {
            self.driverBackView =[[UIView alloc] init];
            self.driverBackView.layer.cornerRadius = 3;
            self.driverBackView.layer.borderWidth = 1;
            self.driverBackView.layer.borderColor = [UIColor whiteColor].CGColor;
            [self addSubview:self.driverBackView];
            
            [self.driverBackView mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.bottom.equalTo(@-20);
                make.right.equalTo(@-20);
                make.width.equalTo(@170);
                make.height.equalTo(@30);
            }];
        }
            break;
        case ELCameraTypeVehicleFront:
        {
            self.vehicleFrontView =[[UIView alloc] init];
            self.vehicleFrontView.layer.cornerRadius = 3;
            self.vehicleFrontView.layer.borderWidth = 1;
            self.vehicleFrontView.layer.borderColor = [UIColor whiteColor].CGColor;
            [self addSubview:self.vehicleFrontView];
            
            [self.vehicleFrontView mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.bottom.equalTo(@-20);
                make.left.equalTo(@20);
                make.width.height.equalTo(@90);
            }];
        }
            break;
        case ELCameraTypeVehicleCopy:
        {
            self.vehicleCopyView =[[UIView alloc] init];
            self.vehicleCopyView.layer.cornerRadius = 3;
            self.vehicleCopyView.layer.borderWidth = 1;
            self.vehicleCopyView.layer.borderColor = [UIColor whiteColor].CGColor;
            [self addSubview:self.vehicleCopyView];
            
            [self.vehicleCopyView mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.bottom.equalTo(@-20);
                make.right.equalTo(@-20);
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
