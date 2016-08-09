//
//  DrawView.m
//  画板
//
//  Created by niuwan on 16/7/26.
//  Copyright © 2016年 niuwan. All rights reserved.
//

#import "DrawView.h"
#import "DrawPath.h"

@interface DrawView ()

@property (nonatomic, strong)DrawPath *path;

@property (nonatomic, strong)NSMutableArray *paths;

@end

@implementation DrawView

- (NSMutableArray *)paths {
    
    if (!_paths) {
        _paths = [NSMutableArray array];
    }
    return _paths;
}

- (void)setImage:(UIImage *)image {

    _image = image;
    
    [self.paths addObject:image];
    
    [self setNeedsDisplay];
}

- (instancetype)initWithFrame:(CGRect)frame {

    if (self = [super initWithFrame:frame]) {
        
        [self setup];
    }
    
    return self;
}

- (void)awakeFromNib {

    [self setup];
}

- (void)setup {

    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    
    [self addGestureRecognizer:pan];
    
    _lineWidth = 1;
    _pathColor = [UIColor blackColor];
}

//清除
- (void)clear {

    [self.paths removeAllObjects];
    
    [self setNeedsDisplay];
}

- (void)nudo {

    [self.paths removeLastObject];
    
    [self setNeedsDisplay];
}

- (void)pan:(UIPanGestureRecognizer *)pan {
    
    //获取当前手指触摸点
    CGPoint curP = [pan locationInView:self];
    
    //起始点
    if (pan.state == UIGestureRecognizerStateBegan) {
        
        //创建路径
        _path = [[DrawPath alloc] init];
        
        //设置颜色
        _path.pathColor = _pathColor;
        
        //设置线宽
        _path.lineWidth = _lineWidth;
        
        //路径移动的起始点
        [_path moveToPoint:curP];
        
        //保存路线
        [self.paths addObject:_path];
        
    }else {
        //添加连线
        [_path addLineToPoint:curP];
        
        
    }
    //重绘
    [self setNeedsDisplay];
    

}

- (void)drawRect:(CGRect)rect {
    
    for (DrawPath *path in self.paths) {
        
        if ([path isKindOfClass:[UIImage class]]) {
            
            UIImage *image = (UIImage *)path;
            
            [image drawInRect:rect];
            
        }else {
        
            [path.pathColor set];
            
            [path stroke];
        
        }
        
    }
    
    
}


@end
