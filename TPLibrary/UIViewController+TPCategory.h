//
//  UIViewController+TPCategory.h
//  TPLibrary
//
//  Created by rang on 13-7-19.
//  Copyright (c) 2013年 rang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (TPCategory)
@property(nonatomic,readonly) BOOL hasNetWork;
@property(nonatomic,readonly) CGSize viewSize;
@property(nonatomic,readonly) CGFloat screenWith;
@property(nonatomic,readonly) CGFloat screenHeight;
@property(nonatomic,readonly) BOOL isLandscape;//横向
@property(nonatomic,readonly) BOOL isIPAD;
@end
