//
//  ViewController.m
//  ELPapersCamera
//
//  Created by Elvist on 2020/6/13.
//  Copyright © 2020 xiaoxiao. All rights reserved.
//

#import "ViewController.h"

#import "ELPapersCamera.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIImageView *imgView;

@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"证件照相机";
    self.view.backgroundColor = [UIColor whiteColor];
    
    _dataArray = @[[self dicWithTitle:@"默认" code:ELCameraTypeNormal],
                   [self dicWithTitle:@"头像" code:ELCameraTypeAvatar],
                   [self dicWithTitle:@"身份证正面" code:ELCameraTypeIdFront],
                   [self dicWithTitle:@"身份证背面" code:ELCameraTypeIdBack],
                   [self dicWithTitle:@"驾驶证正本正面" code:ELCameraTypeDriverFront],
                   [self dicWithTitle:@"驾驶证正本背面" code:ELCameraTypeDriverBack],
                   [self dicWithTitle:@"驾驶证副本" code:ELCameraTypeDriverCopy],
                   [self dicWithTitle:@"行驶证正面" code:ELCameraTypeVehicleFront],
                   [self dicWithTitle:@"行驶证副本" code:ELCameraTypeVehicleCopy],
    ];
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    _imgView = [[UIImageView alloc] init];
    _imgView.frame = CGRectMake(0, 0, kScreenWidth, 300);
    _imgView.contentMode = UIViewContentModeScaleAspectFit;
    _imgView.backgroundColor = [UIColor lightGrayColor];
    _tableView.tableFooterView = _imgView;
}

#pragma mark - tableView代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"sss";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    NSDictionary *dic = _dataArray[indexPath.row];
    cell.textLabel.text = dic[@"title"];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];

    NSDictionary *dic = _dataArray[indexPath.row];
    @weakify(self);
    
    ELPapersCamera *camera = [ELPapersCamera shared];
    camera.imageBlock = ^(ELCameraTypeCode typeCode, UIImage * _Nullable image) {
        
        weak_self.imgView.image = image;
    };
    [camera showFromViewController:self typeCode:[dic[@"code"] integerValue]];
}

#pragma mark - private
- (NSDictionary *)dicWithTitle:(NSString *)title code:(ELCameraTypeCode)code
{
    return @{@"title" : title,
             @"code" : @(code)
    };
}

@end
