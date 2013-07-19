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
    if (![self hasNetWork]) {
        [self showErrorNetWorkConnection:self.view title:@"Network Error" message:@"Check your network connection." dismissError:nil];
    }
}
-(void)showErrorNetWorkConnection:(UIView*)view title:(NSString*)title message:(NSString*)message dismissError:(void (^)(void))dismiss
{
    if (![self hasNetWork]) {
        [self showErrorNetWorkConnection:view title:title message:message dismissError:dismiss];
    }
}
-(void)showListenerNewWork{
    NetWorkConnection *network=[NetWorkConnection sharedInstance];
    [network dynamicListenerNetwork:^(NetworkStatus status, BOOL isConnection) {
        if (!isConnection) {
            [self showErrorNetWorkConnection];
        }
    }];
}
-(void)showListenerNewWork:(UIView*)view title:(NSString*)title message:(NSString*)message dismissError:(void (^)(void))dismiss
{
    NetWorkConnection *network=[NetWorkConnection sharedInstance];
    [network dynamicListenerNetwork:^(NetworkStatus status, BOOL isConnection) {
        if (!isConnection) {
            [self showErrorNetWorkConnection:view title:title message:message dismissError:dismiss];
        }
    }];
}
@end
