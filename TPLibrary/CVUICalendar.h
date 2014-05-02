//
//  CVUICalendar.h
//  CalendarDemo
//
//  Created by rang on 13-3-11.
//  Copyright (c) 2013年 rang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CVUIPopoverView.h"
#import "CVUIPopoverText.h"
@interface CVUICalendar : UIView
@property(nonatomic,retain) CVUIPopoverText *popText;
@property(nonatomic,retain) UIDatePicker *datePicker;
@property(nonatomic,retain) NSDateFormatter *dateForFormat;
@property(nonatomic,retain) CVUIPopoverView *popView;
- (void)show;
@end
