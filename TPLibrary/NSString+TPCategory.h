//
//  NSString+StringHelper.h
//  CommonLibrary
//
//  Created by rang on 13-1-7.
//  Copyright (c) 2013年 rang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (TPCategory)

/**
 *  生成guid值
 *
 *  @return 返回guid值
 */
+ (NSString*)createGUID;

/**
 *  @brief  判断字符串是否为空
 *
 *
 *  @return YES表示字符串为空，NO表示字符串不为空
 */
- (BOOL)isEmpty;

/**
 *  向前查找字符串.
 *
 *  @param search 查询的内容
 *
 *  @return 查找到字符串的位置,否则返回NSNotFound
 */
-(NSInteger)indexOf:(NSString*)search;

/**
 *  向后查找字符串
 *
 *  @param search 查询的内容
 *
 *  @return 查找到字符串的位置,否则返回NSNotFound
 */
-(NSInteger)lastIndexOf:(NSString*)search;

/**
 *  字符串去前后空格
 *
 *  @return 返回去空格后的内容
 */
-(NSString*)Trim;

/**
 *  @brief  取得text大小
 *
 *  @param  f   文本字体
 *  @param  w   文本显示的最大宽度
 *  @return 返回文本大小
 */
-(CGSize)textSize:(UIFont*)f withWidth:(CGFloat)w;

/**
 *  字符串md5加密
 *
 *  @return 返回加密后的字符串
 */
- (NSString *) stringFromMD5;


/**
 *  计算字符串字符长度（一个汉字算两个字符）
 *
 *  @return 返回字符串长度
 */
- (NSUInteger) unicodeLengthOfString;


/**
 Returns a string of the SHA1 sum of the receiver.
 @return The string of the SHA1 sum of the receiver.
 */
- (NSString *)SHA1Sum;
/**
 Returns a string of the SHA256 sum of the receiver.
 
 @return The string of the SHA256 sum of the receiver.
 */
- (NSString *)SHA256Sum;

/**
 *  url字符串编码处理
 *
 *  @return  url编码字符串
 */
-(NSString*)URLEncode;

/**
 *  url字符串解码处理
 *
 *  @return url解码字符串
 */
- (NSString *)URLDecoded;

/**
 Returns a new string encoded for a URL parameter. (Deprecated)
 
 The following characters are encoded: `:/=,!$&'()*+;[]@#?`.
 
 @return A new string escaped for a URL parameter.
 */
- (NSString *)URLEncodedParameterString;



/**
 *  判断是否为email
 *
 *  @return 是email字符中返回YES,否则为NO
 */
- (BOOL) isEmail;
- (BOOL) isURLString;
- (BOOL) isNumberString;
- (BOOL) containsChinese;
/** Returns a `NSString` that properly replaces HTML specific character sequences.
 @return An escaped HTML string.
 */
- (NSString *) escapeHTML;

/** Returns a `NSString` that properly formats text for HTML.
 @return An unescaped HTML string.
 */
- (NSString *) unescapeHTML;
///----------------------------------
/// @name URL Escaping and Unescaping
///----------------------------------

/**
 Returns a new string escaped for a URL query parameter.
 
 The following characters are escaped: `\n\r:/=,!$&'()*+;[]@#?%`. Spaces are escaped to the `+` character. (`+` is
 escaped to `%2B`).
 
 @return A new string escaped for a URL query parameter.
 
 @see stringByUnescapingFromURLQuery
 */
- (NSString *)stringByEscapingForURLQuery;

/**
 Returns a new string unescaped from a URL query parameter.
 
 `+` characters are unescaped to spaces.
 
 @return A new string escaped for a URL query parameter.
 
 @see stringByEscapingForURLQuery
 */
- (NSString *)stringByUnescapingFromURLQuery;

/** Returns a `NSString` that removes HTML elements.
 @return Returns a string without the HTML elements.
 */
- (NSString*) stringByRemovingHTML;


///----------------------
/// @name Base64 Encoding
///----------------------

/**
 Returns a string representation of the receiver Base64 encoded.
 
 @return A Base64 encoded string
 */
- (NSString *)base64EncodedString;

/**
 Returns a new string contained in the Base64 encoded string.
 
 This uses `NSData`'s `dataWithBase64String:` method to do the conversion then initializes a string with the resulting
 `NSData` object using `NSUTF8StringEncoding`.
 
 @param base64String A Base64 encoded string
 
 @return String contained in `base64String`
 */
+ (NSString *)stringWithBase64String:(NSString *)base64String;
@end
