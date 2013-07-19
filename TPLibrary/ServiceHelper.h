//
//  ServiceHelper.h
//  HttpRequest
//
//  Created by aJia on 2012/10/27.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASINetworkQueue.h"
#import "ASIHTTPRequest.h"
#import "ServiceArgs.h"
//block
typedef void (^progressRequestBlock)(ASIHTTPRequest *request);
typedef void (^finishBlockRequest)(NSString *xml,NSDictionary *userInfo);
typedef void (^failedBlockRequest)(NSError *error,NSDictionary *userInfo);
typedef void (^finishBlockQueueComplete)();
//protocol
@protocol ServiceHelperDelegate<NSObject>
@optional
-(void)progressRequest:(ASIHTTPRequest*)request;
-(void)finishSoapRequest:(NSString*)xml userInfo:(NSDictionary*)dic;
-(void)failedSoapRequest:(NSError*)error userInfo:(NSDictionary*)dic;
-(void)finishQueueComplete;
@end

@interface ServiceHelper : NSObject{
    
    finishBlockRequest _finishBlock;
    failedBlockRequest _failedBlock;
    finishBlockQueueComplete _finishQueueBlock;
    progressRequestBlock _progressBlock;
     
}
@property(nonatomic,assign) id<ServiceHelperDelegate> delegate;
@property(nonatomic,retain) ASIHTTPRequest *httpRequest;
@property(nonatomic,retain) NSMutableArray *requestList;
@property(nonatomic,retain) ASINetworkQueue *networkQueue;
//单例模式
+ (ServiceHelper *)sharedInstance;
//初始化
-(id)initWithDelegate:(id<ServiceHelperDelegate>)theDelegate;

/******设置公有的请求****/
-(ASIHTTPRequest*)commonSharedRequest:(ServiceArgs*)args;
+(ASIHTTPRequest*)commonSharedRequest:(ServiceArgs*)args;
/***
 **同步请求
 ***/
-(NSString*)syncService:(ServiceArgs*)args;
-(NSString*)syncService:(ServiceArgs*)args error:(NSError**)error;
+(NSString*)syncService:(ServiceArgs*)args;
+(NSString*)syncService:(ServiceArgs*)args error:(NSError**)error;
/***
 **异步请求
 ***/
-(void)asynService:(ServiceArgs*)args;
-(void)asynService:(ServiceArgs*)args delegate:(id<ServiceHelperDelegate>)theDelegate;
-(void)asynService:(ServiceArgs*)args completed:(finishBlockRequest)finish failed:(failedBlockRequest)failed;
-(void)asynService:(ServiceArgs*)args progress:(progressRequestBlock)progress completed:(finishBlockRequest)finish failed:(failedBlockRequest)failed;
+(void)asynService:(ServiceArgs*)args delegate:(id<ServiceHelperDelegate>)theDelegate;
+(void)asynService:(ServiceArgs*)args completed:(finishBlockRequest)finish failed:(failedBlockRequest)failed;
+(void)asynService:(ServiceArgs*)args progress:(progressRequestBlock)progress completed:(finishBlockRequest)finish failed:(failedBlockRequest)failed;
/***
 **队列请求
 ***/
-(void)addQueue:(ASIHTTPRequest*)request;
-(void)startQueue;
-(void)startQueue:(id<ServiceHelperDelegate>)theDelegate;
-(void)startQueue:(finishBlockRequest)finish failed:(failedBlockRequest)failed complete:(finishBlockQueueComplete)finishQueue;
@end
