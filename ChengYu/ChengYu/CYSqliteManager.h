//
//  CYSqliteManager.h
//  ChengYu
//
//  Created by ZYVincent on 13-6-20.
//  QQ群:219357847 个人QQ:1003081775
//  github:https://github.com/zyprosoft
//  Copyright (c) 2013年 ZYVincent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CYWord.h"
#import "Sqlite3Helper.h"

@interface CYSqliteManager : NSObject
{
    NSMutableArray *tempArray;//use for check
    
    NSMutableArray *tempList;
    
    sqlite3 *wordDB;
}

+ (CYSqliteManager*)shareManager;

- (NSInteger)wordIdByVaule:(NSString*)value;
- (NSDictionary*)wordById:(NSNumber *)wId;

- (void)insertNewWords:(NSString *)word;

- (void)insertNewWordList:(NSString*)wordList;

- (NSArray*)getPagesWordListByRandom;


@end
