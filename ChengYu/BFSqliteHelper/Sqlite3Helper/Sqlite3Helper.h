//
//  DataBaseHelper.h
//  SharePreference
//
//  Created by liudi on 5/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "sqlite3.h"
#import "DataBaseUtils.h"


@interface Sqlite3Helper : NSObject{

  
    
}
//初始化锁对象
+(void)initLockObject;

//打开数据库
+(sqlite3 *)open:(NSString *)dataBasePath; //数据库文件目录

//关闭数据库
+(BOOL)close:(sqlite3 *)dataBase;  //要关闭的数据库

//测试一张表是否存在
+(BOOL)tableIsExist:(sqlite3 *)dataBase   //数据库引用
           forTable:(NSString *)tableName;//表名
//创建表
+(BOOL)createTable:(sqlite3 *)dataBase    //数据库引用
            forSQL:(NSString *)sql;      //标准sqlite3 语句


//插入数据到指定数据库的指定表中，如果key相同，则替换原来的数据
+(BOOL)insertOrReplace:(sqlite3 *)dataBase    //数据库引用
          forTableName:(NSString *)tableName  //表名
               columns:(NSArray *)keys        //插入数据的行
             forValues:(NSArray *)values      //插入数据对应行的值
             valueType:(NSArray *)valueType;  //插入数据对应行的值的数据类型

//在指定的数据库表中查询指定的数据
+(NSArray *) search:(sqlite3 *)dataBase         //数据库引用
       forTableName:(NSString *)tableName       //表名
         selections:(NSArray *)sections         //需要返回的行
              where:(NSArray *)where            //查询条件（where），可以无nil
             values:(NSArray *)values           //where中对应的值，当where为nil时，此参数无效
          valueType:(NSArray *)valueType        //where中对应的值的数据类型，当where为nil时，此参数无效
    selectValueType:(NSArray *)selectValueType  //需要返回的行的数据类型
            orderBy:(NSString *)order;          //排列方式

//查询指定行数得结果
+(NSArray *) search:(sqlite3 *)dataBase         //数据库引用
       forTableName:(NSString *)tableName       //表名
         selections:(NSArray *)sections         //需要返回的行
              where:(NSArray *)where            //查询条件（where），可以无nil
             values:(NSArray *)values           //where中对应的值，当where为nil时，此参数无效
          valueType:(NSArray *)valueType        //where中对应的值的数据类型，当where为nil时，此参数无效
    selectValueType:(NSArray *)selectValueType  //需要返回的行的数据类型
            orderBy:(NSString *)order           //排列方式
          withCount:(NSInteger)count            //指定条数     
     withStartIndex:(NSInteger)sIndex;          //从哪个位置开始返回    

//更新指定数据库的某条记录
+(BOOL)update:(sqlite3 *)dataBase              //数据库引用
 forTableName:(NSString *)tableName            //表名
      columns:(NSArray *)columns               //更新的行
 columnValues:(NSArray *)columnValues          //更新的行对应的值
columnValueType:(NSArray *)columnValueTyps     //更新的行对应的值的数据类型
        where:(NSArray *)where                 //查询条件（where），可以无nil
 whereValues:(NSArray *)whereValues            //where中对应的值，当where为nil时，此参数无效
whereValueTypes:(NSArray *)whereValueTypes;    //where中对应的值的数据类型，当where为nil时，此参数无效


//删除指定数据库表中的某一条数据
+(BOOL)deleteItemFromDataBase:(sqlite3 *)dataBase         //数据库引用
                 forTableName:(NSString *)tableName       //表名
                        where:(NSArray * )where           //查询条件（where），可以无nil
                  whereValues:(NSArray *)whereValues      //where中对应的值，当where为nil时，此参数无效
              whereValueTypes:(NSArray *)whereValueTypes; //where中对应的值的数据类型，当where为nil时，此参数无效

//在指定的数据库中执行标准的sqlite3语句
+(BOOL)excuteSQL:(sqlite3 *)dataBase         //数据库引用
          forSql:(NSString *)sql;            //标准sqlite3 语句


@end
