//
//  UIImage+ImageHelper.m
//  CommonLibrary
//
//  Created by rang on 13-1-14.
//  Copyright (c) 2013年 rang. All rights reserved.
//

#import "UIImage+TPCategory.h"

#pragma mark -
#pragma mark 内部方法
CGFloat DegreesToRadians(CGFloat degrees) {return degrees * M_PI / 180;};
CGFloat RadiansToDegrees(CGFloat radians) {return radians * 180/M_PI;};


CGContextRef CreateARGBBitmapContext (CGImageRef inImage)
{
    CGContextRef    context = NULL;
    CGColorSpaceRef colorSpace;
    void *          bitmapData;
    NSUInteger      bitmapByteCount;
    NSUInteger      bitmapBytesPerRow;
    
    size_t pixelsWide = CGImageGetWidth(inImage);
    size_t pixelsHigh = CGImageGetHeight(inImage);
    bitmapBytesPerRow   = (pixelsWide * 4);
    bitmapByteCount     = (bitmapBytesPerRow * pixelsHigh);
    
    colorSpace = CGColorSpaceCreateDeviceRGB();
    if (colorSpace == NULL)
        return nil;
    
    bitmapData = malloc( bitmapByteCount );
    if (bitmapData == NULL)
    {
        CGColorSpaceRelease( colorSpace );
        return nil;
    }
    
    context = CGBitmapContextCreate (bitmapData,
                                     pixelsWide,
                                     pixelsHigh,
                                     8,
                                     bitmapBytesPerRow,
                                     colorSpace,
                                     kCGImageAlphaPremultipliedFirst);
    
    if (context == NULL)
    {
        free (bitmapData);
        fprintf (stderr, "Context not created!");
    }
    
    CGColorSpaceRelease( colorSpace );
    
    return context;
}




@implementation UIImage (ImageHelper)

static void addRoundedRectToPath(CGContextRef context, CGRect rect, float ovalWidth,
                                 float ovalHeight)
{
    float fw, fh;
    
    if (ovalWidth == 0 || ovalHeight == 0)
    {
        CGContextAddRect(context, rect);
        return;
    }
    
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, CGRectGetMinX(rect), CGRectGetMinY(rect));
    CGContextScaleCTM(context, ovalWidth, ovalHeight);
    fw = CGRectGetWidth(rect) / ovalWidth;
    fh = CGRectGetHeight(rect) / ovalHeight;
    
    CGContextMoveToPoint(context, fw, fh/2);  // Start at lower right corner
    CGContextAddArcToPoint(context, fw, fh, fw/2, fh, 1);  // Top right corner
    CGContextAddArcToPoint(context, 0, fh, 0, fh/2, 1); // Top left corner
    CGContextAddArcToPoint(context, 0, 0, fw/2, 0, 1); // Lower left corner
    CGContextAddArcToPoint(context, fw, 0, fw, fh/2, 1); // Back to lower right
    
    CGContextClosePath(context);
    CGContextRestoreGState(context);
}
//截圖指定的像素大小圖片
-(UIImage *)imageAtRect:(CGRect)rect
{
    
    CGImageRef imageRef = CGImageCreateWithImageInRect([self CGImage], rect);
    UIImage* subImage = [UIImage imageWithCGImage: imageRef];
    CGImageRelease(imageRef);
    
    return subImage;
    
}
//比例缩小
- (UIImage *)imageByScalingProportionallyToMinimumSize:(CGSize)targetSize {
    
    UIImage *sourceImage = self;
    UIImage *newImage = nil;
    
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    
    if (CGSizeEqualToSize(imageSize, targetSize) == NO) {
        
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor;
        else
            scaleFactor = heightFactor;
        
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        
        if (widthFactor > heightFactor) {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        } else if (widthFactor < heightFactor) {
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    
    
    // this is actually the interesting part:
    
    UIGraphicsBeginImageContext(targetSize);
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    if(newImage == nil) NSLog(@"could not scale image");
    
    
    return newImage ;
}


- (UIImage *)imageByScalingProportionallyToSize:(CGSize)targetSize {
    
    UIImage *sourceImage = self;
    UIImage *newImage = nil;
    
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    
    if (CGSizeEqualToSize(imageSize, targetSize) == NO) {
        
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor < heightFactor)
            scaleFactor = widthFactor;
        else
            scaleFactor = heightFactor;
        
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        
        if (widthFactor < heightFactor) {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        } else if (widthFactor > heightFactor) {
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    
    
    // this is actually the interesting part:
    
    UIGraphicsBeginImageContext(targetSize);
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    if(newImage == nil) NSLog(@"could not scale image");
    
    
    return newImage ;
}

- (UIImage *)imageRotatedByRadians:(CGFloat)radians
{
    return [self imageRotatedByDegrees:RadiansToDegrees(radians)];
}

- (UIImage *)imageRotatedByDegrees:(CGFloat)degrees
{
    // calculate the size of the rotated view's containing box for our drawing space
    UIView *rotatedViewBox = [[UIView alloc] initWithFrame:CGRectMake(0,0,self.size.width, self.size.height)];
    CGAffineTransform t = CGAffineTransformMakeRotation(DegreesToRadians(degrees));
    rotatedViewBox.transform = t;
    CGSize rotatedSize = rotatedViewBox.frame.size;
    
    // Create the bitmap context
    UIGraphicsBeginImageContext(rotatedSize);
    CGContextRef bitmap = UIGraphicsGetCurrentContext();
    
    // Move the origin to the middle of the image so we will rotate and scale around the center.
    CGContextTranslateCTM(bitmap, rotatedSize.width/2, rotatedSize.height/2);
    
    //   // Rotate the image context
    CGContextRotateCTM(bitmap, DegreesToRadians(degrees));
    
    // Now, draw the rotated/scaled image into the context
    CGContextScaleCTM(bitmap, 1.0, -1.0);
    CGContextDrawImage(bitmap, CGRectMake(-self.size.width / 2, -self.size.height / 2, self.size.width, self.size.height), [self CGImage]);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
    
}
+(UIImage*)mergerImage:(UIImage*)img mergerImage:(UIImage*)merger position:(CGPoint)pos{
    UIGraphicsBeginImageContext(img.size);
    //Draw image2
    [merger drawInRect:CGRectMake(0, 0, img.size.width, img.size.height)];
    //Draw image1
    [img drawInRect:CGRectMake(pos.x,pos.y, merger.size.width, merger.size.height)];
    UIImage *resultImage=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resultImage;
}
+(UIImage*)createImageWithColor:(UIColor*)color{
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context=UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    UIImage *theImage=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}
+(UIImage*)createImageWithColor:(UIColor*)color imageSize:(CGSize)size{
    CGRect rect=CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context=UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    UIImage *theImage=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}
+ (id)createRoundedRectImage:(UIImage*)image size:(CGSize)size radius:(NSInteger)r{
    int w = size.width;
    int h = size.height;
    
    UIImage *img = image;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL, w, h, 8, 4 * w, colorSpace, kCGImageAlphaPremultipliedFirst);
    CGRect rect = CGRectMake(0, 0, w, h);
    
    CGContextBeginPath(context);
    addRoundedRectToPath(context, rect, r, r);
    CGContextClosePath(context);
    CGContextClip(context);
    CGContextDrawImage(context, CGRectMake(0, 0, w, h), img.CGImage);
    CGImageRef imageMasked = CGBitmapContextCreateImage(context);
    img = [UIImage imageWithCGImage:imageMasked];
    
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    CGImageRelease(imageMasked);
    
    return img;
}


+ (UIImage*)imageWithContentsOfURL:(NSURL*)url {
    NSError* error = nil;
    NSData* data = [NSURLConnection sendSynchronousRequest:[NSURLRequest requestWithURL:url] returningResponse:NULL error:NULL];
    if(error || !data) {
        return nil;
    } else {
        return [UIImage imageWithData:data];
    }
}

+ (UIImage*)imageWithResourcesPathCompontent:(NSString*)pathCompontent {
    return [UIImage imageWithContentsOfFile:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:pathCompontent]];
}

- (UIImage*)scaleToSize:(CGSize)size {
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 40000
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
        UIGraphicsBeginImageContextWithOptions(size, NO, [[UIScreen mainScreen] scale]);
    } else {
        UIGraphicsBeginImageContext(size);
    }
#else
    UIGraphicsBeginImageContext(size);
#endif
    
    [self drawInRect:CGRectMake(0.0f, 0.0f, size.width, size.height)];
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return scaledImage;
}

- (UIImage*)aspectScaleToMaxSize:(CGFloat)size withBorderSize:(CGFloat)borderSize borderColor:(UIColor*)aColor cornerRadius:(CGFloat)aRadius shadowOffset:(CGSize)aOffset shadowBlurRadius:(CGFloat)aBlurRadius shadowColor:(UIColor*)aShadowColor{
    
    CGSize imageSize = CGSizeMake(self.size.width, self.size.height);
    
    CGFloat hScaleFactor = imageSize.width / size;
    CGFloat vScaleFactor = imageSize.height / size;
    
    CGFloat scaleFactor = MAX(hScaleFactor, vScaleFactor);
    
    CGFloat newWidth = imageSize.width   / scaleFactor;
    CGFloat newHeight = imageSize.height / scaleFactor;
    
    CGRect imageRect = CGRectMake(borderSize, borderSize, newWidth, newHeight);
    
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 40000
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(newWidth + (borderSize*2), newHeight + (borderSize*2)), NO, [[UIScreen mainScreen] scale]);
    } else {
        UIGraphicsBeginImageContext(CGSizeMake(newWidth + (borderSize*2), newHeight + (borderSize*2)));
    }
#else
    UIGraphicsBeginImageContext(CGSizeMake(newWidth + (borderSize*2), newHeight + (borderSize*2)));
#endif
    
    
    CGContextRef imageContext = UIGraphicsGetCurrentContext();
    CGContextSaveGState(imageContext);
    CGPathRef path = NULL;
    
    if (aRadius > 0.0f) {
        
        CGFloat radius;
        radius = MIN(aRadius, floorf(imageRect.size.width/2));
        float x0 = CGRectGetMinX(imageRect), y0 = CGRectGetMinY(imageRect), x1 = CGRectGetMaxX(imageRect), y1 = CGRectGetMaxY(imageRect);
        
        CGContextBeginPath(imageContext);
        CGContextMoveToPoint(imageContext, x0+radius, y0);
        CGContextAddArcToPoint(imageContext, x1, y0, x1, y1, radius);
        CGContextAddArcToPoint(imageContext, x1, y1, x0, y1, radius);
        CGContextAddArcToPoint(imageContext, x0, y1, x0, y0, radius);
        CGContextAddArcToPoint(imageContext, x0, y0, x1, y0, radius);
        CGContextClosePath(imageContext);
        path = CGContextCopyPath(imageContext);
        CGContextClip(imageContext);
        
    }
    
    [self drawInRect:imageRect];
    CGContextRestoreGState(imageContext);
    
    if (borderSize > 0.0f) {
        
        CGContextSetLineWidth(imageContext, borderSize);
        [aColor != nil ? aColor : [UIColor blackColor] setStroke];
        
        if(path == NULL){
            
            CGContextStrokeRect(imageContext, imageRect);
            
        } else {
            
            CGContextAddPath(imageContext, path);
            CGContextStrokePath(imageContext);
            
        }
    }
    
    if(path != NULL){
        CGPathRelease(path);
    }
    
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    if (aBlurRadius > 0.0f) {
        
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 40000
        if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
            UIGraphicsBeginImageContextWithOptions(CGSizeMake(scaledImage.size.width + (aBlurRadius*2), scaledImage.size.height + (aBlurRadius*2)), NO, [[UIScreen mainScreen] scale]);
        } else {
            UIGraphicsBeginImageContext(CGSizeMake(scaledImage.size.width + (aBlurRadius*2), scaledImage.size.height + (aBlurRadius*2)));
        }
#else
        UIGraphicsBeginImageContext(CGSizeMake(scaledImage.size.width + (aBlurRadius*2), scaledImage.size.height + (aBlurRadius*2)));
#endif
        
        CGContextRef imageShadowContext = UIGraphicsGetCurrentContext();
        
        if (aShadowColor!=nil) {
            CGContextSetShadowWithColor(imageShadowContext, aOffset, aBlurRadius, aShadowColor.CGColor);
        } else {
            CGContextSetShadow(imageShadowContext, aOffset, aBlurRadius);
        }
        
        [scaledImage drawInRect:CGRectMake(aBlurRadius, aBlurRadius, scaledImage.size.width, scaledImage.size.height)];
        scaledImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
    }
    
    return scaledImage;
}

- (UIImage*)aspectScaleToMaxSize:(CGFloat)size withShadowOffset:(CGSize)aOffset blurRadius:(CGFloat)aRadius color:(UIColor*)aColor{
    return [self aspectScaleToMaxSize:size	withBorderSize:0 borderColor:nil cornerRadius:0 shadowOffset:aOffset shadowBlurRadius:aRadius shadowColor:aColor];
}

- (UIImage*)aspectScaleToMaxSize:(CGFloat)size withCornerRadius:(CGFloat)aRadius{
    
    return [self aspectScaleToMaxSize:size withBorderSize:0 borderColor:nil cornerRadius:aRadius shadowOffset:CGSizeZero shadowBlurRadius:0.0f shadowColor:nil];
}

- (UIImage*)aspectScaleToMaxSize:(CGFloat)size{
    
    return [self aspectScaleToMaxSize:size withBorderSize:0 borderColor:nil cornerRadius:0 shadowOffset:CGSizeZero shadowBlurRadius:0.0f shadowColor:nil];
}

- (UIImage*)aspectScaleToSize:(CGSize)size{
    
    CGSize imageSize = CGSizeMake(self.size.width, self.size.height);
    
    CGFloat hScaleFactor = imageSize.width / size.width;
    CGFloat vScaleFactor = imageSize.height / size.height;
    
    CGFloat scaleFactor = MAX(hScaleFactor, vScaleFactor);
    
    CGFloat newWidth = imageSize.width   / scaleFactor;
    CGFloat newHeight = imageSize.height / scaleFactor;
    
    // center vertically or horizontally in size passed
    CGFloat leftOffset = (size.width - newWidth) / 2;
    CGFloat topOffset = (size.height - newHeight) / 2;
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 40000
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(size.width, size.height), NO, [[UIScreen mainScreen] scale]);
    } else {
        UIGraphicsBeginImageContext(CGSizeMake(size.width, size.height));
    }
#else
    UIGraphicsBeginImageContext(CGSizeMake(size.width, size.height));
#endif
    
    [self drawInRect:CGRectMake(leftOffset, topOffset, newWidth, newHeight)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return scaledImage;
}
+(UIImage *)getImageFromView:(UIView *)view{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size,NO,0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
- (CGSize)aspectScaleSize:(CGFloat)size{
    
    CGSize imageSize = CGSizeMake(self.size.width, self.size.height);
    
    CGFloat hScaleFactor = imageSize.width / size;
    CGFloat vScaleFactor = imageSize.height / size;
    
    CGFloat scaleFactor = MAX(hScaleFactor, vScaleFactor);
    
    CGFloat newWidth = imageSize.width   / scaleFactor;
    CGFloat newHeight = imageSize.height / scaleFactor;
    
    return CGSizeMake(newWidth, newHeight);
    
}
+ (UIImage*)imageMaskGradient:(NSArray*)colors imageSize:(CGSize)imageSize{
    //NSAssert([colors count]==2, @"an array containing two UIColor variables must be passed to drawInRect:withAlphaMaskGradient:");
    
    CGSize size = imageSize;
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
    // Start color
    const CGFloat *top = CGColorGetComponents(((UIColor*)[colors objectAtIndex:0]).CGColor);
    // End color
    const CGFloat *center = CGColorGetComponents(((UIColor*)[colors objectAtIndex:1]).CGColor);
    //
    const CGFloat *bottom = CGColorGetComponents(((UIColor*)[colors objectAtIndex:2]).CGColor);
    
    size_t gradientNumberOfLocations = 3;
    CGFloat gradientLocations[3] = { 0.1,0.5,0.9 };
    //CGFloat gradientLocations[3] = { 0.0,0.5,1.0 };
    CGFloat gradientComponents[12] = { top[0], top[1], top[2], top[3],center[0], center[1], center[2], center[3],bottom[0], bottom[1], bottom[2], bottom[3],};
    CGGradientRef gradient=CGGradientCreateWithColorComponents (colorspace, gradientComponents, gradientLocations, gradientNumberOfLocations);
    
    
    CGContextDrawLinearGradient(context, gradient, CGPointMake(0, 0),CGPointMake(0, size.height), 0);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorspace);
    UIGraphicsEndImageContext();
    return image;
    
}
- (void)drawInRect:(CGRect)rect withAlphaMaskColor:(UIColor*)aColor{
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSaveGState(context);
    
    CGContextTranslateCTM(context, 0.0, rect.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    rect.origin.y = rect.origin.y * -1;
    const CGFloat *color = CGColorGetComponents(aColor.CGColor);
    CGContextClipToMask(context, rect, self.CGImage);
    CGContextSetRGBFillColor(context, color[0], color[1], color[2], color[3]);
    CGContextFillRect(context, rect);
    
    CGContextRestoreGState(context);
}

- (void)drawInRect:(CGRect)rect withAlphaMaskGradient:(NSArray*)colors{
    
    NSAssert([colors count]==2, @"an array containing two UIColor variables must be passed to drawInRect:withAlphaMaskGradient:");
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSaveGState(context);
    
    CGContextTranslateCTM(context, 0.0, rect.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    rect.origin.y = rect.origin.y * -1;
    
    CGContextClipToMask(context, rect, self.CGImage);
    
    const CGFloat *top = CGColorGetComponents(((UIColor*)[colors objectAtIndex:0]).CGColor);
    const CGFloat *bottom = CGColorGetComponents(((UIColor*)[colors objectAtIndex:1]).CGColor);
    
    CGColorSpaceRef _rgb = CGColorSpaceCreateDeviceRGB();
    size_t _numLocations = 2;
    CGFloat _locations[2] = { 0.0, 1.0 };
    CGFloat _colors[8] = { top[0], top[1], top[2], top[3], bottom[0], bottom[1], bottom[2], bottom[3] };
    CGGradientRef gradient = CGGradientCreateWithColorComponents(_rgb, _colors, _locations, _numLocations);
    CGColorSpaceRelease(_rgb);
    
    CGPoint start = CGPointMake(CGRectGetMidX(rect), rect.origin.y);
    CGPoint end = CGPointMake(CGRectGetMidX(rect), rect.size.height);
    
    CGContextClipToRect(context, rect);
    CGContextDrawLinearGradient(context, gradient, start, end, kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
    
    CGGradientRelease(gradient);
    
    CGContextRestoreGState(context);
    
}
/*
 * save image local
 */
-(BOOL)saveImage:(NSString*)path{
    return  [UIImagePNGRepresentation(self) writeToFile:path atomically:YES]; // 保存成功會返回YES
}
-(BOOL)saveImage:(NSString*)path withName:(NSString*)fileName{
    NSString *filePath = [path stringByAppendingPathComponent:fileName];   // 保存文件的名稱
    return  [self saveImage:filePath];
}

/*
 * 取得图片数据
 */
- (NSData *)ARGBData
{
    CGContextRef cgctx = CreateARGBBitmapContext(self.CGImage);
    if (cgctx == NULL)
        return nil;
    
    size_t w = CGImageGetWidth(self.CGImage);
    size_t h = CGImageGetHeight(self.CGImage);
    CGRect rect = {{0,0},{w,h}};
    CGContextDrawImage(cgctx, rect, self.CGImage);
    
    void *data = CGBitmapContextGetData (cgctx);
    CGContextRelease(cgctx);
    
    if (!data)
        return nil;
    
    size_t dataSize = 4 * w * h; // ARGB = 4 8-bit components
    return [NSData dataWithBytes:data length:dataSize];
}

/*
 * 判断当前点是否为透明
 */
- (BOOL)isPointTransparent:(CGPoint)point
{
    NSData *rawData = [self ARGBData];  // See about caching this
    if (rawData == nil)
        return NO;
    
    size_t bpp = 4;
    size_t bpr = self.size.width * 4;
    
    NSUInteger index = point.x * bpp + (point.y * bpr);
    char *rawDataBytes = (char *)[rawData bytes];
    
    return rawDataBytes[index] == 0;
    
}

/**
 *  图片上绘制文字
 *
 *  @param title    绘制的文字
 *  @param fontSize 字体大小
 *
 *  @return
 */
- (UIImage *)imageWithTitle:(NSString *)title fontSize:(CGFloat)fontSize{

    //画布大小
    CGSize size=CGSizeMake(self.size.width,self.size.height);
    //创建一个基于位图的上下文
    UIGraphicsBeginImageContextWithOptions(size,NO,0.0);//opaque:NO  scale:0.0
    
    [self drawAtPoint:CGPointMake(0.0,0.0)];
    
    //文字居中显示在画布上
    NSMutableParagraphStyle* paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
    
    paragraphStyle.alignment=NSTextAlignmentCenter;//文字居中
    
    //计算文字所占的size,文字居中显示在画布上
    CGSize sizeText=[title boundingRectWithSize:self.size options:NSStringDrawingUsesLineFragmentOrigin
                                     attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]}context:nil].size;
    CGFloat width = self.size.width;
    CGFloat height = self.size.height;
    
    CGRect rect = CGRectMake((width-sizeText.width)/2, (height-sizeText.height)/2, sizeText.width, sizeText.height);
    //绘制文字
    [title drawInRect:rect withAttributes:@{ NSFontAttributeName:[UIFont systemFontOfSize:fontSize],NSForegroundColorAttributeName:[ UIColor whiteColor],NSParagraphStyleAttributeName:paragraphStyle}];
    
    //返回绘制的新图形
    UIImage *newImage= UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}


@end
