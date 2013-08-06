//
//  ServiceResult.h
//  TPLibrary
//
//  Created by rang on 13-8-6.
//  Copyright (c) 2013年 rang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"
@interface ServiceResult : NSObject
@property(nonatomic,retain) ASIHTTPRequest *request;
@property(nonatomic,retain) NSDictionary *userInfo;
@property(nonatomic,retain) NSArray *sourceData;
@property(nonatomic,copy) NSString *soapMessage;
@property(nonatomic,copy) NSString *xmlString;
@property(nonatomic,copy) NSString *xmlValue;
+(id)requestResult:(ASIHTTPRequest*)httpRequest;
@end
