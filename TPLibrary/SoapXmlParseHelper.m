//
//  XmlParseHelper.m
//  HttpRequest
//
//  Created by rang on 12-11-10.
//
//

#import "SoapXmlParseHelper.h"
#import "GDataXMLNode.h"

@interface SoapXmlParseHelper () //私有方法
/*****xml节点转换成Array
 @param node:节点
 @return 返回数组
 *****/
+(NSMutableArray*)nodeChilds:(GDataXMLNode*)node;
@end

@implementation SoapXmlParseHelper
#pragma mark -
#pragma mark 获取methodName+Result里面的内容
+(NSString*)soapMessageResultXml:(id)data serviceMethodName:(NSString*)methodName{
    GDataXMLDocument *document=[self xmlDocumentObject:data nodeName:nil];
    if (document) {
        GDataXMLElement* rootNode = [document rootElement];
        NSString *searchStr=[NSString stringWithFormat:@"%@Result",methodName];
        NSString *MsgResult=@"";
        NSArray *result=[rootNode children];
        while ([result count]>0) {
            NSString *nodeName=[[result objectAtIndex:0] name];
            if ([nodeName isEqualToString: searchStr]) {
                MsgResult=[[result objectAtIndex:0] XMLString];
                break;
            }
            result=[[result objectAtIndex:0] children];
        }
        if ([MsgResult length]==0) {
            return (NSString*)data;
        }
        return MsgResult;
    }
    return (NSString*)data;
}
#pragma mark -
#pragma mark 将xml转换成数组
+(NSMutableArray*)xmlToArray:(id)xml{
    NSMutableArray *arr=[NSMutableArray array];
    GDataXMLDocument *document=[self xmlDocumentObject:xml nodeName:nil];
    if (document) {
        GDataXMLElement* rootNode = [document rootElement];
        NSArray *rootChilds=[rootNode children];
        for (GDataXMLNode *node in rootChilds) {
            NSString *nodeName=node.name;
            if ([node.children count]>0) {
                [arr addObject:[NSDictionary dictionaryWithObjectsAndKeys:[self nodeChilds:node],nodeName, nil]];
            }else{
                [arr addObject:[NSDictionary dictionaryWithObjectsAndKeys:[node stringValue],nodeName, nil]];
            }
        }
    }
    return arr;
}
+(NSMutableArray*)nodeChilds:(GDataXMLNode*)node{
    NSMutableArray *arr=[NSMutableArray array];
    NSArray *childs=[node children];
    NSMutableDictionary *dic=[NSMutableDictionary dictionary];
    for (GDataXMLNode* child in childs){
        NSString *nodeName=child.name;//获取节点名称
        NSArray  *childNode=[child children];
        if ([childNode count]>0) {//存在子节点
            [dic setValue:[self nodeChilds:child] forKey:nodeName];
        }else{
            [dic setValue:[child stringValue] forKey:nodeName];
        }
    }
    [arr addObject:dic];
    return arr;
}
#pragma mark -
#pragma mark xml查询处理
+(NSMutableArray*)searchNodeToArray:(id)data nodeName:(NSString*)nodeName{
    NSMutableArray *array=[NSMutableArray array];
    GDataXMLDocument *document=[self xmlDocumentObject:data nodeName:nodeName];
    if (document) {
        NSString *searchStr=[NSString stringWithFormat:@"//%@",nodeName];
        GDataXMLElement* rootNode = [document rootElement];
        NSArray *childs=[rootNode nodesForXPath:searchStr error:nil];
        for (GDataXMLNode *item in childs){
            [array addObject:[self childsNodeToDictionary:item]];
        }
    }
    return array;
}
+(NSMutableArray*)searchNodeToObject:(id)data nodeName:(NSString*)name objectName:(NSString*)className{
    NSMutableArray *array=[NSMutableArray array];
    GDataXMLDocument *document=[self xmlDocumentObject:data nodeName:name];
    if (document) {
        NSString *searchStr=[NSString stringWithFormat:@"//%@",name];
        GDataXMLElement* rootNode = [document rootElement];
        NSArray *childs=[rootNode nodesForXPath:searchStr error:nil];
        for (GDataXMLNode *item in childs){
            [array addObject:[self childsNodeToObject:item objectName:className]];
        }
    }
    return array;
}
#pragma mark -
#pragma mark xml操作辅助方法
+(GDataXMLDocument*)xmlDocumentObject:(id)data nodeName:(NSString*)name{
    NSError *error=nil;
    GDataXMLDocument *document=nil;
    if (name) {
        NSString *xml=nil;
        if ([data isKindOfClass:[NSString class]]){
            xml=(NSString*)data;
        }else{
           xml=[[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
        }
        if (xml) {
            xml=[xml stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"xmlns=\"%@\"",name] withString:@""];
            
            document=[[GDataXMLDocument alloc] initWithXMLString:xml options:0 error:&error];
        }
    }else{
        if ([data isKindOfClass:[NSString class]]) {
          document=[[GDataXMLDocument alloc] initWithXMLString:data options:0 error:&error];
        }else{
          document=[[GDataXMLDocument alloc] initWithData:data options:0 error:&error];
        }
    }
    if (error||document==nil) {
        return nil;
    }
    //[document setCharacterEncoding:@"uft-8"];
    return [document autorelease];
}
+(NSMutableDictionary*)childsNodeToDictionary:(GDataXMLNode*)node{
    NSMutableDictionary *dic=[NSMutableDictionary dictionary];
    NSArray *childs=[node children];
    for (GDataXMLNode *item in childs) {
        [dic setValue:[item stringValue] forKey:item.name];
    }
    return dic;
}
+(id)childsNodeToObject:(GDataXMLNode*)node objectName:(NSString*)className{
    id obj=[[NSClassFromString(className) alloc] init];
    NSArray *childs=[node children];
    for (GDataXMLNode *item in childs){
        SEL sel=NSSelectorFromString(item.name);
        if ([obj respondsToSelector:sel]) {
            [obj setValue:[item stringValue] forKey:item.name];
        }
    }
    return [obj autorelease];
}
#pragma mark -
#pragma mark 对于xml只有一个根节点的处理
+(NSMutableDictionary*)rootNodeToArray:(id)data{
    NSMutableDictionary *dic=[NSMutableDictionary dictionary];
    GDataXMLDocument *document=[self xmlDocumentObject:data nodeName:nil];
    if (document) {
        GDataXMLElement* rootNode = [document rootElement];
        dic=[self childsNodeToDictionary:rootNode];
    }
    return dic;
}
+(id)rootNodeToObject:(id)data objectName:(NSString*)className{
    id obj=[[NSClassFromString(className) alloc] init];
    GDataXMLDocument *document=[self xmlDocumentObject:data nodeName:nil];
    if (document) {
        GDataXMLElement* rootNode = [document rootElement];
        obj=[self childsNodeToObject:rootNode objectName:className];
    }
    return [obj autorelease];
}
@end
