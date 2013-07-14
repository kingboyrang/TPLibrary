//
//  TPLibrary.h
//  TPLibrary
//
//  Created by rang on 13-7-13.
//  Copyright (c) 2013年 rang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface TPLibrary : NSObject
//打开网页
+(void)openUrl:(NSString*)url;
//等比缩放
+(CGSize)autoZoomSize:(CGSize)defautSize orginSize:(CGSize)size;
@end
