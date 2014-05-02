//
//  FileHelper.h
//  Eland
//
//  Created by aJia on 13/10/4.
//  Copyright (c) 2013年 rang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileHelper : NSObject
/**
 ** @reutrn 获取document文件路径
 **/
+ (NSString*)documentFilePath;
/**
 ** @reutrn 获取缓存文件路径
 **/
+ (NSString*)cacheFilePath;
/**
 ** @param path 文件路径
 ** @reutrn 创建文件目录
 **/
+ (void)createDirectoryWithPath:(NSString*)path;
/**
 ** @param path 文件路径
 ** @param name 目录名
 ** @reutrn 创建文件目录
 **/
+ (NSString*)createDirectoryWithPath:(NSString*)path directoryName:(NSString*)name;
/**
 ** @param name 目录名
 ** @reutrn 创建document文件目录
 **/
+ (NSString*)createDocumentDirectoryWithName:(NSString*)name;
/**
 ** @param fromPath copy项从那里的路径开始
 ** @param toPath 将copy项保存到这个路径
 ** @reutrn 将文件cope到另一个文件路径
 **/
+ (void)copyItemFromPath:(NSString*)fromPath toPath:(NSString*)toPath;
/**
 ** @param fromPath copy项从那里的路径开始
 ** @param toPath 将copy项保存到这个路径
 ** @reutrn 将文件move到另一个文件路径
 **/
+ (void)moveItemFromPath:(NSString*)fromPath toPath:(NSString*)toPath;
/**
 ** @param name 文件路径
 ** @reutrn 删除文件
 **/
+ (void)deleteFileWithPath:(NSString*)path;
/**
 ** @reutrn 判断文件是否存在
 **/
+ (BOOL)existsFilePath:(NSString*)path;

@end
