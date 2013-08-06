//
//  ObjectSqlite3Helper.m
//  YXPiOSClient
//
//  Created by liudi on 6/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ObjectSqlite3Helper.h"

@implementation ObjectSqlite3Helper


+(BOOL)insertOrReplaceObject:(id)obj 
                  toDataBase:(sqlite3 *)database 
                     inTable:(NSString *)tableName{

    NSDictionary * dic = [NBObjectParser decodeObject:obj addValueType:YES clearNil:YES];
    NSArray * keys = [dic allKeys];
    NSArray * values = [dic allValues];
    
    NSMutableArray * insertValues = [[NSMutableArray alloc] init];
    
    NSMutableArray * insertValuesType = [[NSMutableArray alloc] init];

    
    
    for (NBObjectInfo * objectInfo in values) {
        
        [insertValues addObject:objectInfo.value];
        
        [insertValuesType addObject: [NSNumber numberWithInt:(objectInfo.valueType)]];     
    }
    
    return [Sqlite3Helper insertOrReplace:database 
                             forTableName:tableName 
                                  columns:keys 
                                forValues:insertValues 
                                valueType:insertValuesType];
}

+(NSArray *)searchObject:(id)obj 
       toDataBase:(sqlite3 *)database 
          inTable:(NSString *)tableName
       selections:(NSArray *)sections
  selectValueType:(NSArray *)selectValueType{

    NSDictionary * dic = [NBObjectParser decodeObject:obj addValueType:YES clearNil:YES];
    
    NSArray * keys = [dic allKeys];
    
    NSArray * values = [dic allValues];
    
    NSMutableArray * whereValue = [[NSMutableArray alloc] init];
    
    NSMutableArray * whereValueType = [[NSMutableArray alloc] init];
    
    for (NBObjectInfo * objectInfo in values) {
        
        [whereValue addObject:objectInfo.value];
        
        [whereValueType addObject: [NSNumber numberWithInt:(objectInfo.valueType)]];     
    }

    if (keys.count<1) {
        
        keys = nil;
        
    }
    
    NSArray * arry = [Sqlite3Helper search:database 
                              forTableName:tableName 
                                selections:sections 
                                     where:keys 
                                    values:whereValue
                                 valueType:whereValueType 
                           selectValueType:selectValueType 
                                   orderBy:ORDER_BY_ROW];
    int size = arry.count;
    
    NSMutableArray * result = [[NSMutableArray alloc] initWithCapacity:size];
    
    for (int i=0; i<size; i++) {
        
        id newObj = [obj copy];
    
        NSArray * propertyValue = [[arry objectAtIndex:i] allValues];
        
        [NBObjectParser setObject:newObj properties:sections withValues:propertyValue];
        
        [result addObject:newObj];
    }
    
    
    return result;
}

+(BOOL)deleteObject:(id)obj 
      fromeDataBase:(sqlite3 * )database 
            atTable:(NSString *)tableName{

    NSDictionary * dic = [NBObjectParser decodeObject:obj addValueType:YES clearNil:YES];
    
    NSArray * where = [dic allKeys];
    
    NSArray * values = [dic allValues];
    
    NSMutableArray * whereValue = [[NSMutableArray alloc] init];
    
    NSMutableArray * whereValueType = [[NSMutableArray alloc] init];
    
    for (NBObjectInfo * objectInfo in values) {
        
        [whereValue addObject:objectInfo.value];
        
        [whereValueType addObject: [NSNumber numberWithInt:(objectInfo.valueType)]];     
    }
    
    return [Sqlite3Helper deleteItemFromDataBase:database 
                                    forTableName:tableName 
                                           where:where 
                                     whereValues:whereValue 
                                 whereValueTypes:whereValueType];
    
}

//更新指定数据库中的满足一定条件的对象为新对象  【未实现】
+(BOOL)updateObject:(id)oldObj                        //要更新的对象数据
         withObject:(id)newObj                        //更新后的新对象数据
       fromDatabase:(sqlite3 *)database               //待更新的数据库
            inTable:(NSString *)tableName;            //待更新数据库表
{
    return NO;
    //#warning undefined.
}

@end
