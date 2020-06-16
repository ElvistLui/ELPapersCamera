//
//  ELPapersClipViewController.m
//  ELPapersCamera
//
//  Created by Elvist on 2020/6/13.
//  Copyright © 2020 xiaoxiao. All rights reserved.
//

#import "ELPapersClipViewController.h"

@interface ELPapersClipViewController ()

@property (nonatomic, strong) UIImageView *backgroundView;
@property (nonatomic, strong) UIImageView *normalImgView;
@property (nonatomic, strong) UIImageView *clipImageView;
@property (nonatomic, strong) UIView *bottomView;   ///< 底部工具栏

@end

@implementation ELPapersClipViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupView];
}

#pragma mark - 初始化视图
- (void)setupView
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    _backgroundView = [UIImageView new];
    _backgroundView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.76];
    [self.view addSubview:_backgroundView];
    
    [self setupBottomView];
    
    _normalImgView = [UIImageView new];
    _normalImgView.contentMode = UIViewContentModeScaleAspectFill;
    _normalImgView.clipsToBounds = YES;
    [self.view addSubview:_normalImgView];
    
    _clipImageView = [UIImageView new];
    _clipImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:_clipImageView];
    
    //
    [_backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.bottom.left.right.equalTo(@0);
    }];
    [_normalImgView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.left.right.equalTo(@0);
        make.bottom.equalTo(_bottomView.mas_top);
    }];
    [_clipImageView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(@150);
        make.left.equalTo(@15);
        make.right.equalTo(@-15);
        make.height.equalTo(_clipImageView.mas_width).multipliedBy(0.645);
    }];
}
- (void)setupBottomView
{
    _bottomView = [UIView new];
    _bottomView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:_bottomView];
    
    UIButton *remakeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    remakeButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [remakeButton setTitle:@"重拍" forState:UIControlStateNormal];
    [remakeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [remakeButton addTarget:self action:@selector(didClickRemakeButton:) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView addSubview:remakeButton];
    
    UIButton *determineButton = [UIButton buttonWithType:UIButtonTypeCustom];
    determineButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [determineButton setTitle:@"完成" forState:UIControlStateNormal];
    [determineButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [determineButton addTarget:self action:@selector(didClickDetermineButton:) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView addSubview:determineButton];
    
    //
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.bottom.left.right.equalTo(@0);
        make.height.equalTo(@100);
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

#pragma mark - action
- (void)didClickRemakeButton:(UIButton *)sender
{
    if ([_delegate respondsToSelector:@selector(ELPapersClipViewControllerClickRemake)]) {
        
        [_delegate ELPapersClipViewControllerClickRemake];
    }
}
- (void)didClickDetermineButton:(UIButton *)sender
{
    if ([_delegate respondsToSelector:@selector(ELPapersClipViewControllerClickDetermine)]) {
        
        [_delegate ELPapersClipViewControllerClickDetermine];
    }
}

#pragma mark - public
- (void)setImage:(UIImage *)image typeCode:(ELCameraTypeCode)typeCode
{
    if (typeCode == ELCameraTypeNormal) {
        
        _normalImgView.hidden = NO;
        _clipImageView.hidden = YES;
        _normalImgView.image = image;
    } else {
        
        _normalImgView.hidden = YES;
        _clipImageView.hidden = NO;
        _clipImageView.image = image;
    }
}

@end
