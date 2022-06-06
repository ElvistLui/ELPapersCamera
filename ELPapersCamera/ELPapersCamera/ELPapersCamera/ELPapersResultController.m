//
//  ELPapersResultController.m
//  ELPapersCamera
//
//  Created by Elvist on 2020/6/13.
//  Copyright © 2020 xiaoxiao. All rights reserved.
//

#import "ELPapersResultController.h"

@interface ELPapersResultController ()

@property (nonatomic, strong) UIImageView *backgroundView;
@property (nonatomic, strong) UIImageView *normalImgView;
@property (nonatomic, strong) UIImageView *clipImageView;
@property (nonatomic, strong) UIView *bottomView;   ///< 底部工具栏

@end

@implementation ELPapersResultController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupView];
}

#pragma mark - 初始化视图
- (void)setupView {
    
    self.backgroundView = [[UIImageView alloc] init];
    self.backgroundView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.76];
    [self.view addSubview:self.backgroundView];
    
    [self setupBottomView];
    
    self.normalImgView = [[UIImageView alloc] init];
    self.normalImgView.contentMode = UIViewContentModeScaleToFill;
    self.normalImgView.clipsToBounds = YES;
    [self.view addSubview:self.normalImgView];
    
    self.clipImageView = [[UIImageView alloc] init];
    self.clipImageView.contentMode = UIViewContentModeScaleToFill;
    [self.view addSubview:self.clipImageView];
    
    // layout
    [self.backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.bottom.left.right.equalTo(@0);
    }];
    [self.normalImgView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.left.right.equalTo(@0);
        make.bottom.equalTo(self.bottomView.mas_top);
    }];
    [self.clipImageView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(@150);
        make.left.equalTo(@15);
        make.right.equalTo(@-15);
        make.height.equalTo(self.clipImageView.mas_width).multipliedBy(kPapersAspectRatio);
    }];
}

- (void)setupBottomView {
    
    self.bottomView =[[UIView alloc] init];
    self.bottomView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.bottomView];
    
    UIButton *remakeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    remakeButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [remakeButton setTitle:@"重拍" forState:UIControlStateNormal];
    [remakeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [remakeButton addTarget:self action:@selector(didClickRemakeButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomView addSubview:remakeButton];
    
    UIButton *determineButton = [UIButton buttonWithType:UIButtonTypeCustom];
    determineButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [determineButton setTitle:@"完成" forState:UIControlStateNormal];
    [determineButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [determineButton addTarget:self action:@selector(didClickDetermineButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomView addSubview:determineButton];
    
    // layout
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.bottom.left.right.equalTo(@0);
        make.height.equalTo(@(100+kWindow_IndicatorHeight));
    }];
    [remakeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.bottom.left.equalTo(@0);
        make.width.equalTo(remakeButton.mas_height);
    }];
    [determineButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.bottom.right.equalTo(@0);
        make.width.equalTo(determineButton.mas_height);
    }];
}

#pragma mark - Actions
- (void)didClickRemakeButton:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(ELPapersResultControllerClickRemake)]) {
        [self.delegate ELPapersResultControllerClickRemake];
    }
}

- (void)didClickDetermineButton:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(ELPapersResultControllerClickDetermine)]) {
        [self.delegate ELPapersResultControllerClickDetermine];
    }
}

#pragma mark - public
- (void)setImage:(UIImage *)image typeCode:(ELCameraTypeCode)typeCode {
    
    self.normalImgView.hidden = YES;
    self.clipImageView.hidden = NO;
    self.clipImageView.image = image;
}

@end
