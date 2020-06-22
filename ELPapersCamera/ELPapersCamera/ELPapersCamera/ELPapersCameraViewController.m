//
//  ELPapersCameraViewController.m
//  ELPapersCamera
//
//  Created by Elvist on 2020/6/13.
//  Copyright © 2020 xiaoxiao. All rights reserved.
//

#import "ELPapersCameraViewController.h"
#import "ELPapersClipViewController.h"

#import "ELPapersPanelView.h"
#import "ELPapersContentView.h"

#import "ELPapersPhotographer.h"

@interface ELPapersCameraViewController () <ELPapersClipViewControllerDelegate>

@property (nonatomic, strong) ELPapersPanelView *panelView; ///< 面板视图
@property (nonatomic, strong) ELPapersContentView *contentView; ///< 中间容器
@property (nonatomic, strong) UIView *bottomView;   ///< 底部工具栏
@property (nonatomic, strong) ELPapersClipViewController *clipVC;  ///< 展示裁切后的图片

@property (nonatomic, strong) ELPapersPhotographer *camera; ///< 相机管理对象
@property (nonatomic, strong) UIImage *resultImage;     ///< 拍摄的照片

@end

@implementation ELPapersCameraViewController
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
    
    _clipVC.view.frame = self.view.bounds;
    if (!_firstInit) {
        
        [_camera setupCameraWithViewController:self];
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
    _camera = [ELPapersPhotographer new];
    
    // 底层蒙版
    [self setupPanelView];
    
    // 底部工具栏
    [self setupBottomView];
    
    // 裁切后的图片展示
    _clipVC = [ELPapersClipViewController new];
    _clipVC.delegate = self;
    [self addChildViewController:_clipVC];
}
- (void)setupPanelView
{
    _panelView = [[ELPapersPanelView alloc] initWithFrame:self.view.bounds];
    _panelView.typeCode = _typeCode;
    [self.view addSubview:_panelView];

    UILabel *tipLabel = [UILabel new];
    tipLabel.font = [UIFont systemFontOfSize:12];
    tipLabel.textColor = [UIColor whiteColor];
    tipLabel.textAlignment = NSTextAlignmentCenter;
    tipLabel.text = @"避免反光影响，确保图像清晰，可以提高识别率";
    [_panelView addSubview:tipLabel];
    
    _contentView = [ELPapersContentView new];
    _contentView.typeCode = _typeCode;
    [_panelView addSubview:_contentView];
    
    //
    [_panelView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.bottom.left.right.equalTo(@0);
    }];
    [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(@(kWindow_StatusBarHeight));
        make.left.right.equalTo(@0);
        make.height.equalTo(@30);
    }];
    [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(@150);
        make.left.equalTo(@15);
        make.right.equalTo(@-15);
        make.height.equalTo(_contentView.mas_width).multipliedBy(0.645);
    }];
    
    if (_typeCode == ELCameraTypeNormal) {
        
        tipLabel.hidden = YES;
        _contentView.hidden = YES;
        self.navigationItem.title = @"默认";
    } else {
        
        _contentView.hidden = NO;
        switch (_typeCode) {
            case ELCameraTypeAvatar:
                self.navigationItem.title = @"拍摄头像";
                _contentView.hidden = YES;
                break;
            case ELCameraTypeIdFront:
                self.navigationItem.title = @"中华人民共和国居民身份证正面";
                _contentView.titleLabel.text = @"中华人民共和国居民身份证正面";
                _contentView.descLabel.text = @"将身份证正面置于此区域";
                break;
            case ELCameraTypeIdBack:
                self.navigationItem.title = @"中华人民共和国居民身份证背面";
                _contentView.titleLabel.text = @"中华人民共和国居民身份证背面";
                _contentView.descLabel.text = @"将身份证背面置于此区域";
                break;
            case ELCameraTypeDriverFront:
                self.navigationItem.title = @"拍摄驾驶证正本正面";
                _contentView.titleLabel.text = @"中华人民共和国机动车驾驶证";
                _contentView.descLabel.text = @"将驾驶证主页置于此区域，并对齐左下角发证机关印章";
                break;
            case ELCameraTypeDriverBack:
                self.navigationItem.title = @"拍摄驾驶证正本背面";
                _contentView.titleLabel.text = @"中华人民共和国机动车驾驶证";
                _contentView.descLabel.text = @"将驾驶证正本背面置于此区域，并对齐左下角的条形码";
                break;
            case ELCameraTypeDriverCopy:
                self.navigationItem.title = @"拍摄驾驶证副本";
                _contentView.titleLabel.text = @"中华人民共和国机动车驾驶证副本";
                _contentView.descLabel.text = @"将驾驶证副本置于此区域，并对齐右下角条形码";
                break;
            case ELCameraTypeVehicleFront:
                self.navigationItem.title = @"拍摄行驶证正本";
                _contentView.titleLabel.text = @"中华人民共和国机动车行驶证";
                _contentView.descLabel.text = @"将行驶证主页置于此区域，并对齐左下角发证机关印章";
                break;
            case ELCameraTypeVehicleCopy:
                self.navigationItem.title = @"拍摄行驶证副本";
                _contentView.titleLabel.text = @"中华人民共和国机动车行驶证副本";
                _contentView.descLabel.text = @"将行驶证副本置于此区域，并对齐右下角条形码";
                break;
                
            default:
                break;
        }
    }
}
- (void)setupBottomView
{
    _bottomView = [UIView new];
    _bottomView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:_bottomView];
    
    UIButton *cameraButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cameraButton.exclusiveTouch = YES;
    [cameraButton setImage:[UIImage imageNamed:@"ELPapersCamera.bundle/img_toolbar_takephoto"] forState:UIControlStateNormal];
    [cameraButton addTarget:self action:@selector(didClickCameraButton:) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView addSubview:cameraButton];
    
    if (_isPresented) {
        
        UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [cancelButton addTarget:self action:@selector(didClickCancelButton:) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView addSubview:cancelButton];

        [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.bottom.right.equalTo(@0);
            make.width.equalTo(@100);
        }];
    }
    
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.left.right.equalTo(@0);
        make.height.equalTo(@100);
    }];
    [cameraButton mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerX.centerY.equalTo(_bottomView);
        make.width.height.equalTo(@(60));
    }];
}

#pragma mark - action
- (void)didClickCancelButton:(UIButton *)sender
{
    [_camera stop];
    if (_isPresented) {
        
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (void)didClickCameraButton:(UIButton *)sender
{
    @weakify(self);
    [_camera takeImage:^(UIImage * _Nullable image) {
        
        [weak_self clipImage:image];
    }];
}

#pragma mark - private
- (void)clipImage:(UIImage *)image
{
    CGSize sz = [image size];
    CGSize size = self.view.bounds.size;
    DDLog(@"%f", kScreenHeight);
    if (_typeCode == ELCameraTypeNormal){
        
        CGFloat x = 0;
        CGFloat y = 0;
        CGFloat w = (sz.width/size.width)*(size.width);
        CGFloat h = (sz.height/size.height)*(size.height-100);
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(w,h), NO, 0);
        [image drawAtPoint:CGPointMake(-x, -y)];
    } else if (_typeCode == ELCameraTypeAvatar) {
        
        CGSize sz = [image size];
        CGSize size = self.view.bounds.size;
        CGFloat x = (sz.width/size.width)*15;
        CGFloat y = (sz.height/size.height)*150;
        CGFloat w = (sz.width/size.width)*(size.width-30);
        CGFloat h = (sz.height/size.height)*((size.width-30)*0.645);
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(w,h), NO, 0);
        [image drawAtPoint:CGPointMake(-x, -y)];
    } else {
        
        CGSize sz = [image size];
        CGSize size = self.view.bounds.size;
        CGFloat x = (sz.width/size.width)*15;
        CGFloat y = (sz.height/size.height)*150;
        CGFloat w = (sz.width/size.width)*(size.width-30);
        CGFloat h = (sz.height/size.height)*((size.width-30)*0.645);
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(w,h), NO, 0);
        [image drawAtPoint:CGPointMake(-x, -y)];
    }
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    _resultImage = result;
    UIGraphicsEndImageContext();
    
    [_clipVC setImage:_resultImage typeCode:_typeCode];
    [self.view addSubview:_clipVC.view];
}

#pragma mark - ELPapersClipViewControllerDelegate
- (void)ELPapersClipViewControllerClickRemake
{
    [_clipVC.view removeFromSuperview];
    
    [_camera start];
}
- (void)ELPapersClipViewControllerClickDetermine
{
    if (_imageBlock) _imageBlock(_typeCode, _resultImage);
    [self didClickCancelButton:nil];
}

@end
