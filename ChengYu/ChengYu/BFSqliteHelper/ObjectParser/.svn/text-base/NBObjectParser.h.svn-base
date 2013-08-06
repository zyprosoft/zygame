//
//  NBObjectParser.h
//  WeiBo
//
//  Created by liudi on 6/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OTRuntime.h"    //better to import [#import <objc/objc-runtime.h>]
#import "NBObjectInfo.h"

#define NoValue              @"No_Value"


@interface NBObjectParser : NSObject{
    
    
}
//将任何一个对象解析为键值对的形式存放在字典中
+(NSMutableDictionary *) decodeObject:(id)obj 
                         addValueType:(BOOL)isAddValueType
                             clearNil:(BOOL)isClearNil;

//奖任何一个包含类classname属性的键值对的字典，解析成任何一个给定类名的实例
+(id)encodeObejct:(NSDictionary *)dic         //包含指定类名的属性的键值对
     forClassName:(NSString *)className;      //类名

//将一个对象对应的属性和值映射到此对象上
+(id)setObject:(id)obj 
    properties:(NSArray *)properties 
    withValues:(NSArray *)values;
@end
