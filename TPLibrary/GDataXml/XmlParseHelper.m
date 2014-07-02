//
//  XmlParseHelper.m
//  IOSWebservices
//
//  Created by rang on 13-8-8.
//  Copyright (c) 2013年 rang. All rights reserved.
//

#import "XmlParseHelper.h"
#import "GDataXMLNode.h"
#import "XmlNode.h"
#define soapXmlNamespaces [NSDictionary dictionaryWithObjectsAndKeys:@"http://schemas.xmlsoap.org/soap/envelope/",@"soap",@"http://www.w3.org/2001/XMLSchema-instance",@"xsi",@"http://www.w3.org/2001/XMLSchema",@"xsd",nil]
@interface XmlNode()
-(XmlNode*)xmlStringToXmlNode;
-(NSDictionary*)getNodeAttributes:(GDataXMLNode*)node;
-(NSString*)getInnerXml:(GDataXMLNode*)node;
-(NSArray*)getChildNodes:(GDataXMLNode*)parentNode parent:(XmlNode*)parent;
-(NSMutableDictionary*)childsNodeToDictionary:(GDataXMLNode*)node;

-(GDataXMLDocument*)xmlDocumentObject:(id)data;
-(GDataXMLNode*)getSingleNode:(NSString*)xpath;
-(GDataXMLNode*)getSingleNode:(NSString*)xpath nameSpaces:(NSDictionary*)spaces;
@end

@implementation XmlParseHelper
@synthesize document=_document;
@synthesize xmlNode=_xmlNode;
-(void)dealloc{
    [super dealloc];
    [_document release];
}
-(id)initWithData:(id)xml{
    if (self=[super init]) {
        self.document=[self xmlDocumentObject:xml];
    }
    return self;
}
-(void)setDataSource:(id)data{
    self.document=[self xmlDocumentObject:data];
}
-(NSString*)soapMessageResultXml:(NSString*)methodName{
    if (methodName) {
        NSString *searchStr=[NSString stringWithFormat:@"//%@Result",methodName];
        GDataXMLNode *node=[self getSingleNode:searchStr];
        if (node) {
            return node.stringValue;
        }
    }
    return @"";
    /***
    if (self.document) {
        GDataXMLElement *root=[self.document rootElement];
        NSString *searchStr=[NSString stringWithFormat:@"%@Result",methodName];
        NSString *MsgResult=@"";
        NSArray *result=[root children];
        while ([result count]>0) {
            NSString *nodeName=[[result objectAtIndex:0] name];
            if ([nodeName isEqualToString: searchStr]) {
                MsgResult=[[result objectAtIndex:0] stringValue];
                break;
            }
            result=[[result objectAtIndex:0] children];
        }
        return MsgResult;
    }
    return @"";
     ***/
}
-(XmlNode*)xmlNode{
    if (!_xmlNode) {
        _xmlNode=[self xmlStringToXmlNode];
    }
    return _xmlNode;
}
-(XmlNode*)selectSingleNode:(NSString*)xpath{
    if (self.document) {
        return [self selectSingleNode:xpath namespaces:nil];
    }
    return nil;
}
-(XmlNode*)selectSingleNode:(NSString*)xpath namespaces:(NSDictionary*)spaces{
    GDataXMLNode *node=[self getSingleNode:xpath namespaces:spaces];
    if (node) {
            XmlNode *entity=[[[XmlNode alloc] init] autorelease];
            entity.Name=node.name;
            entity.Attributes=[self getNodeAttributes:node];
            entity.Value=node.stringValue;
            entity.InnerText=node.stringValue;
            entity.InnerXml=[self getInnerXml:node];
            entity.OuterXml=node.XMLString;
            entity.ChildNodes=[self getChildNodes:node parent:entity];
            return entity;
    }
    return nil;
}
-(NSArray*)selectNodes:(NSString*)xpath{
    return [self selectNodes:xpath namespaces:nil];
}
-(NSArray*)selectNodes:(NSString*)xpath namespaces:(NSDictionary*)spaces{
    if (self.document) {
        NSMutableArray *array=[NSMutableArray array];
        GDataXMLElement* rootNode = [self.document rootElement];
        NSArray *childs;
        if (spaces) {
            childs=[rootNode nodesForXPath:xpath namespaces:spaces error:nil];
        }else{
            childs=[rootNode nodesForXPath:xpath error:nil];
        }
        for (GDataXMLNode *item in childs){
            [array addObject:[self childsNodeToDictionary:item]];
        }
        return array;
    }
    return nil;
}
-(NSArray*)selectNodes:(NSString*)xpath forObject:(Class)cls{
    
    return [self selectNodes:xpath namespaces:nil forObject:cls];
}
-(NSArray*)selectNodes:(NSString*)xpath namespaces:(NSDictionary*)spaces forObject:(Class)cls{
    if (self.document) {
        NSMutableArray *array=[NSMutableArray array];
        GDataXMLElement* rootNode = [self.document rootElement];
        NSArray *childs;
        if (spaces) {
            childs=[rootNode nodesForXPath:xpath namespaces:spaces error:nil];
        }else{
            childs=[rootNode nodesForXPath:xpath error:nil];
        }
        for (GDataXMLNode *item in childs){
            [array addObject:[self childsNodeToObject:item forObject:cls]];
        }
        return array;
    }
    return nil;
}
-(id)nodeToObject:(GDataXMLNode*)node forObject:(Class)cls{
    if (node&&cls) {
        return [self childsNodeToObject:node forObject:cls];
    }
    return nil;
}
-(NSArray*)nodesChildsNodesToObjects:(GDataXMLNode*)node forObject:(Class)cls{
    NSMutableArray *result=[NSMutableArray array];
    NSArray *childs=[node children];
    for (GDataXMLNode *item in childs){
        [result addObject:[self childsNodeToObject:item forObject:cls]];
    }
    return result;
}
-(XmlNode*)soapXmlSelectSingleNode:(NSString*)xpath{
    return [self selectSingleNode:xpath namespaces:soapXmlNamespaces];
}
-(NSArray*)soapXmlSelectNodes:(NSString*)xpath{
    return [self selectNodes:xpath namespaces:soapXmlNamespaces];
}
-(NSArray*)soapXmlSelectNodes:(NSString*)xpath forObject:(Class)cls{
    
    return [self selectNodes:xpath namespaces:soapXmlNamespaces forObject:cls];
}
-(NSDictionary*)getXmlNodeAttrs:(GDataXMLNode*)node{
    return [self getNodeAttributes:node];
}
-(NSDictionary*)selectSingleNodeAttrs:(NSString*)xpath{
    return [self selectSingleNodeAttrs:xpath namespaces:nil];
}
-(NSDictionary*)selectSingleNodeAttrs:(NSString*)xpath namespaces:(NSDictionary*)spaces{
    GDataXMLNode *node=[self getSingleNode:xpath namespaces:spaces];
    if (node) {
        return [self getNodeAttributes:node];
    }
    return nil;
}
-(NSArray*)selectNodeAttrs:(NSString*)xpath{
    return [self selectNodeAttrs:xpath namespaces:nil];
}
-(NSArray*)selectNodeAttrs:(NSString*)xpath namespaces:(NSDictionary*)spaces{
    if (self.document) {
        NSMutableArray *array=[NSMutableArray array];
        GDataXMLElement* rootNode = [self.document rootElement];
        NSArray *childs;
        if (spaces) {
            childs=[rootNode nodesForXPath:xpath namespaces:spaces error:nil];
        }else{
            childs=[rootNode nodesForXPath:xpath error:nil];
        }
        for (GDataXMLNode *item in childs){
            [array addObject:[self getNodeAttributes:item]];
        }
        return array;

    }
    return nil;
}
-(NSString*)getXmlNodeValue:(GDataXMLNode*)node{
    if (node) {
        return node.stringValue;
    }
    return nil;
}
-(NSString*)selectSingleNodeValue:(NSString*)xpath{
    return [self selectSingleNodeValue:xpath namespaces:nil];
}
-(NSString*)selectSingleNodeValue:(NSString*)xpath namespaces:(NSDictionary*)spaces{
    GDataXMLNode *node=[self getSingleNode:xpath namespaces:spaces];
    if (node) {
        return node.stringValue;
    }
    return nil;
}
-(NSArray*)selectNodeValues:(NSString*)xpath{
    return [self selectNodeValues:xpath namespaces:nil];
}
-(NSArray*)selectNodeValues:(NSString*)xpath namespaces:(NSDictionary*)spaces{
    if (self.document) {
        NSMutableArray *array=[NSMutableArray array];
        GDataXMLElement* rootNode = [self.document rootElement];
        NSArray *childs;
        if (spaces) {
            childs=[rootNode nodesForXPath:xpath namespaces:spaces error:nil];
        }else{
            childs=[rootNode nodesForXPath:xpath error:nil];
        }
        for (GDataXMLNode *item in childs){
            [array addObject:item.stringValue];
        }
        return array;
    }
    return nil;
}
-(NSArray*)childNodesToObject:(Class)cls{
    if (self.document) {
        GDataXMLElement *root=[self.document rootElement];
        NSArray *childs=[root children];
        NSMutableArray *result=[NSMutableArray array];
        for (GDataXMLNode *item in childs) {
            [result addObject:[self nodeToObject:item forObject:cls]];
        }
        return result;
    }
    return nil;
}
-(NSArray*)childNodesToArray{
    if (self.document) {
        GDataXMLElement *root=[self.document rootElement];
        NSArray *childs=[root children];
        NSMutableArray *result=[NSMutableArray array];
        for (GDataXMLNode *item in childs) {
            [result addObject:[self childsNodeToDictionary:item]];
        }
        return result;
    }
    return nil;
}
#pragma mark -
#pragma mark 私有方法
-(XmlNode*)xmlStringToXmlNode{
    if (self.document) {
        GDataXMLElement* rootNode = [self.document rootElement];
        XmlNode *parent=[[[XmlNode alloc] init] autorelease];
        parent.Name=rootNode.name;
        parent.Value=rootNode.stringValue;
        parent.InnerText=rootNode.stringValue;
        parent.InnerXml=[self getInnerXml:rootNode];
        parent.OuterXml=rootNode.XMLString;
        parent.Attributes=[self getNodeAttributes:rootNode];
        NSMutableArray *xmlNodeChilds=[NSMutableArray array];
        NSArray *rootChilds=[rootNode children];
        for (GDataXMLNode *node in rootChilds) {
            XmlNode *item=[[[XmlNode alloc] init] autorelease];
            item.Attributes=[self getNodeAttributes:node];
            item.Name=node.name;
            item.Value=node.stringValue;
            item.InnerText=node.stringValue;
            item.OuterXml=node.XMLString;
            item.InnerXml=[self getInnerXml:node];
            item.ParentNode=parent;
            if ([node childCount]>0) {
                item.ChildNodes=[self getChildNodes:node parent:item];
            }
            [xmlNodeChilds addObject:item];
        }
        if ([xmlNodeChilds count]>1) {
            for (int i=0;i<[xmlNodeChilds count];i++) {
                XmlNode *nodeItem=(XmlNode*)[xmlNodeChilds objectAtIndex:i];
                if (i-1>=0&&[xmlNodeChilds objectAtIndex:i-1]!=nil) {
                    nodeItem.PreviousSibling=[xmlNodeChilds objectAtIndex:i-1];
                }
                if (i+1<[xmlNodeChilds count]&&[xmlNodeChilds objectAtIndex:i+1]!=nil) {
                    nodeItem.NextSibling=[xmlNodeChilds objectAtIndex:i+1];
                }
            }

        }
        
        parent.ChildNodes=xmlNodeChilds;
        return parent;
    }
    return nil;
}
-(NSArray*)getChildNodes:(GDataXMLNode*)parentNode parent:(XmlNode*)parent{
    NSMutableArray *arr=[NSMutableArray array];
    NSArray *childs=[parentNode children];
    for(GDataXMLNode *item in childs){
        XmlNode *entity=[[[XmlNode alloc] init] autorelease];
        entity.Name=item.name;
        entity.Value=item.stringValue;
        entity.InnerText=item.stringValue;
        entity.InnerXml=[self getInnerXml:item];
        entity.OuterXml=item.XMLString;
        entity.Attributes=[self getNodeAttributes:item];
        entity.ParentNode=parent;
        if ([item childCount]>0) {
            entity.ChildNodes=[self getChildNodes:item parent:entity];
        }
        [arr addObject:entity];
    }
    if ([arr count]>1) {
        for (int i=0;i<[arr count];i++) {
            XmlNode *nodeItem=(XmlNode*)[arr objectAtIndex:i];
            if (i-1>=0&&[arr objectAtIndex:i-1]!=nil) {
                nodeItem.PreviousSibling=[arr objectAtIndex:i-1];
            }
            if (i+1<[arr count]&&[arr objectAtIndex:i+1]!=nil) {
                nodeItem.NextSibling=[arr objectAtIndex:i+1];
            }
        }

    }
        return arr;
}
/***
-(XmlNode*)searchNode:(XmlNode*)node nodeName:(NSString*)nodeName{
    if ([node.Name isEqualToString:nodeName]) {
        return node;
    }else{
        if (node.HasChildNodes) {
            for (XmlNode *item  in node.ChildNodes) {
                return [self searchNode:item nodeName:nodeName];
            }
        }
    }
    return nil;
}
 ***/
-(NSDictionary*)getNodeAttributes:(GDataXMLNode*)node{
    if (node) {
        GDataXMLElement *element=(GDataXMLElement*)node;
        if (!element||![element respondsToSelector:@selector(attributes)]) {
            return nil;
        }
        NSArray *arr=element.attributes;
        if([arr count]>0){
            NSMutableDictionary *dic=[NSMutableDictionary dictionary];
            for (GDataXMLNode *item  in arr) {
                [dic setValue:[item stringValue] forKey:item.name];
            }
            return dic;
        }
    }
    return nil;
}
-(NSString*)getInnerXml:(GDataXMLNode*)node{
    if (node) {
        NSMutableString *xml=[NSMutableString stringWithFormat:@""];
        NSArray *rootChilds=[node children];
        for (GDataXMLNode *item in rootChilds) {
            [xml appendString:item.XMLString];
        }
        return [NSString stringWithFormat:@"%@",xml];
    }
    return @"";
}
-(NSMutableDictionary*)childsNodeToDictionary:(GDataXMLNode*)node{
    NSMutableDictionary *dic=[NSMutableDictionary dictionary];
    NSArray *childs=[node children];
    for (GDataXMLNode *item in childs) {
        [dic setValue:[item stringValue] forKey:item.name];
    }
    return dic;
}
-(id)childsNodeToObject:(GDataXMLNode*)node forObject:(Class)cls{
    id obj = [[cls alloc] init];
    NSArray *childs=[node children];
    for (GDataXMLNode *item in childs){
        SEL sel=NSSelectorFromString(item.name);
        if ([obj respondsToSelector:sel]) {
            [obj setValue:[item stringValue] forKey:item.name];
        }
    }
    return [obj autorelease];
}
-(GDataXMLDocument*)xmlDocumentObject:(id)data{
    NSError *error=nil;
    GDataXMLDocument *document=nil;
    if ([data isKindOfClass:[NSString class]]) {
        document=[[GDataXMLDocument alloc] initWithXMLString:data options:0 error:&error];
    }
    else if([data isKindOfClass:[NSData class]]){
            document=[[GDataXMLDocument alloc] initWithData:data options:0 error:&error];
    }else{

    }
    if (error||document==nil) {
        return nil;
    }
    //[document setCharacterEncoding:@"uft-8"];
    return [document autorelease];
}
-(GDataXMLNode*)getSingleNode:(NSString*)xpath{
    return [self getSingleNode:xpath namespaces:nil];
}
-(GDataXMLNode*)getSingleNode:(NSString*)xpath namespaces:(NSDictionary*)spaces{
    if (self.document) {
        GDataXMLElement* rootNode = [self.document rootElement];
        NSArray *childs;
        if (spaces) {
            childs=[rootNode nodesForXPath:xpath namespaces:spaces error:nil];
        }else{
            childs=[rootNode nodesForXPath:xpath error:nil];
        }
        if (childs&&[childs count]>0) {
            GDataXMLNode *node=(GDataXMLNode*)[childs objectAtIndex:0];
            return node;
        }
    }
    return nil;
}
@end
