//
//  CYWordSprite.m
//  ChengYu
//
//  Created by barfoo2 on 13-6-17.
//  Copyright (c) 2013年 ZYVincent. All rights reserved.
//

#import "CYWordSprite.h"

@implementation CYWordSprite
@synthesize wSprite,word,titleLabel;
@synthesize isSelected;
@synthesize isLocked;
@synthesize spriteTag;
@synthesize delegate;
@synthesize wLock;

- (id)init
{
    if (self = [super init]) {
        
    }
    return self;
}

- (id)initWithWord:(CYWord *)aWord
{
    if (self = [super init]) {
        
//        self.color = ccc3(0.5, 0.3, 0.2);

        //sprite
        self.wSprite = [CCSprite spriteWithFile:@"tile.png"];
        self.wSprite.position = ccp(wSprite.contentSize.width/2,wSprite.contentSize.height/2);
        [self addChild:wSprite];
        
        //
        self.titleLabel = [CCLabelTTF labelWithString:aWord.w_value fontName:@"Arial" fontSize:24];
        self.titleLabel.position = ccp(self.wSprite.contentSize.width/2,self.wSprite.contentSize.height/2);
        [self addChild:titleLabel];
        
        self.word = aWord;
        
        self.isSelected = NO;
        self.isLocked = self.word.isLocked;
        
        [self setLockState:self.isLocked];
        
    }
    return self;
}

- (void)setLockState:(BOOL)state
{
    self.isLocked = state;
    
    
    if (self.isLocked) {
        
        self.wLock = [CCSprite spriteWithFile:@"tile_lock.png"];
        self.wLock.position = ccp(self.wSprite.contentSize.width/2,self.wSprite.contentSize.height/2);
        [self addChild:self.wLock];
        
    }else{
        
        if (self.wLock) {
            [self removeChild:self.wLock];
        }
    }
    
}

- (void)changeSelectedState
{
    self.isSelected = !self.isSelected;
    
    if (self.isSelected) {
        
        CCTexture2D *selected = [[CCTextureCache sharedTextureCache]addImage:@"tile_selected.png"];
        
        [self.wSprite setTexture:selected];
        
    }else{
        
        CCTexture2D *unselected = [[CCTextureCache sharedTextureCache]addImage:@"tile.png"];

        [self.wSprite setTexture:unselected];
        
    }
}

//- (void)onEnter
//{
//    [super onEnter];
//    
//    [[[CCDirector sharedDirector]touchDispatcher]addTargetedDelegate:self priority:0 swallowsTouches:YES];
//}
//
//- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
//{
//    isSelected = !isSelected;
//    if (isSelected) {
//
//        CCTexture2D *select = [[CCTexture2D alloc]initWithCGImage:[UIImage imageNamed:@"tile_selected.png"].CGImage resolutionType:kCCResolutioniPhone];
//
//        self.wSprite.texture = select;
//
//        [select release];
//
//       }else{
//
//           CCTexture2D *select = [[CCTexture2D alloc]initWithCGImage:[UIImage imageNamed:@"tile.png"].CGImage resolutionType:kCCResolutioniPhone];
//
//          self.wSprite.texture = select;
//    
//           [select release];
//       }
//    
//    return YES;
//}
//- (void)ccTouchCancelled:(UITouch *)touch withEvent:(UIEvent *)event
//{
//}
//- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event
//{
//    
//}
//- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
//{
//    if (self.delegate && [self.delegate respondsToSelector:@selector(wordSpriteDidTouched:)]) {
//        [self.delegate respondsToSelector:@selector(wordSpriteDidTouched:)];
//    }
//}

- (void)dealloc
{
    self.wSprite = nil;
    self.word = nil;
    self.titleLabel = nil;
    [super dealloc];
}
@end
