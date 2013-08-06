//
//  ServiceResult.m
//  TPLibrary
//
//  Created by rang on 13-8-6.
//  Copyright (c) 2013年 rang. All rights reserved.
//

#import "ServiceResult.h"
#import "SoapXmlParseHelper.h"
@implementation ServiceResult
@synthesize request,userInfo;
@synthesize soapMessage;
@synthesize sourceData,xmlValue,xmlString;
+(id)requestResult:(ASIHTTPRequest*)httpRequest{
    ServiceResult *entity=[[ServiceResult alloc] init];
    entity.request=httpRequest;
    entity.userInfo=[httpRequest userInfo];
    entity.soapMessage=[httpRequest responseString];
    
    NSString *temp=entity.soapMessage;
    int statusCode = [httpRequest responseStatusCode];
    NSError *error=[httpRequest error];
    //如果发生错误，就返回空
    if (error||statusCode!=200) {
        temp=@"";
    }
    NSString *soapAction=[[httpRequest requestHeaders] objectForKey:@"SOAPAction"];
    NSString *methodName=@"";
    NSRange range = [soapAction  rangeOfString:@"/" options:NSBackwardsSearch];
    if(range.location!=NSNotFound){
        int pos=range.location;
        methodName=[soapAction stringByReplacingCharactersInRange:NSMakeRange(0, pos+1) withString:@""];
    }
    NSString *content=nil;
    entity.xmlString=[SoapXmlParseHelper soapMessageResultXml:entity.soapMessage serviceMethodName:methodName xmlData:&content];
    entity.xmlValue=content;
    if ([entity.xmlString length]>0) {
        entity.sourceData=[SoapXmlParseHelper xmlToArray:entity.xmlString];
    }
    return [entity autorelease];
}
@end
