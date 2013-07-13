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

@end
