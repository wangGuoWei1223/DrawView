//
//  ImageHandleView.h
//  画板
//
//  Created by niuwan on 16/7/26.
//  Copyright © 2016年 niuwan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageHandleView : UIView

@property (nonatomic, strong) UIImage *image;

@property (nonatomic, copy) void(^handleCompletionBlock)(UIImage *image);

@end
