//
//  ViewController.m
//  ELPapersCamera
//
//  Created by Elvist on 2020/6/13.
//  Copyright © 2020 xiaoxiao. All rights reserved.
//

#import "ViewController.h"

#import "ELPapersCameraViewController.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIImageView *imgView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"证件照相机";
    self.view.backgroundColor = [UIColor whiteColor];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    
    _imgView = [UIImageView new];
    _imgView.frame = CGRectMake(20, 350, kScreenWidth - 40, 300);
    _imgView.contentMode = UIViewContentModeScaleAspectFit;
    _imgView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:_imgView];
}

#pragma mark - tableView代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"sss";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.textLabel.text = [self titleWithRow:indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];

    ELPapersCameraViewController *vc = [ELPapersCameraViewController new];
    vc.typeCode = [self typeCodeWithRow:indexPath.row];
    @weakify(self);
    vc.imageBlock = ^(ELCameraTypeCode typeCode, UIImage * _Nullable image) {

        weak_self.imgView.image = image;
    };

    // 建议使用方式一
    // 方式一：modal
    [self presentViewController:vc animated:YES completion:nil];

    // 方式二：push
//    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - private
- (NSString *)titleWithRow:(NSInteger)row
{
    NSString *text;
    switch (row) {
        case 0:
            text = @"默认";
            break;
        case 1:
            text = @"身份证正面";
            break;
        case 2:
            text = @"身份证背面";
            break;
        case 3:
            text = @"驾驶证正面";
            break;
        case 4:
            text = @"驾驶证背面";
            break;
            
        default:
            text = @"";
            break;
    }
    return text;
}
- (ELCameraTypeCode)typeCodeWithRow:(NSInteger)row
{
    ELCameraTypeCode typeCode;
    switch (row) {
        case 0:
            typeCode = ELCameraTypeNormal;
            break;
        case 1:
            typeCode = ELCameraTypeIdFront;
            break;
        case 2:
            typeCode = ELCameraTypeIdBack;
            break;
        case 3:
            typeCode = ELCameraTypeDriverFront;
            break;
        case 4:
            typeCode = ELCameraTypeDriverBack;
            break;
            
        default:
            typeCode = ELCameraTypeNormal;
            break;
    }
    return typeCode;
}

@end
