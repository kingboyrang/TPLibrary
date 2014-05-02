//
//  CVUIPopverView.h
//  CalendarDemo
//
//  Created by rang on 13-3-12.
//  Copyright (c) 2013年 rang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CVUIPopoverView : UIView{
    UIView *bgView;
}
@property(nonatomic,retain) UIPopoverController *popController;
@property(nonatomic,retain) UIToolbar *toolBar;
- (void)setToolBarTitle:(NSString*)title;
- (void)addChildView:(UIView*)view;
- (void)show:(UIView*)popView;
- (void)hide;
@end
