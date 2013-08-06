//
//  CYWordSprite.h
//  ChengYu
//
//  Created by barfoo2 on 13-6-17.
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
