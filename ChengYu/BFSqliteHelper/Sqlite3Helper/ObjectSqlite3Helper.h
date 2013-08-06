//
//  ObjectSqlite3Helper.h
//  YXPiOSClient
//
//  Created by liudi on 6/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
/*
 注意：
 这个类封转了对象到关系的映射，可以直接将一个对象插入关系数据库，或以一个对象作为参数到数据库中搜索。
 
 特别注意：
 一定要保证您的数据库字段和对象属性的名称一致。
 */

#import <Foundation/Foundation.h>
#import "Sqlite3Helper.h"
#import "NBObjectParser.h"

@interface ObjectSqlite3Helper : NSObject{


    
}

//插入或替换任何一个对象到指定数据库中。（保证需要插入的字段不为nil,与数据库中key对应的属性不能为空，并且必须保证数据库中的字段和对象的属性一致）
+(BOOL)insertOrReplaceObject:(id)obj                  //要插入的对象
                  toDataBase:(sqlite3 *)database      //待插入的数据库
                     inTable:(NSString *)tableName;   //待插入的表

//在指定的数据库表中搜索任何一个对象。
+(NSArray *)searchObject:(id)obj                      //要查询的对象
       toDataBase:(sqlite3 *)database                 //待查询的数据库
          inTable:(NSString *)tableName               //待查询的表
       selections:(NSArray *)sections                 //待选择的字段
  selectValueType:(NSArray *)selectValueType;         //待选择字段的数据类型（只支持DataBaseUtil.h中定义的数据类型）

//删除指定数据库表中的任何一个对象
+(BOOL)deleteObject:(id)obj                           //要删除的对象
      fromeDataBase:(sqlite3 * )database              //待删除对象所在的数据库
            atTable:(NSString *)tableName;            //待删除对象所在的表

//更新指定数据库中的满足一定条件的对象为新对象  【未实现】
+(BOOL)updateObject:(id)oldObj                        //要更新的对象数据
         withObject:(id)newObj                        //更新后的新对象数据
       fromDatabase:(sqlite3 *)database               //待更新的数据库
            inTable:(NSString *)tableName;            //待更新数据库表
@end
