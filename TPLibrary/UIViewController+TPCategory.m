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
-(void)showErrorNoticeInView:(UIView*)view title:(NSString*)title message:(NSString*)message dismissError:(void (^)(void))dismiss;
{
    WBErrorNoticeView *notice = [WBErrorNoticeView errorNoticeInView:view title:title message:message];
    [notice setDismissalBlock:^(BOOL dismissedInteractively) {
        if (dismiss) {
            dismiss();
        }
    }];
    [notice show];
}
-(void)showSuccessNoticeInView:(UIView*)view title:(NSString*)title
{
    WBSuccessNoticeView *notice = [WBSuccessNoticeView successNoticeInView:view title:title];
    [notice show];
}
-(void)showErrorNetWorkConnection{
     [self showErrorNoticeInView:self.view title:@"Network Error" message:@"Check your network connection." dismissError:nil];
}
-(void)showErrorNetWorkConnection:(UIView*)view title:(NSString*)title message:(NSString*)message dismissError:(void (^)(void))dismiss
{
   [self showErrorNoticeInView:view title:title message:message dismissError:dismiss];
}
-(void)listenerNetwork{
    [self listenerNetwork:self.view title:@"Network Error" message:@"Check your network connection." dismissError:nil];
}
-(void)listenerNetwork:(UIView*)view title:(NSString*)title message:(NSString*)message dismissError:(void (^)(void))dismiss{
    [[NetWorkConnection sharedInstance] dynamicListenerNetwork:^(NetworkStatus status, BOOL isConnection) {
        if (!isConnection) {
            [self showErrorNetWorkConnection:view title:title message:message dismissError:dismiss];
        }
    }];
}
@end
