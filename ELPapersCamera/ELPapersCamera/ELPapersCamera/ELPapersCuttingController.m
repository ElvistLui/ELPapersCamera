//
//  ELPapersCuttingController.m
//  ELPapersCamera
//
//  Created by Shitao Lv on 2021/12/12.
//  Copyright © 2021 xiaoxiao. All rights reserved.
//

#import "ELPapersCuttingController.h"

#import "ELPapersPanelView.h"

@interface ELPapersCuttingController () <UIScrollViewDelegate>

@property (nonatomic, strong) UIImageView *backgroundView;
@property (nonatomic, strong) UIScrollView *scrollView;     ///< 照片滚动视图
@property (nonatomic, strong) UIImageView *imageView;       ///< 照片显示视图
@property (nonatomic, strong) ELPapersPanelView *panelView; ///< 面板视图
@property (nonatomic, strong) UILabel *descLabel;   ///< 提示语
@property (nonatomic, strong) UIView *bottomView;   ///< 底部工具栏
@property (nonatomic, assign) double imageScale;    ///< 原图展示时的缩小比例

@end

@implementation ELPapersCuttingController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

#pragma mark - 初始化视图
- (void)setupView {
    
    self.backgroundView = [[UIImageView alloc] init];
    self.backgroundView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.76];
    [self.view addSubview:self.backgroundView];
    
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.frame = CGRectMake(15, 150, kScreenWidth-30, (kScreenWidth-30)*kPapersAspectRatio);
    self.scrollView.maximumZoomScale = 2;
    self.scrollView.minimumZoomScale = 1;
    self.scrollView.delegate = self;
    self.scrollView.clipsToBounds = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:self.scrollView];
    
    self.imageView = [[UIImageView alloc] init];
    self.imageView.image = self.originalImage;
    [self.scrollView addSubview:self.imageView];
    
    self.panelView = [[ELPapersPanelView alloc] initWithFrame:self.view.bounds];
    self.panelView.userInteractionEnabled = NO;
    self.panelView.typeCode = self.typeCode;
    [self.view addSubview:self.panelView];
    
    self.descLabel = [[UILabel alloc] init];
    self.descLabel.font = [UIFont systemFontOfSize:12];
    self.descLabel.textColor = [UIColor whiteColor];
    self.descLabel.textAlignment = NSTextAlignmentCenter;
    self.descLabel.backgroundColor = [UIColor colorWithWhite:0 alpha:0.31];
    [self.view addSubview:self.descLabel];
    
    [self setupBottomView];
    
    // layout
    [self.backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.bottom.left.right.equalTo(@0);
    }];
    [self.panelView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.bottom.left.right.equalTo(@0);
    }];
    [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(@((kScreenWidth-30)*kPapersAspectRatio+150+15));
        make.centerX.equalTo(@0);
        make.left.lessThanOrEqualTo(@30);
        make.right.greaterThanOrEqualTo(@-30);
        make.height.equalTo(@25);
    }];
    
    // 根据originalImage，计算imageView的布局及scrollView的滑动范围
    CGSize imageSize = self.originalImage.size;
    double imageRatio = imageSize.height/imageSize.width*1.f;   // 高宽比
    CGFloat width = 0.f;
    CGFloat height = 0.f;
    CGPoint offset = CGPointZero;
    if (imageRatio >= kPapersAspectRatio) {
        // 需要横向拉伸
        width = CGRectGetWidth(self.scrollView.frame);
        height = width*imageRatio;
        offset = CGPointMake(0, (height-CGRectGetHeight(self.scrollView.frame))/2.f);
    } else {
        // 需要竖向拉伸
        height = CGRectGetHeight(self.scrollView.frame);
        width = height/imageRatio;
        offset = CGPointMake((width-CGRectGetWidth(self.scrollView.frame))/2.f, 0);
    }
    self.imageView.frame = CGRectMake(0, 0, width, height);
    self.scrollView.contentSize = CGSizeMake(width, height);
    self.scrollView.contentOffset = offset;
    
    // 记录图片缩小比例
    self.imageScale = imageSize.width/width*1.f;
    
    switch (self.typeCode) {
        case ELCameraTypeIdFront:
            self.descLabel.text = @"将身份证正面置于此区域";
            break;
        case ELCameraTypeIdBack:
            self.descLabel.text = @"将身份证背面置于此区域";
            break;
        case ELCameraTypeDriverFront:
            self.descLabel.text = @"将驾驶证主页置于此区域，并对齐左下角发证机关印章";
            break;
        case ELCameraTypeDriverBack:
            self.descLabel.text = @"将驾驶证正本背面置于此区域，并对齐左下角的条形码";
            break;
        case ELCameraTypeDriverCopy:
            self.descLabel.text = @"将驾驶证副本置于此区域，并对齐右下角条形码";
            break;
        case ELCameraTypeVehicleFront:
//            self.descLabel.text = @"将行驶证主页置于此区域，并对齐左下角发证机关印章";
            self.descLabel.text = @"请将行驶证主页边缘对齐边框，避免反光";
            break;
        case ELCameraTypeVehicleCopy:
//            self.descLabel.text = @"将行驶证副本置于此区域，并对齐右下角条形码";
            self.descLabel.text = @"请将行驶证副页边缘对齐边框，避免反光";
            break;
            
        default:
            break;
    }
}

- (void)setupBottomView {
    
    self.bottomView =[[UIView alloc] init];
    self.bottomView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.bottomView];
    
    UIButton *remakeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    remakeButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [remakeButton setTitle:@"重选" forState:UIControlStateNormal];
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

#pragma mark - Actionss
- (void)didClickRemakeButton:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didClickDetermineButton:(UIButton *)sender {
    
    sender.userInteractionEnabled = NO;
    // 裁切图片
    CGPoint offset = self.scrollView.contentOffset;
    CGFloat zoomScale = self.scrollView.zoomScale;
    
    CGFloat x = offset.x/zoomScale*self.imageScale;
    CGFloat y = offset.y/zoomScale*self.imageScale;
    CGFloat w = self.scrollView.frame.size.width*self.imageScale/zoomScale;
    CGFloat h = w*kPapersAspectRatio;

    UIGraphicsBeginImageContextWithOptions(CGSizeMake(w, h), NO, 0);
    [self.originalImage drawAtPoint:CGPointMake(-x, -y)];
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [self.navigationController dismissViewControllerAnimated:NO completion:nil];
    // 回调
    if (self.imageBlock) {
        self.imageBlock(self.typeCode, result);
    }
}

#pragma mark - UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}

@end
