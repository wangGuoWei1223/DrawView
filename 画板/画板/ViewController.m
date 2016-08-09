//
//  ViewController.m
//  画板
//
//  Created by niuwan on 16/7/25.
//  Copyright © 2016年 niuwan. All rights reserved.
//

#import "ViewController.h"
#import "DrawView.h"
#import "ImageHandleView.h"

@interface ViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet DrawView *drawView;

@end

@implementation ViewController

#pragma mark - 清除
- (IBAction)clear:(id)sender {
    
    [self.drawView clear];
    
}

#pragma mark - 撤销
- (IBAction)nudo:(id)sender {
    
    [self.drawView nudo];
}

#pragma mark - 橡皮擦
- (IBAction)eraser:(id)sender {
    
    self.drawView.pathColor = [UIColor whiteColor];
}

#pragma mark - 照片
- (IBAction)pickerPhoto:(id)sender {
    
    //弹出系统相册
    UIImagePickerController *pickerVC = [[UIImagePickerController alloc] init];
    
    //设置控制器来源
    //UIImagePickerControllerSourceTypePhotoLibrary, 相册集
    //UIImagePickerControllerSourceTypeCamera, 相机
    //UIImagePickerControllerSourceTypeSavedPhotosAlbum 相册库
    pickerVC.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    
    pickerVC.delegate = self;
    [self presentViewController:pickerVC animated:YES completion:nil];
    
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    
    
    //创建图片处理的view
    ImageHandleView *imageHandleView = [[ImageHandleView alloc] initWithFrame:self.drawView.bounds];
    
    [self.drawView addSubview:imageHandleView];
    
    imageHandleView.image = image;
    
    imageHandleView.handleCompletionBlock = ^(UIImage *image) {
        
        self.drawView.image = image;
    };
    
//    self.drawView.image = image;
    
    [picker dismissViewControllerAnimated:YES completion:nil];

}

#pragma mark - 保存
- (IBAction)save:(id)sender {
    
    //开启位图上下文
    UIGraphicsBeginImageContextWithOptions(_drawView.bounds.size, NO, 0);
    
    //获取上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    //渲染
    [self.drawView.layer renderInContext:ctx];
    
    //获取图片
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    //关闭上下文
    UIGraphicsEndImageContext();
    
    //保存图片
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}

// 监听保存完成，必须实现这个方法
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {

}

#pragma mark - 颜色
- (IBAction)coloChange:(UIButton *)sender {
    
    self.drawView.pathColor = sender.backgroundColor;
}

#pragma mark - 线宽
- (IBAction)pathLineWidth:(UISlider *)sender {
    
    self.drawView.lineWidth = sender.value;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
}

@end
