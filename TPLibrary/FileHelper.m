//
//  FileHelper.m
//  Eland
//
//  Created by aJia on 13/10/4.
//  Copyright (c) 2013年 rang. All rights reserved.
//

#import "FileHelper.h"

@implementation FileHelper
+ (NSString*)documentFilePath{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
}
+ (NSString*)cacheFilePath{
    return [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
}
+ (void)createDirectoryWithPath:(NSString*)midPath{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir = FALSE;
    BOOL isDirExist = [fileManager fileExistsAtPath:midPath isDirectory:&isDir];
    if(!(isDirExist && isDir))    {
        BOOL bCreateDir = [fileManager createDirectoryAtPath:midPath withIntermediateDirectories:YES attributes:nil error:nil];
        if(!bCreateDir){
            NSLog(@"Create Mid Directory Failed.");
        }
        NSLog(@"%@",midPath);
    }
}
+ (NSString*)createDirectoryWithPath:(NSString*)path directoryName:(NSString*)name{
    NSString *midPath = [path stringByAppendingPathComponent:name];
    [self createDirectoryWithPath:midPath];
    return midPath;
}
+ (NSString*)createDocumentDirectoryWithName:(NSString*)name{
    return [self createDirectoryWithPath:[self documentFilePath] directoryName:name];
}
+ (void)copyItemFromPath:(NSString*)fromPath toPath:(NSString*)toPath{
    if (fromPath&&toPath&&[self existsFilePath:fromPath]&&[toPath length]>0) {
        if (![self existsFilePath:toPath]) {
            [self createDirectoryWithPath:toPath];
        }
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if([fileManager fileExistsAtPath:fromPath] == NO && fromPath && toPath) {
            [fileManager copyItemAtPath:fromPath toPath:toPath error:nil];
        }
    }
}
+ (void)moveItemFromPath:(NSString*)fromPath toPath:(NSString*)toPath{
    if (fromPath&&toPath&&[self existsFilePath:fromPath]&&[toPath length]>0) {
        if (![self existsFilePath:toPath]) {
            [self createDirectoryWithPath:toPath];
        }
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if([fileManager fileExistsAtPath:fromPath] == NO && fromPath && toPath) {
            [fileManager moveItemAtPath:fromPath toPath:toPath error:nil];
        }
    }
}
+ (void)deleteFileWithPath:(NSString*)path{
    if (path&&[path length]>0) {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        [fileManager removeItemAtPath:path error:NULL];
    }
}
+ (BOOL)existsFilePath:(NSString*)path{
   NSFileManager *fileManager = [NSFileManager defaultManager];
    if(![fileManager fileExistsAtPath:path]){ //如果不存在
        return NO;
    }
    return YES;
}

/**
 *  获取文件大小
 *
 *  @param path 文件路径
 *
 *  @return 文件大小
 */
- (long long)fileSizeAtPath:(NSString *)path{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if ([fileManager fileExistsAtPath:path])
    {
        long long size = [fileManager attributesOfItemAtPath:path error:nil].fileSize;
        return size;
    }
    
    return 0;
}

/**
 *  获取文件夹大小
 *
 *  @param path 文件路径
 *
 *  @return 文件夹大小
 */
- (long long)folderSizeAtPath:(NSString *)path{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    long long folderSize = 0;
    
    if ([fileManager fileExistsAtPath:path])
    {
        NSArray *childerFiles = [fileManager subpathsAtPath:path];
        for (NSString *fileName in childerFiles)
        {
            NSString *fileAbsolutePath = [path stringByAppendingPathComponent:fileName];
            if ([fileManager fileExistsAtPath:fileAbsolutePath])
            {
                long long size = [fileManager attributesOfItemAtPath:fileAbsolutePath error:nil].fileSize;
                folderSize += size;
            }
        }
    }
    
    return folderSize;
}
@end
