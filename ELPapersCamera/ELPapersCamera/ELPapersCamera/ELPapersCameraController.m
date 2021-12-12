//
//  ELPapersCameraController.m
//  ELPapersCamera
//
//  Created by Elvist on 2020/6/13.
//  Copyright © 2020 xiaoxiao. All rights reserved.
//

#import "ELPapersCameraController.h"
#import "ELPapersResultController.h"

#import "ELPapersPanelView.h"
#import "ELPapersContentView.h"

#import "ELPapersPhotographer.h"

@interface ELPapersCameraController () <ELPapersResultControllerDelegate>

@property (nonatomic, strong) ELPapersPanelView *panelView; ///< 面板视图
@property (nonatomic, strong) ELPapersContentView *contentView; ///< 中间容器
@property (nonatomic, strong) UIView *bottomView;   ///< 底部工具栏
@property (nonatomic, strong) ELPapersResultController *clipVC;  ///< 展示裁切后的图片

@property (nonatomic, strong) ELPapersPhotographer *camera; ///< 相机管理对象
@property (nonatomic, strong) UIImage *resultImage;     ///< 拍摄的照片

@end

@implementation ELPapersCameraController
{
    BOOL _isPresented;
    BOOL _firstInit;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.modalPresentationStyle = UIModalPresentationFullScreen;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupView];
}
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    self.clipVC.view.frame = self.view.bounds;
    if (!_firstInit) {
        
        [self.camera setupCameraWithViewController:self];
        _firstInit = YES;
    }
}

#pragma mark - 初始化视图
- (void)setupView
{
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]){
        
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = NO;
    }
    _isPresented = self.navigationController.viewControllers.count < 2;
    
    // 背景色
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 设置返回按钮
    if (_isPresented) {
        
    } else {
        
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(didClickCancelButton:)];
    }
    
    //
    self.camera = [[ELPapersPhotographer alloc] init];
    
    // 底层蒙版
    [self setupPanelView];
    
    // 底部工具栏
    [self setupBottomView];
    
    // 裁切后的图片展示
    self.clipVC = [[ELPapersResultController alloc] init];
    self.clipVC.delegate = self;
    [self addChildViewController:self.clipVC];
}
- (void)setupPanelView
{
    self.panelView = [[ELPapersPanelView alloc] initWithFrame:self.view.bounds];
    self.panelView.typeCode = self.typeCode;
    [self.view addSubview:self.panelView];

    UILabel *tipLabel = [[UILabel alloc] init];
    tipLabel.font = [UIFont systemFontOfSize:12];
    tipLabel.textColor = [UIColor whiteColor];
    tipLabel.textAlignment = NSTextAlignmentCenter;
    tipLabel.text = @"避免反光影响，确保图像清晰，可以提高识别率";
    [self.panelView addSubview:tipLabel];
    
    self.contentView = [[ELPapersContentView alloc] init];
    self.contentView.typeCode = self.typeCode;
    [self.panelView addSubview:self.contentView];
    
    //
    [self.panelView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.bottom.left.right.equalTo(@0);
    }];
    [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(@(kWindow_StatusBarHeight));
        make.left.right.equalTo(@0);
        make.height.equalTo(@30);
    }];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(@150);
        make.left.equalTo(@15);
        make.right.equalTo(@-15);
        make.height.equalTo(self.contentView.mas_width).multipliedBy(0.645);
    }];
    
    if (self.typeCode == ELCameraTypeNormal) {
        
        tipLabel.hidden = YES;
        self.contentView.hidden = YES;
        self.navigationItem.title = @"默认";
    } else {
        
        self.contentView.hidden = NO;
        switch (self.typeCode) {
            case ELCameraTypeAvatar:
                self.navigationItem.title = @"拍摄头像";
                self.contentView.hidden = YES;
                break;
            case ELCameraTypeIdFront:
                self.navigationItem.title = @"中华人民共和国居民身份证正面";
                self.contentView.titleLabel.text = @"中华人民共和国居民身份证正面";
                self.contentView.descLabel.text = @"将身份证正面置于此区域";
                break;
            case ELCameraTypeIdBack:
                self.navigationItem.title = @"中华人民共和国居民身份证背面";
                self.contentView.titleLabel.text = @"中华人民共和国居民身份证背面";
                self.contentView.descLabel.text = @"将身份证背面置于此区域";
                break;
            case ELCameraTypeDriverFront:
                self.navigationItem.title = @"拍摄驾驶证正本正面";
                self.contentView.titleLabel.text = @"中华人民共和国机动车驾驶证";
                self.contentView.descLabel.text = @"将驾驶证主页置于此区域，并对齐左下角发证机关印章";
                break;
            case ELCameraTypeDriverBack:
                self.navigationItem.title = @"拍摄驾驶证正本背面";
                self.contentView.titleLabel.text = @"中华人民共和国机动车驾驶证";
                self.contentView.descLabel.text = @"将驾驶证正本背面置于此区域，并对齐左下角的条形码";
                break;
            case ELCameraTypeDriverCopy:
                self.navigationItem.title = @"拍摄驾驶证副本";
                self.contentView.titleLabel.text = @"中华人民共和国机动车驾驶证副本";
                self.contentView.descLabel.text = @"将驾驶证副本置于此区域，并对齐右下角条形码";
                break;
            case ELCameraTypeVehicleFront:
                self.navigationItem.title = @"拍摄行驶证正本";
                self.contentView.titleLabel.text = @"中华人民共和国机动车行驶证";
                self.contentView.descLabel.text = @"将行驶证主页置于此区域，并对齐左下角发证机关印章";
                break;
            case ELCameraTypeVehicleCopy:
                self.navigationItem.title = @"拍摄行驶证副本";
                self.contentView.titleLabel.text = @"中华人民共和国机动车行驶证副本";
                self.contentView.descLabel.text = @"将行驶证副本置于此区域，并对齐右下角条形码";
                break;
                
            default:
                break;
        }
    }
}
- (void)setupBottomView
{
    self.bottomView = [[UIView alloc] init];
    self.bottomView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.bottomView];
    
    UIButton *cameraButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cameraButton.exclusiveTouch = YES;
    [cameraButton setImage:[UIImage imageNamed:@"ELPapersCamera.bundle/img_toolbar_takephoto"] forState:UIControlStateNormal];
    [cameraButton addTarget:self action:@selector(didClickCameraButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomView addSubview:cameraButton];
    
    if (_isPresented) {
        
        UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [cancelButton addTarget:self action:@selector(didClickCancelButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.bottomView addSubview:cancelButton];

        [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.bottom.right.equalTo(@0);
            make.width.equalTo(@100);
        }];
    }
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.left.right.equalTo(@0);
        make.height.equalTo(@(100+kWindow_IndicatorHeight));
    }];
    [cameraButton mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerX.centerY.equalTo(self.bottomView);
        make.width.height.equalTo(@(60));
    }];
}

#pragma mark - action
- (void)didClickCancelButton:(UIButton *)sender {
    
    [self.camera stop];
    if (_isPresented) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)didClickCameraButton:(UIButton *)sender {
    
    @weakify(self);
    [self.camera takeImage:^(UIImage * _Nullable image) {
        
        [weak_self clipImage:image];
    }];
}

#pragma mark - private
- (void)clipImage:(UIImage *)image {
    
    CGSize sz = [image size];
    CGSize size = self.view.bounds.size;
    NJLog(@"%f", kScreenHeight);
    
    double camearScale = 9/16.f;    // 相机画面宽高比
    double widthScale = 0;
    double heightScale = 0;
    CGFloat topPadding = 0.f;       // 相机画面填充后，超出屏幕上方的距离
    CGFloat leftPadding = 0.f;      // 相机画面填充后，超出屏幕左侧的距离
    CGFloat cameraW = size.height*camearScale;  // 相机应该有的宽度
    CGFloat cameraH = size.width/camearScale;   // 相机应该有的高度
    if (cameraW > size.width) {
        
        leftPadding = (cameraW-size.width)/2.f;
        widthScale = sz.width/cameraW;
    } else {
        widthScale = sz.width/size.width;
    }
    if (cameraH > size.height) {
        
        topPadding = (cameraH-size.height)/2.f;
        heightScale = sz.height/cameraH;
    } else {
        heightScale = sz.height/size.height;
    }
    
    if (self.typeCode == ELCameraTypeNormal){
        
        CGFloat x = widthScale*leftPadding;
        CGFloat y = heightScale*topPadding;
        CGFloat w = widthScale*size.width;
        CGFloat h = heightScale*(size.height-100);
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(w,h), NO, 0);
        [image drawAtPoint:CGPointMake(-x, -y)];
    } else if (self.typeCode == ELCameraTypeAvatar) {
        
        CGFloat x = widthScale*(15+leftPadding);
        CGFloat y = heightScale*(150+topPadding);
        CGFloat w = widthScale*(size.width-30);
        CGFloat h = w*0.645;
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(w,h), NO, 0);
        [image drawAtPoint:CGPointMake(-x, -y)];
    } else {
        
        CGFloat x = widthScale*(15+leftPadding);
        CGFloat y = heightScale*(150+topPadding);
        CGFloat w = widthScale*(size.width-30);
        CGFloat h = w*0.645;
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(w,h), NO, 0);
        [image drawAtPoint:CGPointMake(-x, -y)];
    }
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    self.resultImage = result;
    UIGraphicsEndImageContext();
    
    [self.clipVC setImage:self.resultImage typeCode:self.typeCode];
    [self.view addSubview:self.clipVC.view];
}

#pragma mark - ELPapersResultControllerDelegate
- (void)ELPapersResultControllerClickRemake {
    
    [self.clipVC.view removeFromSuperview];
    [self.camera start];
}

- (void)ELPapersResultControllerClickDetermine {
    
    if (self.imageBlock) {
        self.imageBlock(self.typeCode, self.resultImage);
    }
    [self didClickCancelButton:nil];
}

@end
