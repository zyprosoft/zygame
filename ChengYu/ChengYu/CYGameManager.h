//
//  CYGameManager.h
//  ChengYu
//
//  Created by barfoo2 on 13-6-17.
//  Copyright (c) 2013年 ZYVincent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CYWord.h"
#import "CYWordSprite.h"
#import "CYSqliteManager.h"

@class CYGameManager;
@protocol CYGameManagerDelegate <NSObject>

- (void)gameManagerCheckNeedClearWords:(NSArray*)words;
- (void)gameManagerNeedResrvePreWordsState:(NSArray*)words;

@end

@interface CYGameManager : NSObject<CYWordSpriteDelegate>
{
    NSMutableArray *words;
    NSMutableArray *correctList;
    
    NSMutableArray *playerSelectedWord;
    
    NSMutableDictionary *doorConfig;
    
    BOOL            openSound;
}
@property (nonatomic,assign)id<CYGameManagerDelegate> delegate;

- (NSArray*)allWords;
- (NSArray *)gameRoundWordsList;

- (void)addInputWord:(CYWordSprite*)aSprite;
- (void)removeInputWord:(CYWordSprite*)aSprite;
- (void)clearResult;

- (void)clearAndBuildNextRound;

@end
