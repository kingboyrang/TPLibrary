//
//  DownLoadManager.h
//  DownloadFileCache
//
//  Created by rang on 13-1-24.
//  Copyright (c) 2013年 rang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"
#import "ASIDownloadCache.h"
#import "DownLoadArgs.h"
#import "ASINetworkQueue.h"
//block
//#if NS_BLOCKS_AVAILABLE
typedef void (^progessDownLoadManager)(ASIHTTPRequest *request);
typedef void (^queueProgessDownload)(ASINetworkQueue *queue);
typedef void(^finishDownLoadManager)(NSString *filePath,NSDictionary *userInfo);
typedef void (^failedDownLoadManager)(NSError *error,NSDictionary *userInfo);
typedef void (^completeQueueDownload)();
//#endif
//protocol
@protocol DownloadManagerDelegate <NSObject>
@optional
-(void)downloadProgress:(ASIHTTPRequest*)request;
-(void)queueDownloadProgress:(ASINetworkQueue*)queue;
-(void)downloadFinished:(NSString*)filePath userInfo:(NSDictionary*)info;
-(void)downloadFailed:(NSError*)error userInfo:(NSDictionary*)info;
-(void)queueComplete;
@end

@interface DownloadManager : NSObject{
    progessDownLoadManager _progessDownLoadManager;
    finishDownLoadManager _finishdownloadBlock;
    failedDownLoadManager _faileddownloadBlock;
    completeQueueDownload _completeQueueDownload;
    queueProgessDownload _queueProgessDownload;
    //ASINetworkQueue *networkQueue;
    
}
@property(nonatomic,retain) ASIHTTPRequest *httpRequest;
@property(nonatomic,retain) NSMutableArray *requestList;
@property(nonatomic,retain) ASINetworkQueue *networkQueue;
@property(nonatomic,assign) id<DownloadManagerDelegate> delegate;
//单例模式
+ (DownloadManager *)sharedInstance;
//单文件下载
-(void)startDownload:(DownLoadArgs*)args;
-(void)startDownload:(DownLoadArgs*)args delegate:(id<DownloadManagerDelegate>)theDelegate;
-(void)startDownload:(DownLoadArgs*)args progress:(progessDownLoadManager)completion finishDownload:(finishDownLoadManager)finishBlock failedDownload:(failedDownLoadManager)failedBlock;
-(void)pauseDownload;
//文件队列下载
-(void)addQueue:(ASIHTTPRequest*)request;
-(void)startQueue;
-(void)startQueueDownload:(id<DownloadManagerDelegate>)theDelegate;
-(void)startQueueDownload:(queueProgessDownload)progess finishDownload:(finishDownLoadManager)finishBlock failedDownload:(failedDownLoadManager)failedBlock completeQueue:(completeQueueDownload)queueBlock;
@end
