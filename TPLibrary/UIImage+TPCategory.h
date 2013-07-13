//
//  UIImage+ImageHelper.h
//  CommonLibrary
//
//  Created by rang on 13-1-14.
//  Copyright (c) 2013年 rang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (TPCategory)
//截图指定的像素大小图片
- (UIImage *)imageAtRect:(CGRect)rect;
- (UIImage *)imageByScalingProportionallyToMinimumSize:(CGSize)targetSize;
/**等比缩放图片到指定大小**/
- (UIImage *)imageByScalingProportionallyToSize:(CGSize)targetSize;
/**缩放图片到指定大小**/
- (UIImage *)imageByScalingToSize:(CGSize)targetSize;
/**图片旋转弧度**/
- (UIImage *)imageRotatedByRadians:(CGFloat)radians;
/**图片旋转角度**/
- (UIImage *)imageRotatedByDegrees:(CGFloat)degrees;
/** 图片转换为字符串(图片转换为base64)*/
+(NSString *) image2String:(UIImage *)image;
/** 字符串转换为图片(base64转换成image)*/
+(UIImage *) string2Image:(NSString *)string;
/**合并两张图片**/
+(UIImage*)MergerImage:(UIImage*)img mergerImage:(UIImage*)merger position:(CGPoint)pos;

/*
 * Creates an image from the contents of a URL
 */
+ (UIImage*)imageWithContentsOfURL:(NSURL*)url;

/*
 * Creates an image with a path compontent relative to
 * the main bundle's resource path
 */
+ (UIImage*)imageWithResourcesPathCompontent:(NSString*)pathCompontent;

/*
 * Scales the image to the given size, NOT aspect
 */
- (UIImage*)scaleToSize:(CGSize)size;

/*
 * Aspect scale with border color, and corner radius, and shadow
 */
- (UIImage*)aspectScaleToMaxSize:(CGFloat)size withBorderSize:(CGFloat)borderSize borderColor:(UIColor*)aColor cornerRadius:(CGFloat)aRadius shadowOffset:(CGSize)aOffset shadowBlurRadius:(CGFloat)aBlurRadius shadowColor:(UIColor*)aShadowColor;

/*
 * Aspect scale with a shadow
 */
- (UIImage*)aspectScaleToMaxSize:(CGFloat)size withShadowOffset:(CGSize)aOffset blurRadius:(CGFloat)aRadius color:(UIColor*)aColor;

/*
 * Aspect scale with corner radius
 */
- (UIImage*)aspectScaleToMaxSize:(CGFloat)size withCornerRadius:(CGFloat)aRadius;

/*
 * Aspect scales the image to a max size
 */
- (UIImage*)aspectScaleToMaxSize:(CGFloat)size;

/*
 * Aspect scales the image to a rect size
 */
- (UIImage*)aspectScaleToSize:(CGSize)size;

/*
 * Masks the context with the image, then fills with the color
 */
- (void)drawInRect:(CGRect)rect withAlphaMaskColor:(UIColor*)aColor;

/*
 * Masks the context with the image, then fills with the gradient (two colors in an array)
 */
- (void)drawInRect:(CGRect)rect withAlphaMaskGradient:(NSArray*)colors;
@end
