//
//  UIView+ViewHelper.m
//  CommonLibrary
//
//  Created by aJia on 13/3/1.
//  Copyright (c) 2013年 rang. All rights reserved.
//

#import "UIView+TPCategory.h"
#import <QuartzCore/QuartzCore.h>
@implementation UIView (TPCategory)
- (UIImage *)imageRepresentation {
	UIGraphicsBeginImageContext(self.bounds.size);
	[self.layer renderInContext:UIGraphicsGetCurrentContext()];
	UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return image;
}
- (void)removeSubviews {
    NSArray* subviews = [self subviews].copy;
    for (UIView* view in subviews) {
        [view removeFromSuperview];
    }
    [subviews release];
}
- (void)fadeOut {
	UIView *view = self;
	[UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
		view.alpha = 0.0f;
	} completion:nil];
}


- (void)fadeOutAndRemoveFromSuperview {
	UIView *view = self;
	[UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
		view.alpha = 0.0f;
	} completion:^(BOOL finished) {
		[view removeFromSuperview];
	}];
}


- (void)fadeIn {
	UIView *view = self;
	[UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
		view.alpha = 1.0f;
	} completion:nil];
}

/**
 *  取得所有的子view
 *
 *  @return 所有的子view
 */
- (NSArray *)allSubViews{
    return [self allSubViewsForView:self];
}



/**
 *  设置部份圆角
 *
 *  @param radio      圆角大小
 *  @param rectCorner 圆角位置
 */
- (void)setCornerSize:(CGSize)radio location:(UIRectCorner)rectCorner{

    CGRect rect = self.bounds;
    //CGSize radio = CGSizeMake(30, 30);//圆角尺寸
    //UIRectCorner corner = UIRectCornerTopLeft|UIRectCornerTopRight;//这只圆角位置
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:rectCorner cornerRadii:radio];
    CAShapeLayer *masklayer = [[CAShapeLayer alloc]init];//创建shapelayer
    masklayer.frame = self.bounds;
    masklayer.path = path.CGPath;//设置路径
    self.layer.mask = masklayer;
}

#pragma mark -私有方法
/**
 *  查找一个视图的所有子视图
 *
 *  @param view 要查询的视图
 *
 *  @return
 */
- (NSMutableArray *)allSubViewsForView:(UIView *)view
{
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
    for (UIView *subView in view.subviews)
    {
        [array addObject:subView];
        if (subView.subviews.count > 0)
        {
            [array addObjectsFromArray:[self allSubViewsForView:subView]];
        }
    }
    return array;
}

@end
