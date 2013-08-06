//
//  CYWordSprite.h
//  ChengYu
//
//  Created by ZYVincent on 13-6-17.
//  QQ群:219357847 个人QQ:1003081775
//  github:https://github.com/zyprosoft
//  Copyright (c) 2013年 ZYVincent. All rights reserved.
//

#import "CCLayer.h"
#import "cocos2d.h"
#import "CYWord.h"

@class CYWordSprite;
@protocol CYWordSpriteDelegate <NSObject>
- (void)wordSpriteDidTouched:(CYWordSprite*)wSprite;
@end
@interface CYWordSprite : CCNode
{

}
@property (nonatomic,retain)CCSprite *wSprite;
@property (nonatomic,retain)CCSprite *wLock;
@property (nonatomic,retain)CCLabelTTF *titleLabel;
@property (nonatomic,retain)CYWord   *word;
@property (nonatomic,assign)BOOL     isSelected;
@property (nonatomic,assign)BOOL     isLocked;
@property (nonatomic,assign)int      spriteTag;
@property (nonatomic,assign)id<CYWordSpriteDelegate> delegate;

- (id)initWithWord:(CYWord*)aWord;

- (void)changeSelectedState;

- (void)setLockState:(BOOL)state;

@end
