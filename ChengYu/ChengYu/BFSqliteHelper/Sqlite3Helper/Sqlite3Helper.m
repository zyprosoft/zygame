//
//  DataBaseHelper.m
//  SharePreference
//
//  Created by liudi on 5/29/12.
//  QQ群:219357847 个人QQ:1003081775
//  github:https://github.com/zyprosoft
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Sqlite3Helper.h"

@implementation Sqlite3Helper
static id obj;
+(void)initLockObject{
    
    if (!obj) {
        
        obj = [[NSObject alloc] init];
    }
}

+(sqlite3 *)open:(NSString *)dataBasePath{
    
    if ([DataBaseUtils isNil:obj] ) {
        
        [Sqlite3Helper initLockObject];
    }
    
    @synchronized(obj){
        
        
        const char * cDataBasePath = [dataBasePath UTF8String];
        sqlite3 * sqlite3 ;
        if(sqlite3_open(cDataBasePath, &sqlite3) != SQLITE_OK){
            
            sqlite3_close(sqlite3);
            NSAssert(0, @"Fail To Open DataBase.");
            return nil;
            
        }
        return sqlite3;
        
    }
    
    
}
+(BOOL)close:(sqlite3 *)dataBase{
    
    if ([DataBaseUtils isNil:obj] ) {
        
        [Sqlite3Helper initLockObject];
    }
    
    @synchronized(obj){
        
        return sqlite3_close(dataBase)==SQLITE_OK?YES:NO;
        
    }
}

+(BOOL)tableIsExist:(sqlite3 *)dataBase forTable:(NSString *)tableName{
    
    if ([DataBaseUtils isNil:obj] ) {
        
        [Sqlite3Helper initLockObject];
    }
    
    @synchronized(obj){
        
        NSString * sql = [NSString stringWithFormat:@"%@'%@';",TABLE_IS_EXIST,tableName];
        const char * cSql = [sql UTF8String];
        sqlite3_stmt * stmt;
        if (sqlite3_prepare_v2(dataBase, cSql, -1, &stmt, NULL) == SQLITE_OK) {
            int rowNum = 0;
            while (sqlite3_step(stmt) == SQLITE_ROW ) {
                rowNum ++;
            }
            sqlite3_finalize(stmt);
            return rowNum>0?YES:NO;
        }
        
        NSAssert(0, @"Test Whether Table Exist Fail!");
        return NO;
        
    }
}

+(BOOL)createTable:(sqlite3 *)dataBase forSQL:(NSString *)sql{
    
    if ([DataBaseUtils isNil:obj] ) {
        
        [Sqlite3Helper initLockObject];
    }
    
    @synchronized(obj){
        
        char * errorMes;
        const char * cSql = [sql UTF8String];
        if( sqlite3_exec(dataBase, cSql, NULL, NULL, &errorMes)!= SQLITE_OK){
            
            NSAssert1(0, @"Create Table Fail. \nError Message:%s", errorMes);
            return NO;
        }
        return YES;
        
    }
}

+(BOOL)insertOrReplace:(sqlite3 *)dataBase   //待插入数据库
          forTableName:(NSString *)tableName //待插入数据库表
               columns:(NSArray *)keys //插入的行名
             forValues:(NSArray *)values  //与行对应的值
             valueType:(NSArray *)valueType //与值对应的数据类型
{
    
    if ([DataBaseUtils isNil:obj] ) {
        
        [Sqlite3Helper initLockObject];
    }
    
    @synchronized(obj){
        
        
        NSMutableString * sections = [[NSMutableString alloc] initWithFormat:@"("] ;
        NSMutableString * sectionsValues = [[NSMutableString alloc] initWithFormat:@"("] ;
        int count = keys.count;
        if (count>values.count) {
            NSAssert(0, @"Keys' Length Should Not Longger Than Values'.");
            return NO;
        }
        if (values.count>valueType.count) {
            NSAssert(0, @"Values' Length Should Not Longger Than ValueType's.");
            return NO;
        }
        for (int i =0 ; i<count; i++) {
            [sections appendString:[NSString stringWithFormat:@"%@,",[keys objectAtIndex:i]]];
            [sectionsValues appendString:@"?,"];
        }
        [sections deleteCharactersInRange:NSMakeRange(sections.length-1, 1)];
        [sectionsValues deleteCharactersInRange:NSMakeRange(sectionsValues.length-1, 1)];
        
        [sections appendString:@")"];
        [sectionsValues appendString:@")"];
        NSString * sql = [[NSString alloc] initWithFormat:@"%@ %@ %@ %@ %@;",INSERT_OR_REPLACE,tableName,sections,VALUES,sectionsValues];
        
        const char * cSql = [sql UTF8String];
        
        sqlite3_stmt * stmt;
        
        if( sqlite3_prepare_v2(dataBase, cSql, -1, &stmt, NULL)== SQLITE_OK){
            
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
            if(sqlite3_step(stmt)!= SQLITE_DONE){
                NSAssert(0, @"Insert To Table Fail.");
                return NO;
            }
            sqlite3_finalize(stmt);
            return YES;
            
        }
        return NO;
        
    }
}
+(NSArray *) search:(sqlite3 *)dataBase //查询数据库
       forTableName:(NSString *)tableName //表名
         selections:(NSArray *)sections //查询要返回的行
              where:(NSArray *)where   //查询条件 （无为nil）
             values:(NSArray *)values  //条件对应的值 无为nil）
          valueType:(NSArray *)valueType  //查询对应值的数据类型，
    selectValueType:(NSArray *)selectValueType //返回类容的数据类型，与sections对应
            orderBy:(NSString *)order  //顺序，（标准sql语句）
{
    
    if ([DataBaseUtils isNil:obj] ) {
        
        [Sqlite3Helper initLockObject];
    }
    
    @synchronized(obj){
        
        NSMutableArray * array = [[NSMutableArray alloc] init];
        NSMutableString * sql = [[NSMutableString alloc] init];
        [sql appendFormat:@"%@",SELECT];
        
        for (NSString * sec in sections) {
            [sql appendFormat:@" %@,",sec];
        }
        [sql deleteCharactersInRange:NSMakeRange(sql.length-1, 1)];
        
        [sql appendFormat:@" %@ %@",FROM,tableName];
        
        if (where !=nil) {
    
            int count = where.count;
            if (count>values.count) {
                NSAssert(0, @"Where's Length Should Not Longger Than Values'.");
                return nil;
            }
            if (values.count>valueType.count) {
                NSAssert(0, @"Values's Length Should Not Longger Than ValueType's.");
                return nil;
            }
            [sql appendFormat:@" %@ ",WHERE];
            int index = 0;
            for (NSString * key in where) {
                /* 2012-06-26修改，防止sql注入
                id obj = [values objectAtIndex:index];
                
                int type = [[valueType objectAtIndex:index] intValue];
                [DataBaseUtils makeSql:sql 
                                 atKey:key 
                                byType:type 
                            fromObject:obj];
                */
                [DataBaseUtils makeSql:sql 
                                 atKey:key];
                index ++;
                [sql appendFormat:@" AND "];
            }
            
            [sql deleteCharactersInRange:NSMakeRange(sql.length-4, 4)];
            
        }
        
        if (order !=nil) {
            [sql appendFormat:@" %@",order];
        }
        
        //NSLog(@"search sql=%@",sql);
        const char * cSql = [sql UTF8String];
        sqlite3_stmt * stmt;
        if (sqlite3_prepare_v2(dataBase, cSql, -1, &stmt, NULL)== SQLITE_OK) {
            //2012-6-26修改。绑定参数，可防止sql注入
            [DataBaseUtils makeSqlite3Stmt:stmt forValues:values valueType:valueType];
            
            while (sqlite3_step(stmt)== SQLITE_ROW) {
                NSMutableDictionary * dic = [[NSMutableDictionary alloc] init];
                for (int i =0; i<sections.count; i++) {
                    int type = [[selectValueType objectAtIndex:i] intValue];
                    NSString * key = [sections objectAtIndex:i];
                    switch (type) {
                        case INT:
                            [dic setObject:[NSNumber numberWithInt:sqlite3_column_int(stmt, i)] 
                                    forKey:key];
                            break;
                        case STRING:
                            [dic setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, i)] 
                                    forKey:key];
                            break;
                        case DOUBLE:
                            [dic setObject:[NSNumber numberWithDouble:sqlite3_column_double(stmt, i)] forKey:key];
                            break;
                        default:
                            break;
                    }
                }
                [array addObject:dic];
            }
            sqlite3_finalize(stmt);
            return array;
        }
        return nil;
        
    }
}
//查询指定条数得结果
+ (NSArray *)search:(sqlite3 *)dataBase 
       forTableName:(NSString *)tableName 
         selections:(NSArray *)sections 
              where:(NSArray *)where 
             values:(NSArray *)values 
          valueType:(NSArray *)valueType 
    selectValueType:(NSArray *)selectValueType 
            orderBy:(NSString *)order 
          withCount:(NSInteger)count
          withStartIndex:(NSInteger)sIndex
{
    if ([DataBaseUtils isNil:obj] ) {
        
        [Sqlite3Helper initLockObject];
    }
    
    @synchronized(obj){
        
        NSMutableArray * array = [[NSMutableArray alloc] init];
        NSMutableString * sql = [[NSMutableString alloc] init];
        [sql appendFormat:@"%@",SELECT];
        
        for (NSString * sec in sections) {
            [sql appendFormat:@" %@,",sec];
        }
        [sql deleteCharactersInRange:NSMakeRange(sql.length-1, 1)];
        
        [sql appendFormat:@" %@ %@",FROM,tableName];
        
        if (where !=nil) {
            
            int count = where.count;
            if (count>values.count) {
                NSAssert(0, @"Where's Length Should Not Longger Than Values'.");
                return nil;
            }
            if (values.count>valueType.count) {
                NSAssert(0, @"Values's Length Should Not Longger Than ValueType's.");
                return nil;
            }
            [sql appendFormat:@" %@ ",WHERE];
            int index = 0;
            for (NSString * key in where) {
                /* 2012-06-26修改，防止sql注入
                 id obj = [values objectAtIndex:index];
                 
                 int type = [[valueType objectAtIndex:index] intValue];
                 [DataBaseUtils makeSql:sql 
                 atKey:key 
                 byType:type 
                 fromObject:obj];
                 */
                [DataBaseUtils makeSql:sql 
                                 atKey:key];
                index ++;
                [sql appendFormat:@" AND "];
            }
            
            [sql deleteCharactersInRange:NSMakeRange(sql.length-4, 4)];
            
            [sql appendFormat:@" limit %d offset %d",count,sIndex]; 
            //BFLogObject(sql);
        }
        
        if (order !=nil) {
            [sql appendFormat:@" %@",order];
        }
        
        //NSLog(@"search sql=%@",sql);
        //指定返回行数条件
        [sql appendFormat:@" limit %d offset %d",count,sIndex]; 
        //BFLogObject(sql);
        
        const char * cSql = [sql UTF8String];
        sqlite3_stmt * stmt;
        if (sqlite3_prepare_v2(dataBase, cSql, -1, &stmt, NULL)== SQLITE_OK) {
            //2012-6-26修改。绑定参数，可防止sql注入
            [DataBaseUtils makeSqlite3Stmt:stmt forValues:values valueType:valueType];
            
            while (sqlite3_step(stmt)== SQLITE_ROW) {
                NSMutableDictionary * dic = [[NSMutableDictionary alloc] init];
                for (int i =0; i<sections.count; i++) {
                    int type = [[selectValueType objectAtIndex:i] intValue];
                    NSString * key = [sections objectAtIndex:i];
                    switch (type) {
                        case INT:
                            [dic setObject:[NSNumber numberWithInt:sqlite3_column_int(stmt, i)] 
                                    forKey:key];
                            break;
                        case STRING:
                            [dic setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, i)] 
                                    forKey:key];
                            break;
                        case DOUBLE:
                            [dic setObject:[NSNumber numberWithDouble:sqlite3_column_double(stmt, i)] forKey:key];
                            break;
                        default:
                            break;
                    }
                }
                [array addObject:dic];
            }
            sqlite3_finalize(stmt);
            return array;
        }
        return nil;
        
    }
}
+(BOOL)update:(sqlite3 *)dataBase  //更新的数据库
 forTableName:(NSString *)tableName  //更新的表
      columns:(NSArray *)columns   //更新的行
 columnValues:(NSArray *)columnValues  //更新的行的新值
columnValueType:(NSArray *)columnValueTyps //新值的数据类型
        where:(NSArray *)where     //where部分的行 (可以为nil)
  whereValues:(NSArray *)whereValues  //where部分行对应的值
whereValueTypes:(NSArray *)whereValueTypes //where部分行对应的值的数据类型
{
    if ([DataBaseUtils isNil:obj] ) {
        
        [Sqlite3Helper initLockObject];
    }
    
    @synchronized(obj){
        
        if (columns.count>columnValues.count) {
            NSAssert(0, @"Columns's Length Should Not Longger Than ColumnValues'.");
            return NO;
            
        }
        if (columnValues.count>columnValueTyps.count) {
            NSAssert(0, @"ColumnValues' Length Should Not Longger Than ColumnValueTypes'.");
            return NO;
        }
        if (where!=nil) {
            if (where.count>whereValues.count) {
                NSAssert(0, @"Where's Length Should Not Longger Than WhereValues'.");
                return NO;
                
            }
            if (whereValues.count>whereValueTypes.count) {
                NSAssert(0, @"WhereValues' Length Should Not Longger Than WhereValueTypes'.");
                return NO;
            }
        }
        
        NSMutableString * sql = [[NSMutableString alloc] init];
        [sql appendFormat:@"%@ %@ %@",UPDATE,tableName,SET];
        int index =0;
        for (NSString * key in columns) {
            /*2012-6-26修改，防止sql注入
            id obj = [columnValues objectAtIndex:index];
            
            int type = [[columnValueTyps objectAtIndex:index] intValue];
            [DataBaseUtils makeSql:sql 
                             atKey:key 
                            byType:type 
                        fromObject:obj];
            */
            [DataBaseUtils makeSql:sql 
                             atKey:key];
            
            [sql appendFormat:@","];
            index ++;
        }
        [sql deleteCharactersInRange:NSMakeRange(sql.length-1, 1)];
        
        if (where != nil) {
            [sql appendFormat:@" %@",WHERE];
            
            index = 0;
            for (NSString * key in where) {
                /*2012-6-26修改，防止sql注入
                id obj = [whereValues objectAtIndex:index];
                
                int type = [[whereValueTypes objectAtIndex:index] intValue];
                [DataBaseUtils makeSql:sql 
                                 atKey:key 
                                byType:type 
                            fromObject:obj];
                */
                [DataBaseUtils makeSql:sql 
                                 atKey:key];
                
                [sql appendFormat:@" AND "];
                index ++;
                
            }
            [sql deleteCharactersInRange:NSMakeRange(sql.length-4, 4)];
        }
        NSLog(@"update sql=%@",sql);
        
        const char * cSql = [sql UTF8String];
        sqlite3_stmt * stmt;
        if (sqlite3_prepare_v2(dataBase, cSql, -1, &stmt, NULL)== SQLITE_OK){
            //2012-6-26修改，绑定参数，可防止sql注入
            NSMutableArray * values = [[NSMutableArray alloc] init];
            [values addObjectsFromArray:columnValues];
            [values addObjectsFromArray:whereValues];
            NSMutableArray * valueTypes = [[NSMutableArray alloc] init];
            [valueTypes addObjectsFromArray:columnValueTyps];
            [valueTypes addObjectsFromArray:whereValueTypes];
            [DataBaseUtils makeSqlite3Stmt:stmt forValues:values valueType:valueTypes];
            
            if(sqlite3_step(stmt)==SQLITE_DONE){
                
                return YES;
            }
            else {
                NSLog(@"Updata Fail!");
                return NO;
            }
        }
        sqlite3_finalize(stmt);
        NSLog(@"Updata Fail!");   
        return NO;    
        
    }
}

+(BOOL)deleteItemFromDataBase:(sqlite3 *)dataBase //要删除数据的数据库
                 forTableName:(NSString *)tableName  //要删除数据的表
                        where:(NSArray * )where  //删除的where条件
                  whereValues:(NSArray *)whereValues //where条件对应的值
              whereValueTypes:(NSArray *)whereValueTypes //where条件对应的值的数据类型

{
    
    if ([DataBaseUtils isNil:obj] ) {
        
        [Sqlite3Helper initLockObject];
    }
    
    @synchronized(obj){
        
        NSMutableString * sql = [[NSMutableString alloc] init];
        [sql appendFormat:@"%@ %@ %@",DELETE,FROM,tableName];
        if (where!=nil) {
            if (where.count>whereValues.count) {
                NSAssert(0, @"Where's Length Should Not Longger Than WhereValues'.");
                return NO;
                
            }
            if (whereValues.count>whereValueTypes.count) {
                NSAssert(0, @"WhereValues' Length Should Not Longger Than WhereValueTypes'.");
                return NO;
            }
            
            [sql appendFormat:@" %@",WHERE];
            int index = 0;
            for (NSString * key in where) {
                /*2012-6-26修改，防止sql注入
                 id obj = [whereValues objectAtIndex:index];
                 
                 int type = [[whereValueTypes objectAtIndex:index] intValue];
                 [DataBaseUtils makeSql:sql 
                 atKey:key 
                 byType:type 
                 fromObject:obj];
                 */
                [DataBaseUtils makeSql:sql 
                                 atKey:key];
                [sql appendFormat:@" AND "];
                index ++;
                
            }
            [sql deleteCharactersInRange:NSMakeRange(sql.length-4, 4)];
            
        }
        
        NSLog(@"delete sql=%@",sql);
        
        const char * cSql = [sql UTF8String];
        sqlite3_stmt * stmt;
        if(sqlite3_prepare_v2(dataBase, cSql, -1, &stmt, NULL)==SQLITE_OK){
            //2012-6-26修改。绑定参数，可防止sql注入
            [DataBaseUtils makeSqlite3Stmt:stmt forValues:whereValues valueType:whereValueTypes];
            
            if(sqlite3_step(stmt)==SQLITE_DONE){
                
                return YES;
            }
            else {
                NSLog(@"Delete Fail!");
                return NO;
            }
        }
        sqlite3_finalize(stmt);
        NSLog(@"Delete Fail!");
        return NO;
        
    }
}
+(BOOL)excuteSQL:(sqlite3 *)dataBase 
          forSql:(NSString *)sql{
    
    if ([DataBaseUtils isNil:obj] ) {
        
        [Sqlite3Helper initLockObject];
    }
    
    @synchronized(obj){
        
        const char * cSql = [sql UTF8String];
        char * erroMsg;
        if (sqlite3_exec(dataBase, cSql, NULL, NULL, &erroMsg) !=SQLITE_OK) {
            
            NSLog(@"Excute SQL Command Fail! Reason:%s ",erroMsg);
            return NO;
        }
        return YES;
        
    }
    
}
@end
