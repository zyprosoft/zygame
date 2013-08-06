//
//  NBObjectParser.m
//  WeiBo
//
//  Created by liudi on 6/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NBObjectParser.h"

@interface NBObjectParser ()

+(NSArray *) getPropertyForClass:(Class)class;

+(DataType) getpropertyDataType:(id)property;

@end


@implementation NBObjectParser


+(NSArray *) getPropertyForClass:(Class)class{
    
    u_int count;   
    
    objc_property_t *properties  = class_copyPropertyList(class, &count);  
    
    NSMutableArray *propertyArray = [NSMutableArray arrayWithCapacity:count];  
    
    
    for (int i = 0; i < count ; i++)   
    {   
        const char* propertyName = property_getName(properties[i]); 
        
        [propertyArray addObject: [NSString  stringWithUTF8String: propertyName]];  
    }   
    
    return propertyArray;
}
+(DataType) getpropertyDataType:(id)property{
    
    if (!property) {
        return unSupportType;
    }

    if ([property isKindOfClass:[NSString class] ]) {
            
        return stringType;
    }
    else if ([property isKindOfClass: [NSNumber class]]) {
            
        NSNumber * number = (NSNumber *)property;
            
        if(strcmp([number objCType], @encode(float))==0){
                
            return floatType;
                
        }
        else if(strcmp([number objCType], @encode(int))==0){
                
            return intType;
        }
            
    }

    return unSupportType;
}

+(NSMutableDictionary *) decodeObject:(id)obj 
                         addValueType:(BOOL)isAddValueType
                             clearNil:(BOOL)isClearNil{
    
    if (obj == nil) {
        
        return nil;
    }
    
    NSMutableDictionary * dic = [[NSMutableDictionary alloc] init];
    
    NSArray * propertyArray = [[self class] getPropertyForClass:[obj class]];
    
    for (NSString * key in propertyArray) {
        
        id value = [obj valueForKey:key];
        //如果某一个属性没有赋值，默认按nsstring处理
        if (!value && !isClearNil) {
            
            value = NoValue;
            
        }
        if (!value) {
            
            continue;
            
        }
        if (isAddValueType) {

            NBObjectInfo * objectInfo = [[NBObjectInfo alloc] init];
            
            objectInfo.value = value;
            
            objectInfo.valueType = [[self class] getpropertyDataType:value];
            
            [dic setValue: objectInfo forKey:key];
                        
        }
        else {
            
            [dic setValue: value forKey:key];
        }
        
    }
    
    return dic;
    
}

+(id)encodeObejct:(NSDictionary *)dic
     forClassName:(NSString *)className{
    
    Class class = NSClassFromString(className);
    
    id obj = [[class alloc] init];
    
    if (dic ==nil) {
        
        return obj;
    }
    
    NSArray * propertyArray = [[self class] getPropertyForClass:class];
    
    for (NSString * key in [dic allKeys]) {
        
        if ([propertyArray containsObject:key]) {
            
            [obj setValue:[dic objectForKey:key]  forKey:key];
        }
    }
    return obj;
}

+(id)setObject:(id)obj 
    properties:(NSArray *)properties 
    withValues:(NSArray *)values{

    NSArray * propertyArray = [[self class] getPropertyForClass:[obj class]];
    
    int i =0;
    
    for (NSString * key in properties) {
        
        if ([propertyArray containsObject:key]) {
            
            [obj setValue:[values objectAtIndex:i] forKey:key];
        }
        
        i++;
    }

    return obj;
}

@end
