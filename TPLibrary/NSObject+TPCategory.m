//
//  NSObject+TPCategory.m
//  TPLibrary
//
//  Created by wulanzhou on 16/5/6.
//  Copyright © 2016年 rang. All rights reserved.
//

#import "NSObject+TPCategory.h"
#import <objc/runtime.h>

@implementation NSObject (TPCategory)
//替换对象方法
+ (void)swizzleInstanceSelector:(SEL)origSelector withNewSelector:(SEL)newSelector{
    Method method1 = class_getInstanceMethod([self class], origSelector);
    Method method2 = class_getInstanceMethod([self class], newSelector);
    method_exchangeImplementations(method1, method2);
}
//替换类方法
+ (void)swizzleClassSelector:(SEL)origSelector withNewSelector:(SEL)newSelector{
    Method method1 = class_getClassMethod([self class], origSelector);
    Method method2 = class_getClassMethod([self class], newSelector);
    method_exchangeImplementations(method1, method2);
}
@end
