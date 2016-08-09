//
//  DrawView.h
//  画板
//
//  Created by niuwan on 16/7/26.
//  Copyright © 2016年 niuwan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DrawView : UIView

@property (nonatomic, strong) UIColor *pathColor;
@property (nonatomic, assign)CGFloat lineWidth;
@property (nonatomic, strong) UIImage *image;

- (void)clear;
- (void)nudo;

@end
