//
//  DataBaseUtils.m
//  SharePreference
//
//  Created by liudi on 5/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DataBaseUtils.h"

@implementation DataBaseUtils

+(BOOL)isNil:(id)obj{
    
    return obj==nil?YES:NO;
}

+(void)makeSql:(NSMutableString *)sql 
         atKey:(NSString *)key
        byType:(int)type 
    fromObject:(id)obj{

    switch (type) {
        case INT:
            [sql appendFormat:@" %@=%d",key,[obj intValue]];
            break;
        case STRING:
            [sql appendFormat:@" %@='%@'",key,obj];
            break;
        case DOUBLE:
            [sql appendFormat:@" %@=%g",key,[obj doubleValue]];
            break;
        default:
            break;
    }
}

+(void)makeSql:(NSMutableString *)sql 
         atKey:(NSString *)key{
    
    [sql appendFormat:@" %@=?",key];
}

+(void)makeSqlite3Stmt:(sqlite3_stmt * )stmt 
             forValues:(NSArray *)values
             valueType:(NSArray *)valueType{
    
    int count = values==nil?0:[values count];
    for (int i=0; i<count; i++) {
        int type = [[valueType objectAtIndex:i] intValue];
        switch (type) {
            case INT:
                sqlite3_bind_int(stmt, i+1, [[values objectAtIndex:i] intValue]);
                break;
            case STRING:
                sqlite3_bind_text(stmt, i+1, [[values objectAtIndex:i] UTF8String], -1, NULL);
                break;
            case DOUBLE:
                sqlite3_bind_double(stmt, i+1, [[values objectAtIndex:i] doubleValue]);
                break;
            default:
                break;
        }
    }
}

@end
