//
//  CVUIPopverView.m
//  CalendarDemo
//
//  Created by rang on 13-3-12.
//  Copyright (c) 2013年 rang. All rights reserved.
//

#import "CVUIPopoverView.h"
#define screenRect [[UIScreen mainScreen] bounds]

@interface CVUIPopoverView()
@property(nonatomic,retain) UILabel *labTitle;
-(void)loadControl:(CGRect)frame;
-(BOOL)isIPad;
-(void)addBackgroundView;
-(CGSize)textSizeWithText:(NSString*)title font:(UIFont*)f withWidth:(CGFloat)w;
@end

@implementation CVUIPopoverView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self loadControl:frame];
    }
    return self;
}
#pragma mark -
#pragma mark 属性方法重写
- (void)setToolBarTitle:(NSString*)title{
    CGSize size=[self textSizeWithText:title font:_labTitle.font withWidth:self.bounds.size.width];
    CGRect r=_labTitle.frame;
    r.size=size;
    r.origin.x=(self.frame.size.width-size.width)/2;
    _labTitle.frame=r;
    _labTitle.text=title;
}
#pragma mark -
#pragma mark 公有方法
-(void)addChildView:(UIView*)view{
    if (view) {
        CGRect viewRect=view.frame;
        viewRect.origin.x=0;
        viewRect.origin.y=self.toolBar.frame.size.height;
        view.frame=viewRect;
        [self addSubview:view];
        
       
       //重设大小
       CGRect orginRect=self.frame;
       orginRect.size.height+=viewRect.size.height;
        CGFloat viewY=screenRect.size.height+orginRect.size.height;
        if ([self isIPad]) {
            viewY=0;
        }
       orginRect.origin.y=viewY;
       self.frame=orginRect;
        
        if ([self isIPad]) {
            if (!self.popController) {
                UIViewController *popView=[[UIViewController alloc] init];
                popView.contentSizeForViewInPopover=self.frame.size;
                [popView.view addSubview:self];
                self.popController=[[UIPopoverController alloc] initWithContentViewController:popView];
                self.popController.popoverContentSize=self.frame.size;
                [popView release];
            }
        }
    }
}
-(void)show:(UIView*)popView{

    if ([self isIPad]) {
        [self.popController presentPopoverFromRect:popView.frame inView:[popView superview] permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }else{
        [self addBackgroundView];
        UIWindow *window=[[[UIApplication sharedApplication] delegate] window];
        [window addSubview:bgView];
        [window bringSubviewToFront:bgView];
        [window addSubview:self];
        
        CGFloat h=self.frame.size.height,topY=screenRect.size.height-h;
        [UIView animateWithDuration:0.5f animations:^(void){
            self.frame=CGRectMake(0, topY, self.bounds.size.width, h);
        }];
        
    }
}
-(void)hide{
    if ([self isIPad]) {
        [self.popController dismissPopoverAnimated:YES];
        return;
    }
    CGFloat h=self.frame.size.height,topY=screenRect.size.height;

    [UIView animateWithDuration:0.5f animations:^(void){
        self.frame=CGRectMake(0,topY+h, self.bounds.size.width, h);
        
    } completion:^(BOOL isFinished){
        if (isFinished) {
            [bgView removeFromSuperview];
            [self removeFromSuperview];
        }
        
    }];
}
#pragma mark -
#pragma mark 私有方法
-(CGSize)textSizeWithText:(NSString*)title font:(UIFont*)f withWidth:(CGFloat)w{
    return  [title sizeWithFont:f constrainedToSize:CGSizeMake(w, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
}
-(BOOL)isIPad{
    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad) {
        return YES;
    }
    return NO;
}
-(void)loadControl:(CGRect)frame{
        self.backgroundColor=[UIColor grayColor];
        //Tool Bar
        _toolBar=[[UIToolbar alloc] initWithFrame:CGRectMake(0, 0,frame.size.width, 44)];
        _toolBar.barStyle =UIBarStyleBlackTranslucent;
        [self addSubview:_toolBar];
    
    NSString *memo=@"请选择";
    CGSize size=[self textSizeWithText:memo font:[UIFont boldSystemFontOfSize:14] withWidth:frame.size.width];
    _labTitle=[[UILabel alloc] initWithFrame:CGRectMake((frame.size.width-size.width)/2,(44-size.height)/2, size.width, size.height)];
    _labTitle.text=memo;
    _labTitle.font=[UIFont boldSystemFontOfSize:14];
    _labTitle.textColor=[UIColor whiteColor];
    _labTitle.backgroundColor=[UIColor clearColor];
    _labTitle.textAlignment=NSTextAlignmentCenter;
    [self addSubview:_labTitle];
  
        CGFloat topY=44;
        CGFloat viewY=screenRect.size.height+topY;
        if ([self isIPad]) {
            viewY=0;
        }
        self.frame=CGRectMake(0, viewY, frame.size.width, topY);
    
    
}
-(void)addBackgroundView{
    if (![self isIPad]) {
        if (!bgView) {
            bgView=[[UIView alloc] initWithFrame:screenRect];
            bgView.backgroundColor=[UIColor grayColor];
            bgView.alpha=0.3;
            //[bgView addSubview:self];
        }
    }
    
}
@end
