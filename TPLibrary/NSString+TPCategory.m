//
//  NSString+StringHelper.m
//  CommonLibrary
//
//  Created by rang on 13-1-7.
//  Copyright (c) 2013年 rang. All rights reserved.
//

#import "NSString+TPCategory.h"
#import "NSData+TPCategory.h"
#import <CommonCrypto/CommonDigest.h>
@implementation NSString (TPCategory)
/**
 *  生成guid值
 *
 *  @return 返回guid值
 */
+ (NSString*)createGUID{
    CFUUIDRef uuid_ref = CFUUIDCreate(NULL);
    CFStringRef uuid_string_ref= CFUUIDCreateString(NULL, uuid_ref);
    CFRelease(uuid_ref);
    NSString *uuid = [NSString stringWithString:(NSString*)uuid_string_ref];
    CFRelease(uuid_string_ref);
    return uuid;
}

/**
 *  @brief  判断字符串是否为空
 *
 *
 *  @return YES表示字符串为空，NO表示字符串不为空
 */
- (BOOL) isEmpty {
    if ([[self Trim] length]>0) {
        return NO;
    }
    return YES;
}


/**
 *  向前查找字符串.
 *
 *  @param search 查询的内容
 *
 *  @return 查找到字符串的位置,否则返回NSNotFound
 */
-(NSInteger)indexOf:(NSString*)search{
    NSRange r=[self rangeOfString:search];
    if (r.location!=NSNotFound) {
        return r.location;
    }
    return NSNotFound;
}

/**
 *  向后查找字符串
 *
 *  @param search 查询的内容
 *
 *  @return 查找到字符串的位置,否则返回NSNotFound
 */
-(NSInteger)lastIndexOf:(NSString*)search{
    NSRange r=[self rangeOfString:search options:NSBackwardsSearch];
    if (r.location!=NSNotFound) {
        return r.location;
    }
    return NSNotFound;
}

/**
 *  字符串去前后空格
 *
 *  @return 返回去空格后的内容
 */
-(NSString*)Trim{
    if (self&&[self length]>0) {
        return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
    return @"";
}

/**
 *  @brief  取得text大小
 *
 *  @param  f   文本字体
 *  @param  w   文本显示的最大宽度
 *  @return 返回文本大小
 */
-(CGSize)textSize:(UIFont*)f withWidth:(CGFloat)w{
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 70000
    NSDictionary *attr = @{NSFontAttributeName:f};
    CGRect rect = [self boundingRectWithSize:CGSizeMake(w, CGFLOAT_MAX)
                                     options:NSStringDrawingUsesLineFragmentOrigin
                                  attributes:attr
                                     context:nil];
    return  rect.size;
#else
    return  [self sizeWithFont:f constrainedToSize:CGSizeMake(w, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
#endif
}

/**
 *  字符串md5加密
 *
 *  @return 返回加密后的字符串
 */
- (NSString *) stringFromMD5{
    
    if ([self isEmpty]) {
        return  nil;
    }
    
    const char *cStr = [self UTF8String];
    unsigned char result[16];
    CC_MD5( cStr, (CC_LONG)strlen(cStr), result );
    return [[NSString stringWithFormat:
             @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
             result[0], result[1], result[2], result[3],
             result[4], result[5], result[6], result[7],
             result[8], result[9], result[10], result[11],
             result[12], result[13], result[14], result[15]
             ] lowercaseString];
}

/**
 *  计算字符串字符长度（一个汉字算两个字符）
 *
 *  @return 返回字符串长度
 */
- (NSUInteger) unicodeLengthOfString{
    
    if ([self isEmpty]) {
        return 0;
    }
    
    NSUInteger asciiLength = 0;
    for (NSUInteger i = 0; i < self.length; i++)
    {
        unichar uc = [self characterAtIndex: i];
        asciiLength += isascii(uc) ? 1 : 2;
    }
    return asciiLength;
}

- (NSString *)SHA1Sum {
	const char *cstr = [self cStringUsingEncoding:NSUTF8StringEncoding];
	NSData *data = [NSData dataWithBytes:cstr length:self.length];
	return [data SHA1Sum];
}


- (NSString *)SHA256Sum {
	const char *cstr = [self cStringUsingEncoding:NSUTF8StringEncoding];
	NSData *data = [NSData dataWithBytes:cstr length:self.length];
	return [data SHA256Sum];
}

/**
 *  url字符串编码处理
 *
 *  @return  url编码字符串
 */
-(NSString*)URLEncode{
    
    NSString *encodedString = ( NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,(CFStringRef)self,NULL,            (CFStringRef)@"!*'();:@&=+$,/?%#[]",kCFStringEncodingUTF8));
    return encodedString;
}

/**
 *  url字符串解码处理
 *
 *  @return url解码字符串
 */
- (NSString *)URLDecoded {
    return ( NSString *)CFBridgingRelease(CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault,(CFStringRef)self,CFSTR(""),kCFStringEncodingUTF8));
}

- (NSString *)URLEncodedParameterString {
	static CFStringRef toEscape = CFSTR(":/=,!$&'()*+;[]@#?");
    return ( NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
																				 ( CFStringRef)self,
																				 NULL,
																				 toEscape,
																				 kCFStringEncodingUTF8);
}


/**
 *  判断是否为email
 *
 *  @return 是email字符中返回YES,否则为NO
 */
- (BOOL) isEmail{
	
    NSString *emailRegEx =
	@"(?:[a-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[a-z0-9!#$%\\&'*+/=?\\^_`{|}"
	@"~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\"
	@"x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-"
	@"z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5"
	@"]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-"
	@"9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21"
	@"-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])";
	
    NSPredicate *regExPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegEx];
    return [regExPredicate evaluateWithObject:[self lowercaseString]];
}
- (BOOL) isURLString{
    NSString *emailRegEx =@"^http(s)?://([\\w-]+.)+[\\w-]+(/[\\w-./?%&=]*)?$";
	
    NSPredicate *regExPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegEx];
    return [regExPredicate evaluateWithObject:[self lowercaseString]];
}
- (BOOL) isNumberString{
    NSString *emailRegEx =@"^[0-9]+$";
	
    NSPredicate *regExPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegEx];
    return [regExPredicate evaluateWithObject:self];
}
- (BOOL) containsChinese{
   //[u4e00-u9fa5]
    for(int i = 0; i < [self length]; i++) {
        int a = [self characterAtIndex:i];
        if( a > 0x4e00 && a < 0x9fff)
            return YES;
    }
    return NO;
}
- (NSString *) escapeHTML{
	NSMutableString *s = [NSMutableString string];
	
	NSInteger start = 0;
	NSInteger len = [self length];
	NSCharacterSet *chs = [NSCharacterSet characterSetWithCharactersInString:@"<>&\""];
	
	while (start < len) {
		NSRange r = [self rangeOfCharacterFromSet:chs options:0 range:NSMakeRange(start, len-start)];
		if (r.location == NSNotFound) {
			[s appendString:[self substringFromIndex:start]];
			break;
		}
		
		if (start < r.location) {
			[s appendString:[self substringWithRange:NSMakeRange(start, r.location-start)]];
		}
		
		switch ([self characterAtIndex:r.location]) {
			case '<':
				[s appendString:@"&lt;"];
				break;
			case '>':
				[s appendString:@"&gt;"];
				break;
			case '"':
				[s appendString:@"&quot;"];
				break;
				//			case '…':
				//				[s appendString:@"&hellip;"];
				//				break;
			case '&':
				[s appendString:@"&amp;"];
				break;
		}
		
		start = r.location + 1;
	}
	
	return s;
}

- (NSString *) unescapeHTML{
	NSMutableString *s = [NSMutableString string];
	NSMutableString *target = [self mutableCopy];
	NSCharacterSet *chs = [NSCharacterSet characterSetWithCharactersInString:@"&"];
	
	while ([target length] > 0) {
		NSRange r = [target rangeOfCharacterFromSet:chs];
		if (r.location == NSNotFound) {
			[s appendString:target];
			break;
		}
		
		if (r.location > 0) {
			[s appendString:[target substringToIndex:r.location]];
			[target deleteCharactersInRange:NSMakeRange(0, r.location)];
		}
		
		if ([target hasPrefix:@"&lt;"]) {
			[s appendString:@"<"];
			[target deleteCharactersInRange:NSMakeRange(0, 4)];
		} else if ([target hasPrefix:@"&gt;"]) {
			[s appendString:@">"];
			[target deleteCharactersInRange:NSMakeRange(0, 4)];
		} else if ([target hasPrefix:@"&quot;"]) {
			[s appendString:@"\""];
			[target deleteCharactersInRange:NSMakeRange(0, 6)];
		} else if ([target hasPrefix:@"&#39;"]) {
			[s appendString:@"'"];
			[target deleteCharactersInRange:NSMakeRange(0, 5)];
		} else if ([target hasPrefix:@"&amp;"]) {
			[s appendString:@"&"];
			[target deleteCharactersInRange:NSMakeRange(0, 5)];
		} else if ([target hasPrefix:@"&hellip;"]) {
			[s appendString:@"…"];
			[target deleteCharactersInRange:NSMakeRange(0, 8)];
		} else {
			[s appendString:@"&"];
			[target deleteCharactersInRange:NSMakeRange(0, 1)];
		}
	}
	
	return s;
}
#pragma mark - URL Escaping and Unescaping

- (NSString *)stringByEscapingForURLQuery {
	NSString *result = self;
    
	static CFStringRef leaveAlone = CFSTR(" ");
	static CFStringRef toEscape = CFSTR("\n\r:/=,!$&'()*+;[]@#?%");
    
	CFStringRef escapedStr = CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, ( CFStringRef)self, leaveAlone,
																	 toEscape, kCFStringEncodingUTF8);
    
	if (escapedStr) {
		NSMutableString *mutable = [NSMutableString stringWithString:( NSString *)escapedStr];
		CFRelease(escapedStr);
        
		[mutable replaceOccurrencesOfString:@" " withString:@"+" options:0 range:NSMakeRange(0, [mutable length])];
		result = mutable;
	}
	return result;
}


- (NSString *)stringByUnescapingFromURLQuery {
	NSString *deplussed = [self stringByReplacingOccurrencesOfString:@"+" withString:@" "];
    return [deplussed stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

- (NSString*) stringByRemovingHTML{
	
	NSString *html = self;
    NSScanner *thescanner = [NSScanner scannerWithString:html];
    NSString *text = nil;
	
    while ([thescanner isAtEnd] == NO) {
		[thescanner scanUpToString:@"<" intoString:NULL];
		[thescanner scanUpToString:@">" intoString:&text];
		html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>",text] withString:@" "];
    }
	return html;
}

#pragma mark - Base64 Encoding

- (NSString *)base64EncodedString  {
    if ([self length] == 0) {
        return nil;
	}
	
	return [[self dataUsingEncoding:NSUTF8StringEncoding] base64EncodedString];
}

+ (NSString *)stringWithBase64String:(NSString *)base64String {
	return [[NSString alloc] initWithData:[NSData dataFromBase64EncodedString:base64String] encoding:NSUTF8StringEncoding];
}

@end
