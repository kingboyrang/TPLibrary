//
//  NSObject+TPCategory.h
//  TPLibrary
//
//  Created by wulanzhou on 16/5/6.
//  Copyright © 2016年 rang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (TPCategory)

//替换对象方法
+ (void)swizzleInstanceSelector:(SEL)origSelector withNewSelector:(SEL)newSelector;
//替换类方法
+ (void)swizzleClassSelector:(SEL)origSelector withNewSelector:(SEL)newSelector;

@end
