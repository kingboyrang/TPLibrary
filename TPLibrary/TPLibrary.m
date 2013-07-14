//
//  TPLibrary.m
//  TPLibrary
//
//  Created by rang on 13-7-13.
//  Copyright (c) 2013年 rang. All rights reserved.
//

#import "TPLibrary.h"

@implementation TPLibrary
//打开网页
+(void)openUrl:(NSString*)skipUrl{
    NSURL *url=[NSURL URLWithString:skipUrl];
    [[UIApplication sharedApplication] openURL:url];
}
//等比缩放
+(CGSize)autoZoomSize:(CGSize)defaultSize orginSize:(CGSize)size{
    CGFloat rotioW=size.width/defaultSize.width;
    CGFloat rotioH=size.height/defaultSize.height;
    CGSize resultSize=size;
    if (size.width > defaultSize.width|| size.height > defaultSize.height){
        if (rotioW>rotioH) {
            resultSize.width=defaultSize.width;
            resultSize.height=size.height/rotioW;
        }else{
            resultSize.width=size.width/rotioH;
            resultSize.height=defaultSize.height;
        }
    }
    return resultSize;
}
@end
