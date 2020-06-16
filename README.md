# ELPapersCamera
## 自定义证件照拍摄并自动裁切

- 本项目布局依赖Masonry；

- 目前暂时只支持身份证正面、背面，驾驶证正面、背面。



使用方式：

```
ELPapersCameraViewController *vc = [ELPapersCameraViewController new];
vc.typeCode = [self typeCodeWithRow:indexPath.row];
@weakify(self);
vc.imageBlock = ^(ELCameraTypeCode typeCode, UIImage * _Nullable image) {

	// image就是裁切后的照片
	// Do what you want.
};
// 推荐使用modal
[self presentViewController:vc animated:YES completion:nil];
```



效果：

![身份证正面](https://tva1.sinaimg.cn/large/007S8ZIlly1gftxvrefq1j30a00hsjuu.jpg)

![身份证背面](https://tva1.sinaimg.cn/large/007S8ZIlly1gftxvr8irrj30a00hsjux.jpg)

![驾驶证正面](https://tva1.sinaimg.cn/large/007S8ZIlly1gftxvr4sc9j30a00hsn0l.jpg)

![驾驶证背面](https://tva1.sinaimg.cn/large/007S8ZIlly1gftxvr07b2j30a00hsjux.jpg)

