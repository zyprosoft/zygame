//
//  DataBaseUtils.h
//  SharePreference
//
//  Created by liudi on 5/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "sqlite3.h"
//---------------------------------------------------------------------------------------------

#define INSERT                  @"INSERT"

#define INSERT_OR_REPLACE       @"INSERT OR REPLACE INTO"

#define TABLE_IS_EXIST          @"SELECT * FROM sqlite_master WHERE type ='table' AND name ="

#define SELECT                  @"SELECT"

#define FROM                    @"FROM"

#define VALUES                  @"VALUES"

#define WHERE                   @"WHERE"

#define UPDATE                  @"UPDATE"

#define SET                     @"SET"

#define DELETE                  @"DELETE"

#define ORDER_BY_ROW            @"ORDER BY ROW"

//----------------------------------------------------------------------------------------------

#define  INT                    0
#define  FLOAT                  1
#define  DOUBLE                 2
#define  STRING                 3

#define INTNUMBER       [NSNumber numberWithInt:0]
#define FLOATNUMBER       [NSNumber numberWithInt:1]
#define DOUBLENUMBER       [NSNumber numberWithInt:2]
#define STRINGNUMBER       [NSNumber numberWithInt:3]

//typedef enum{
//    
//    INT           = 0,
//    FLOAT         = 1,
//    DOUBLE        = 2,
//    STRING        = 3,
//    unSupportType = 4
//    
//}DataType;
//----------------------------------------------------------------------------------------------

#define INT_KEY                 @"int"
#define FLOAT_KEY               @"float"
#define DOUBLE_KEY              @"double"
#define STRING_KEY              @"string"


//---------------------------------------------------------------------------------------------


@interface DataBaseUtils : NSObject{

}
+(BOOL)isNil:(id)obj;

+(void)makeSql:(NSMutableString *)sql 
         atKey:(NSString *)key
        byType:(int)type 
    fromObject:(id)obj;

+(void)makeSql:(NSMutableString *)sql 
         atKey:(NSString *)key;

+(void)makeSqlite3Stmt:(sqlite3_stmt * )stmt 
             forValues:(NSArray *)values
             valueType:(NSArray *)valueType;
@end
