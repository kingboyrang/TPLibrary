//
//  UIViewController+TPCategory.m
//  TPLibrary
//
//  Created by rang on 13-7-19.
//  Copyright (c) 2013年 rang. All rights reserved.
//

#import "UIViewController+TPCategory.h"
#import "NetWorkConnection.h"
#import "UIDevice+TPCategory.h"
#import "WBErrorNoticeView.h"
#import "WBSuccessNoticeView.h"
@implementation UIViewController (TPCategory)
-(BOOL)hasNetWork{
    return [NetWorkConnection hasNetWork];
}
-(BOOL)isLandscape{
    UIDeviceOrientation orientation=[UIDevice deviceOrientation];
    if (UIDeviceOrientationIsLandscape(orientation)){
        return YES;
    }
    return NO;
}
-(CGSize)viewSize{
    if ([self isLandscape]) {
        return CGSizeMake(self.view.bounds.size.height, self.view.bounds.size.width);
    }
    return self.view.bounds.size;
}
-(CGFloat)screenWith{
    return [self viewSize].width;
}
-(CGFloat)screenHeight{
  return [self viewSize].height;
}
-(BOOL)isIPAD{
    return [UIDevice isIPad];
}
@end
