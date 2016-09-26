//
//  IrregularShapedButton.m
//  TPLibrary
//
//  Created by wulanzhou on 16/9/26.
//  Copyright © 2016年 rang. All rights reserved.
//

#import "IrregularShapedButton.h"
#import "UIImage+TPCategory.h"

@implementation IrregularShapedButton


- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    if (!CGRectContainsPoint([self bounds], point))
        return nil;
    else
    {
        UIImage *displayedImage = [self imageForState:[self state]];
        if (displayedImage == nil) // No image found, try for background image
            displayedImage = [self backgroundImageForState:[self state]];
        if (displayedImage == nil) // No image could be found, fall back to
            return self;
        
        BOOL isTransparent = [displayedImage isPointTransparent:point];
        if (isTransparent)
            return nil;
        
    }
    
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
