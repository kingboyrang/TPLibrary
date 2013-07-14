//
//  DownLoadArgs.m
//  DownloadFileCache
//
//  Created by rang on 13-1-25.
//  Copyright (c) 2013年 rang. All rights reserved.
//

#import "DownLoadArgs.h"

#define documentDir [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]
#define cacheDir [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0]
#define tmpDir NSTemporaryDirectory()

@interface DownLoadArgs()//私有方法
-(void)createDirectory:(NSString*)filePath;//创建目录
@end

@implementation DownLoadArgs
@synthesize downloadUrl,downloadFileName,fileSavePath;
@synthesize fullSaveFilePath,isFileCache,isExistsFileDownload;

//单例模式
+ (DownLoadArgs *)sharedInstance{
    static dispatch_once_t  onceToken;
    static DownLoadArgs * sSharedInstance;
    
    dispatch_once(&onceToken, ^{
        sSharedInstance = [[DownLoadArgs alloc] init];
    });
    return sSharedInstance;
}
-(void)createDirectory:(NSString*)filePath{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:filePath])
    {
        [fileManager createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:NULL];
    }

}
#pragma mark -
#pragma mark 属性方法重写
-(NSString*)fileSavePath{
    if (fileSavePath) {
        return fileSavePath;
    }
    if (isFileCache) {//表示缓存
        return [self defaultCacheSavePath];
    }
    return [self defaultSavePath];
    
}
-(NSString*)fullSaveFilePath{
    NSString *cachePath=[self fileSavePath];
    [self createDirectory:cachePath];
    return [cachePath stringByAppendingPathComponent:self.downloadFileName];
}
-(NSString*)tmpSaveFilePath{
    NSString *path=[NSString stringWithFormat:@"%@/tmpDownload",tmpDir];
    [self createDirectory:path];
    return [path stringByAppendingPathComponent:self.downloadFileName];
}
-(BOOL)isExistsFileDownload{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:[self fullSaveFilePath]]) {
        return YES;
    }
    return NO;
}
#pragma mark -
#pragma mark 默认文件保存路径
//默认文件保存路径
-(NSString*)defaultSavePath{
    NSString *cachePath=[NSString stringWithFormat:@"%@/defaultDownload",documentDir];
    [self createDirectory:cachePath];
    return cachePath;
}
//默认缓存保存路径
-(NSString*)defaultCacheSavePath{
    NSString *cachePath=[NSString stringWithFormat:@"%@/defaultCacheDownload",cacheDir];
    [self createDirectory:cachePath];
    return cachePath;
}
@end
