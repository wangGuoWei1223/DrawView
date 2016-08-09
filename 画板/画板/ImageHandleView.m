//
//  ImageHandleView.m
//  画板
//
//  Created by niuwan on 16/7/26.
//  Copyright © 2016年 niuwan. All rights reserved.
//

#import "ImageHandleView.h"

@interface ImageHandleView ()<UIGestureRecognizerDelegate>

@property (nonatomic, weak) UIImageView *imageV;

@end

@implementation ImageHandleView

- (UIImageView *)imageV {
    
    if (!_imageV) {
        UIImageView *imageV = [[UIImageView alloc] initWithFrame:self.bounds];
        
        imageV.userInteractionEnabled = YES;
        
        _imageV = imageV;
        
        //添加手试
        [self setUpGestureRecognizer];
        
        [self addSubview:imageV];
    }
    return _imageV;
}

#pragma mark - 手势
- (void)setUpGestureRecognizer {
    
    //给自己添加拖动手势 以防父视图的绘制
    UIPanGestureRecognizer *panHandle = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panHandle)];
    [self addGestureRecognizer:panHandle];
    
    //平移
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [self.imageV addGestureRecognizer:pan];
    
    //旋转
    UIRotationGestureRecognizer *rotation = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotat:)];
    rotation.delegate = self;
    
    [self.imageV addGestureRecognizer:rotation];
    
    //缩放
    UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinch:)];
    pinch.delegate = self;
    
    [self.imageV addGestureRecognizer:pinch];
    
    //长按
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    [self.imageV addGestureRecognizer:longPress];

}

#pragma mark - 手势方法

- (void)panHandle {

    
}

- (void)pan:(UIPanGestureRecognizer *)pan {

    //获取手指偏移量
    CGPoint point = [pan translationInView:self.imageV];
    
    //修改imageview形变
    self.imageV.transform = CGAffineTransformTranslate(self.imageV.transform, point.x, point.y);
    
    //复位
    [pan setTranslation:CGPointZero inView:self.imageV];
    
}

- (void)rotat:(UIRotationGestureRecognizer *)rotat {
    
    self.imageV.transform = CGAffineTransformRotate(self.imageV.transform, rotat.rotation);
    
    rotat.rotation = 0;

}

- (void)pinch:(UIPinchGestureRecognizer *)pinch {

    self.imageV.transform =  CGAffineTransformScale(self.imageV.transform, pinch.scale, pinch.scale);
    
    pinch.scale = 1;
}

- (void)longPress:(UILongPressGestureRecognizer *)longPress {

    // 图片处理完
    if (longPress.state == UIGestureRecognizerStateBegan) {
        
        //高亮
        [UIView animateWithDuration:0.25 animations:^{
            self.imageV.alpha = 0;
        } completion:^(BOOL finished) {
            
            [UIView animateWithDuration:0.25 animations:^{
                self.imageV.alpha = 1;
            } completion:^(BOOL finished) {
                // 高亮完成的时候
                
                //生成一张新的图片
                UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 0);
                
                //获取上下文
                CGContextRef ctx = UIGraphicsGetCurrentContext();
                
                //渲染
                [self.layer renderInContext:ctx];
                
                //获取图片
                UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
                
                //关闭
                UIGraphicsEndImageContext();
                
                //回调block
                if (self.handleCompletionBlock) {
                    self.handleCompletionBlock(image);
                }
                
                //从父控件移除
                [self removeFromSuperview];
                
            }];
        }];
    }
    
}

#pragma mark - UIGestureRecognizerDelegate
// 是否同时支持多个手势
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer; {

    return YES;
}

- (void)setImage:(UIImage *)image {

    _image = image;
    
    //展示到imageview上
    self.imageV.image = image;
}


@end
