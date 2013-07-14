//
//  DownLoadManager.m
//  DownloadFileCache
//
//  Created by rang on 13-1-24.
//  Copyright (c) 2013年 rang. All rights reserved.
//

#import "DownloadManager.h"

@interface DownloadManager () //私有方法
-(void)resetQueue;
@end

@implementation DownloadManager
@synthesize httpRequest,requestList;
@synthesize networkQueue,delegate;
+ (DownloadManager *)sharedInstance
{
    static dispatch_once_t  onceToken;
    static DownloadManager * sSharedInstance;
    
    dispatch_once(&onceToken, ^{
        sSharedInstance = [[DownloadManager alloc] init];
    });
    return sSharedInstance;
}
-(void)startDownload:(DownLoadArgs*)args progress:(progessDownLoadManager)completion finishDownload:(finishDownLoadManager)finishBlock failedDownload:(failedDownLoadManager)failedBlock{
    Block_release(_progessDownLoadManager);
    Block_release(_faileddownloadBlock);
    Block_release(_finishdownloadBlock);
    
    _progessDownLoadManager=Block_copy(completion);
    _faileddownloadBlock=Block_copy(failedBlock);
    _finishdownloadBlock=Block_copy(finishBlock);
    
    //文件下载设置
    [self.httpRequest clearDelegatesAndCancel];
    [self setHttpRequest:[ASIHTTPRequest requestWithURL:[NSURL URLWithString:args.downloadUrl]]];
    //设置是是否支持断点下载
    [self.httpRequest setAllowResumeForFileDownloads:YES];
    //暂停请求[self.httpRequest clearDelegatesAndCancel];
    //继续下载[self.httpRequest setAllowResumeForFileDownloads:YES]
    
    if (self.delegate&&[self.delegate respondsToSelector:@selector(downloadProgress:)]) {
        [self.delegate downloadProgress:self.httpRequest];
    }
    
    if (_progessDownLoadManager) {
        _progessDownLoadManager(self.httpRequest);
    }
    
    //iOS4中，当应用后台运行时仍然请求数据：
    [self.httpRequest setShouldContinueWhenAppEntersBackground:YES];
    //self.httpRequest.showNetworkActivityIndicator=NO;
    //是否显示网络请求信息在status bar上：
    [ASIHTTPRequest setShouldUpdateNetworkActivityIndicator:NO];
    
    [self.httpRequest setDefaultResponseEncoding:NSUTF8StringEncoding];
    
    if (args.isFileCache) {//表示缓存下载
        ASIDownloadCache *myCache=[ASIDownloadCache sharedCache];
        [myCache setStoragePath:args.fileSavePath];//设置缓存路径
        /***
         **ASIOnlyLoadIfNotCachedCachePolicy:如果有缓存在本地，不管其过期与否，总会拿来使用
         **ASIFallbackToCacheIfLoadFailsCachePolicy:这个选项经常被用来与其它选项组合使用。请求失败时，如果有缓存当网络则返回本地缓存信息（这个在处理异常时非常有用）
         **ASIAskServerIfModifiedCachePolicy:与默认缓存大致一样，区别仅是每次请求都会 去服务器判断是否有更新
         ****/
        [myCache setDefaultCachePolicy:ASIAskServerIfModifiedCachePolicy|ASIFallbackToCacheIfLoadFailsCachePolicy];
        
        [self.httpRequest setDownloadCache:myCache];//设置下载缓存
        /****
         ***ASICacheForSessionDurationCacheStoragePolicy:默认策略，基于session的缓存数据存储。当下次运行或[ASIHTTPRequest clearSession]时，缓存将失效
         ***ASICachePermanentlyCacheStoragePolicy，把缓存数据永久保存在本地
         ***/
        [self.httpRequest setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
        [self.httpRequest setSecondsToCache:60*60*24*1 ]; // 缓存1天
        
        [self.httpRequest setDownloadDestinationPath:[myCache pathToStoreCachedResponseDataForRequest:self.httpRequest]];
    }else{
        //文件保存路径
        [self.httpRequest setDownloadDestinationPath:args.fullSaveFilePath];
    }
    //断点续传下载必须设置临时文件下载目录
    [self.httpRequest setTemporaryFileDownloadPath:args.tmpSaveFilePath];
    
    [self.httpRequest setDelegate:self];
    [self.httpRequest startAsynchronous];
}
-(void)startDownload:(DownLoadArgs*)args delegate:(id<DownloadManagerDelegate>)theDelegate{
    self.delegate=theDelegate;
    [self startDownload:args progress:nil finishDownload:nil failedDownload:nil];
}
-(void)startDownload:(DownLoadArgs*)args{
    [self startDownload:args progress:nil finishDownload:nil failedDownload:nil];
}
#pragma mark -
#pragma mark ASIHTTPRequest delegate Methods
- (void)request:(ASIHTTPRequest *)request didReceiveResponseHeaders:(NSDictionary *)responseHeaders{
    //NSLog(@"X-Powered-By=%@\n",[responseHeaders objectForKey:@"X-Powered-By"]);
     //NSLog(@"Content-Type=%@\n",[responseHeaders objectForKey:@"Content-Type"]);
}
//下载成功
- (void)requestFinished:(ASIHTTPRequest *)request
{
    
    /***
    //判断返回的数据是否来自本地缓存
    if (request.didUseCachedResponse) {
        NSLog(@"使用缓存数据");
    } else {
        NSLog(@"请求网络数据");
    }
     **/
    NSString *filePath=[request downloadDestinationPath];
    if (self.delegate&&[self.delegate respondsToSelector:@selector(downloadFinished:userInfo:)]) {
        [self.delegate downloadFinished:filePath userInfo:[request userInfo]];
    } 
    if (_finishdownloadBlock) {
        _finishdownloadBlock(filePath,[request userInfo]);
    }
}
//下载失败
- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSError *error=[request error];
    //NSLog(@"AAerror=%@\n",[error description]);
    if (self.delegate&&[self.delegate respondsToSelector:@selector(downloadFailed:userInfo:)]) {
        [self.delegate downloadFailed:error userInfo:[request userInfo]];
    }
    
    if (_faileddownloadBlock) {
        _faileddownloadBlock(error,[request userInfo]);
    }
    
}
-(void)pauseDownload{
    if (self.httpRequest) {
        [self.httpRequest clearDelegatesAndCancel];//暂停下载
    }
}
#pragma mark -
#pragma mark 私有方法
-(void)resetQueue{
    if (!self.networkQueue) {
        self.networkQueue = [[ASINetworkQueue alloc] init];
    }
    [self.networkQueue reset];
    //表示队列操作完成
    if (self.delegate&&[self.delegate respondsToSelector:@selector(queueDownloadProgress:)]) {
        [self.delegate queueDownloadProgress:self.networkQueue];
    }
    if (_queueProgessDownload) {
        _queueProgessDownload(self.networkQueue);
    }
    [self.networkQueue setQueueDidFinishSelector:@selector(queueFetchComplete:)];
    [self.networkQueue setRequestDidFinishSelector:@selector(requestFetchComplete:)];
    [self.networkQueue setRequestDidFailSelector:@selector(requestFetchFailed:)];
    [self.networkQueue setDelegate:self];
}
#pragma mark -
#pragma mark 队列处理
-(void)addQueue:(ASIHTTPRequest*)request{
    if (!self.requestList) {
		self.requestList = [[NSMutableArray alloc] init];
	}
    [self.requestList addObject:request];
}
-(void)startQueue{
    [self resetQueue];
    for (ASIHTTPRequest *item in self.requestList) {
        [self.networkQueue addOperation:item];
    }
    [self.networkQueue go];
}
-(void)queueFetchComplete:(ASIHTTPRequest*)request{
    
    if (self.delegate&&[self.delegate respondsToSelector:@selector(queueComplete)]) {
        [self.delegate queueComplete];
    }
    
    if (_completeQueueDownload) {
        _completeQueueDownload();
    }
}
-(void)requestFetchComplete:(ASIHTTPRequest*)request{
    
    if (self.delegate&&[self.delegate respondsToSelector:@selector(downloadFinished:userInfo:)]) {
        [self.delegate downloadFinished:[request downloadDestinationPath] userInfo:[request userInfo]];
    }
    
    if (_finishdownloadBlock) {
        _finishdownloadBlock([request downloadDestinationPath],[request userInfo]);
    }
}
-(void)requestFetchFailed:(ASIHTTPRequest*)request{
    NSError *error=[request error];
    
    if (self.delegate&&[self.delegate respondsToSelector:@selector(downloadFailed:userInfo:)]) {
        [self.delegate downloadFailed:error userInfo:[request userInfo]];
    }
    
    if (_faileddownloadBlock) {
        _faileddownloadBlock(error,[request userInfo]);
    }
}
-(void)startQueueDownload:(id<DownloadManagerDelegate>)theDelegate{
    self.delegate=theDelegate;
    [self startQueueDownload:nil finishDownload:nil failedDownload:nil completeQueue:nil];
}
-(void)startQueueDownload:(queueProgessDownload)progess finishDownload:(finishDownLoadManager)finishBlock failedDownload:(failedDownLoadManager)failedBlock completeQueue:(completeQueueDownload)queueBlock{
    
    Block_release(_completeQueueDownload);
    Block_release(_faileddownloadBlock);
    Block_release(_finishdownloadBlock);
    Block_release(_queueProgessDownload);
    
    _completeQueueDownload=Block_copy(queueBlock);
    _queueProgessDownload=Block_copy(progess);
    _faileddownloadBlock=Block_copy(failedBlock);
    _finishdownloadBlock=Block_copy(finishBlock);
    
    [self startQueue];
}
-(void)dealloc{
    [httpRequest clearDelegatesAndCancel];
    [httpRequest release];
    Block_release(_progessDownLoadManager);
    Block_release(_faileddownloadBlock);
    Block_release(_finishdownloadBlock);
    Block_release(_completeQueueDownload);
    Block_release(_queueProgessDownload);
    
    [requestList release];
    [networkQueue reset];
	[networkQueue release];
    [super dealloc];
}
@end
