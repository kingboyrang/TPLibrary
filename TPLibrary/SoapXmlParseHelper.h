//
//  XmlParseHelper.h
//  HttpRequest
//
//  Created by rang on 12-11-10.
//
//

#import <Foundation/Foundation.h>
#import "GDataXMLNode.h"


@interface SoapXmlParseHelper : NSObject
/******************************webservice调用返回的xml处理*************************************/
/****获取webservice调用返回的xml内容
   @param data:为NSData或NSString
   @param methodName:调用的webservice方法名
   @return 返回节点内容
 ***/
+(NSString*)soapMessageResultXml:(id)xml serviceMethodName:(NSString*)methodName;
/******************************xml转换成数组处理***********************************************/
/*****xml转换成Array
   @param xml:NSData或NSString
   @return 返回数组
 *****/
+(NSMutableArray*)xmlToArray:(id)xml;

/******************************xml节点查询处理************************************************/
/*****查找指定节点保存到数组中
   @param data:NSData或NSString
   @param name:节点名称
   @param options:是否为对象节点
   @return 返回数组
 *****/
+(NSMutableArray*)searchNodeToArray:(id)data nodeName:(NSString*)name;
/*****查找指定节点保存到数组中
   @param data:NSData或NSString
   @param name:查找的节点名称
   @param className:对象名称
   @param options:是否为对象节点
   @return 返回数组
 *****/
+(NSMutableArray*)searchNodeToObject:(id)data nodeName:(NSString*)name objectName:(NSString*)className;
/******************************xml操作辅助方法***********************************************/
/*****获取GDataXMLDocument对象
 @param data:NSData或NSString
 @param name:查找的节点名称
 @param options:是否为对象节点
 @return 返回对象
 *****/
+(GDataXMLDocument*)xmlDocumentObject:(id)data nodeName:(NSString*)name;
/*****获取当前节点下的所有子节点保存到字典中
 @param node:节点
 @return 返回字典
 *****/
+(NSMutableDictionary*)childsNodeToDictionary:(GDataXMLNode*)node;
/*****获取当前节点下的所有子节点保存到对象中
 @param node:当前节点
 @param className:转换的对象名称
 @return 返回对象
 *****/
+(id)childsNodeToObject:(GDataXMLNode*)node objectName:(NSString*)className;
/******************************xml根节点操作**************************************************/
//获取根节点下的子节点
+(NSMutableDictionary*)rootNodeToArray:(id)data;
+(id)rootNodeToObject:(id)data objectName:(NSString*)className;
@end
