//
//  CYSqliteManager.m
//  ChengYu
//
//  Created by barfoo2 on 13-6-20.
//  Copyright (c) 2013年 ZYVincent. All rights reserved.
//

#import "CYSqliteManager.h"

static CYSqliteManager *_cyInstance = nil;

@implementation CYSqliteManager

- (id)init
{
    if (self = [super init]) {
        
        tempArray = [[NSMutableArray alloc]init];
        
        NSString *wordDataBase = @"wordDataBase.sqlite";
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *dbPath = [[paths objectAtIndex:0]stringByAppendingPathComponent:wordDataBase];
        
       wordDB =  [Sqlite3Helper open:dbPath];
        
        //create table
        [self createWordsTable];
        
        [self createWordsList];
    }
    return self;
}

+ (CYSqliteManager*)shareManager
{
    @synchronized(self){
        
        if (!_cyInstance ) {
            _cyInstance = [[self alloc]init];
        }
    }
    return _cyInstance;
}

- (void)dealloc
{
    
    [tempArray release];
    [super dealloc];
}

- (NSArray*)wordsToVaule:(CYWord*)word
{
    return [NSArray arrayWithObject:word.w_value];
}

- (void)createWordsTable
{
    NSString *sql = @"CREATE TABLE words (\"w_id\" integer PRIMARY KEY AUTOINCREMENT,\"w_value\" text NOT NULL)";
    
    if (![Sqlite3Helper tableIsExist:wordDB forTable:@"words"]) {
        [Sqlite3Helper createTable:wordDB forSQL:sql];
    }
    
}

- (void)createWordsList
{
    NSString *sql = @"CREATE TABLE words_list (\"w_id\" integer PRIMARY KEY AUTOINCREMENT,\"w_value\" text NOT NULL)";

    if (![Sqlite3Helper tableIsExist:wordDB forTable:@"words_list"]) {
        [Sqlite3Helper createTable:wordDB forSQL:sql];
    }
}

- (void)insertNewWords:(NSString *)word
{
    
    if ([tempArray containsObject:word]) {
        
    }else{
        [tempArray addObject:word];
        
        //insert to DB
        [Sqlite3Helper insertOrReplace:wordDB forTableName:@"words" columns:[NSArray arrayWithObject:@"w_value"] forValues:[NSArray arrayWithObject:word] valueType:[NSArray arrayWithObject:STRINGNUMBER]];
        
    }
    
}

- (NSInteger)wordIdByVaule:(NSString *)value
{
    NSArray *resultArr = [Sqlite3Helper search:wordDB forTableName:@"words" selections:[NSArray arrayWithObject:@"w_id"] where:[NSArray arrayWithObject:@"w_value"] values:[NSArray arrayWithObject:value] valueType:[NSArray arrayWithObject:STRINGNUMBER] selectValueType:[NSArray arrayWithObject:INTNUMBER] orderBy:nil];
    
    NSDictionary *sNumber = [resultArr objectAtIndex:0];
    
    return [[sNumber objectForKey:@"w_id"] intValue];
    
}

- (NSDictionary*)wordById:(NSNumber *)wId
{
    NSArray *resultArr = [Sqlite3Helper search:wordDB forTableName:@"words" selections:[NSArray arrayWithObjects:@"w_id",@"w_value" ,nil] where:[NSArray arrayWithObject:@"w_id"] values:[NSArray arrayWithObject:wId] valueType:[NSArray arrayWithObject:INTNUMBER] selectValueType:[NSArray arrayWithObjects:INTNUMBER,STRINGNUMBER,nil] orderBy:nil];
    
    NSDictionary *sNumber = [resultArr objectAtIndex:0];
    
    return sNumber;
}


- (void)insertNewWordList:(NSString *)wordList
{
    if (![tempList containsObject:wordList]) {
        
        [tempList addObject:wordList];
        
        //inser to DB
        [Sqlite3Helper insertOrReplace:wordDB forTableName:@"words_list" columns:[NSArray arrayWithObject:@"w_value"] forValues:[NSArray arrayWithObject:wordList] valueType:[NSArray arrayWithObject:STRINGNUMBER]];
        
    }
    
}

- (NSArray*)getPagesWordListByRandom
{
    
    int endIndex = arc4random()%329+0;
    
    NSMutableArray *textArr = [NSMutableArray array];
    
    NSArray *randResultArr = [Sqlite3Helper search:wordDB forTableName:@"words_list" selections:[NSArray arrayWithObject:@"w_value"] where:nil values:nil valueType:nil selectValueType:[NSArray arrayWithObject:STRINGNUMBER] orderBy:nil withCount:20 withStartIndex:endIndex];
    
    for (NSDictionary *item in randResultArr) {
        
        [textArr addObject:[item objectForKey:@"w_value"]];
    }
    
    return textArr;
    
}

@end
