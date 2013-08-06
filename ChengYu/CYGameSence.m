//
//  CYGameSence.m
//  ChengYu
//
//  Created by barfoo2 on 13-6-17.
//  Copyright (c) 2013年 ZYVincent. All rights reserved.
//

#import "CYGameSence.h"
#import "CYHomeSence.h"

#define IS_IPHONE_5  [[UIScreen mainScreen]bounds].size.height==568

#define kMenuBackTag 88887
#define kBackTag 88886
#define kMenuTag     88888
#define KMenuTitleTag 88889

@implementation CYGameSence

+ (CCScene*)scene
{
    CCScene *newScene = [CCScene node];
    CYGameSence *game = [CYGameSence node];
    [newScene addChild:game];
    
    return newScene;
}

- (void)returnToHome
{
    [[CCDirector sharedDirector]replaceScene:[CCTransitionSlideInL transitionWithDuration:1.2f scene:[CYHomeSence scene ]]];
}

#pragma mark - 开始新的一关
- (void)removeMenuAfterMoveUp
{
    if ([self getChildByTag:kMenuTag]) {
        [self removeChild:kMenuTag];
    }
}

- (void)nextGoundRandom
{    
    //清除并刷新数据
    [gameManager clearAndBuildNextRound];
    
    //刷新界面
    //移出所有的wordsprite
    for (int i=111; i<111+36; i++) {
        if ([self getChildByTag:i]) {
            [self removeChildByTag:i];
        }
    }
    
    //重新计算时间
    if (pTimer) {
        [pTimer release];
        pTimer = nil;
        pTimer = [[PlayTimer alloc]initWithOwner:self WithUpdateSelector:@selector(updatePTimer:) withTimeInterval:1];
        pTimer.totalTime = [pTimer totalTimeNeedWithTimeInterval:1 withTimerCount:1*10*60];
        [pTimer startTimer];
    }
    
    //build secen
    CGSize winSize = [[CCDirector sharedDirector]winSize];

    NSArray *allWords = [gameManager allWords];
    
    //随机排列
    NSMutableArray *chooseArr = [NSMutableArray array];
    for (int i=0; i<4; i++) {
        
        for (int j=0; j<9; j++) {
            
            NSInteger index = i*9+j;
            
            int randIndex = arc4random()%allWords.count;
            
            if ([chooseArr containsObject:[allWords objectAtIndex:randIndex]]) {
                j--;
                continue;
            }else{
                CYWord *word = [allWords objectAtIndex:randIndex];
                CYWordSprite *nSprite = [[CYWordSprite alloc]initWithWord:word];
                nSprite.contentSize = nSprite.wSprite.contentSize;
                nSprite.tag = 111+index;
                CGFloat leftRightMargin = (winSize.width -nSprite.contentSize.width*9)/2;
                CGFloat topBottomMargin = (winSize.height-nSprite.contentSize.height*4)/2;
                
                nSprite.position = ccp(nSprite.contentSize.width*j+leftRightMargin,topBottomMargin+nSprite.contentSize.height*i);
                [self addChild:nSprite];
                
                [chooseArr addObject:word];
                [nSprite release];
            }
        }
        
    }
    
    //如果显示了失败界面，那么移出它
    if ([self getChildByTag:kMenuTag]) {
        CCNode *menuNewBack = [self getChildByTag:kMenuTag];
        CCSequence *moveUp = [CCSequence actionWithArray:[NSArray arrayWithObjects:[CCMoveTo actionWithDuration:0.3f position:ccp(winSize.width/2,winSize.height+menuNewBack.contentSize.height/2)],[CCCallFunc actionWithTarget:self selector:@selector(removeMenuAfterMoveUp)] ,nil]];
        [menuNewBack runAction:moveUp];
    }

}

- (id)init
{
    if (self = [super init]) {
        
        CGSize winSize = [[CCDirector sharedDirector]winSize];
        
        gameManager = [[CYGameManager alloc]init];
        gameManager.delegate = self;
        
        //build secen
        NSArray *allWords = [gameManager allWords];
        
        NSString *backFile = nil;
        if (IS_IPHONE_5) {
            backFile = @"play_back1_i5.png";
        }else{
            backFile = @"play_back1.png";
        }
        CCSprite *back = [CCSprite spriteWithFile:backFile];
        back.tag = kBackTag;
        back.position = ccp(winSize.width/2,winSize.height/2);
        back.zOrder = -1;
        [self addChild:back];
        
        //返回主页
        homeSprite = [CCMenuItemImage itemWithNormalImage:@"return_home.png" selectedImage:nil target:self selector:@selector(returnToHome)];
        homeSprite.position = ccp(0,20);
        CCMenu *newMenu = [CCMenu menuWithArray:[NSArray arrayWithObject:homeSprite]];
        newMenu.position = ccp(40,280);
        [self addChild:newMenu];
        
        //分数
        CCSprite *tagScore = [CCSprite spriteWithFile:@"tag_item_score.png"];
        tagScore.zOrder = 334;
        tagScore.position = ccp(120,300);
        [self addChild:tagScore];
        
        scoreLabel = [CCLabelTTF labelWithString:@"0" fontName:@"MarkerFelt-Thin" fontSize:30];
        scoreLabel.zOrder = 334;
        scoreLabel.color = ccc3(0,255,0);
        scoreLabel.position = ccp(170,300);
        [self addChild:scoreLabel];
        
        //犯错
        CCSprite *tagMis = [CCSprite spriteWithFile:@"tag_item_mis.png"];
        tagMis.zOrder = 334;
        tagMis.position = ccp(220,300);
        [self addChild:tagMis];
        
        mistakesLabel = [CCLabelTTF labelWithString:@"0" fontName:@"MarkerFelt-Thin" fontSize:30];
        mistakesLabel.zOrder = 334;
        mistakesLabel.color = ccc3(255,0,0);
        mistakesLabel.position = ccp(270,300);
        [self addChild:mistakesLabel];
        
        //倒计时
        CCSprite *tagTimer = [CCSprite spriteWithFile:@"tag_item_timer.png"];
        tagTimer.zOrder = 334;
        tagTimer.position = ccp(320, 300);
        [self addChild:tagTimer];
        
        timerLabel = [CCLabelTTF labelWithString:@"60" fontName:@"MarkerFelt-Thin" fontSize:30];
        timerLabel.zOrder = 334;
        timerLabel.color = ccc3(0,0,255);
        timerLabel.position = ccp(370,300);
        [self addChild:timerLabel];
        
        pTimer = [[PlayTimer alloc]initWithOwner:self WithUpdateSelector:@selector(updatePTimer:) withTimeInterval:1];
        pTimer.totalTime = [pTimer totalTimeNeedWithTimeInterval:1 withTimerCount:1*30];
        
        frizTimer = [[PlayTimer alloc]initWithOwner:self WithUpdateSelector:@selector(frizTimer:) withTimeInterval:6];
        frizTimer.totalTime = [frizTimer totalTimeNeedWithTimeInterval:6 withTimerCount:6*allWords.count];
        
        //随机排列
        NSMutableArray *chooseArr = [NSMutableArray array];
        for (int i=0; i<4; i++) {
            
            for (int j=0; j<9; j++) {
                
                NSInteger index = i*9+j;
                
                int randIndex = arc4random()%allWords.count;
                
                if ([chooseArr containsObject:[allWords objectAtIndex:randIndex]]) {
                    j--;
                    continue;
                }else{
                    CYWord *word = [allWords objectAtIndex:randIndex];
                    CYWordSprite *nSprite = [[CYWordSprite alloc]initWithWord:word];
                    nSprite.contentSize = nSprite.wSprite.contentSize;
                    nSprite.tag = 111+index;
                    CGFloat leftRightMargin = (winSize.width -nSprite.contentSize.width*9)/2;
                    CGFloat topBottomMargin = (winSize.height-nSprite.contentSize.height*4)/2;
                    
                    nSprite.position = ccp(nSprite.contentSize.width*j+leftRightMargin,topBottomMargin+nSprite.contentSize.height*i);
                    [self addChild:nSprite];
                    
                    [chooseArr addObject:word];
                    [nSprite release];
                }
            }
            
        }
        
        //声音
        [[SimpleAudioEngine sharedEngine]preloadEffect:@"word_exp1.wav"];
        
        //开始计时
        [pTimer startTimer];
        [frizTimer startTimer];
        
    }

    return self;
}


- (void)onEnter
{
    [super onEnter];
    
    [[[CCDirector sharedDirector]touchDispatcher]addTargetedDelegate:self priority:0 swallowsTouches:YES];
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint p = [touch locationInView:[touch view]];
    CGPoint tp = [[CCDirector sharedDirector]convertToGL:p];
    
    NSLog(@"ture point --->%@",NSStringFromCGPoint(tp));
    
    CYWordSprite *tSprite = nil;
    for (CYWordSprite *sprite in self.children) {
        
        if (sprite.tag != -1) {
            
            NSLog(@"tSprite boundingBox--->%@",NSStringFromCGRect(sprite.boundingBox));
            
            if ([sprite isKindOfClass:[CYWordSprite class]]) {
                if (CGRectContainsPoint(sprite.boundingBox, tp)) {
                    
                    tSprite = sprite;
                    break;
                }
            }
            
        }
    }
    
    if (tSprite) {
        if (tSprite.isLocked) {
            return NO;
        }
        [tSprite changeSelectedState];
        
        if (tSprite.isSelected) {
            [gameManager addInputWord:tSprite];
        }else{
            [gameManager removeInputWord:tSprite];
        }
        
        return YES;
    }else{
        return NO;
    }
}
- (void)ccTouchCancelled:(UITouch *)touch withEvent:(UIEvent *)event
{
}
- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
    
}
- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{

}

#pragma booms
- (void)boomsNow
{
    //解锁
    for (CCNode *sprite in self.children) {
        
        if ([sprite isKindOfClass:[CYWordSprite class]]) {
            
            CYWordSprite *tSprite = (CYWordSprite*)sprite;
            
            if (tSprite.isLocked) {
                
                CCParticleSystemQuad *fire = [CCParticleSystemQuad particleWithFile:@"unfriz.plist"];
                fire.position = tSprite.position;
                fire.duration = 0.4;
                fire.autoRemoveOnFinish=YES;
                [self addChild:fire];
                
                [tSprite setLockState:NO];
            }
        }
    }
}

#pragma mark game manager delegate
- (void)gameManagerCheckNeedClearWords:(NSArray *)words
{
    for (int i=0; i<words.count; i++) {
        CYWordSprite *nSprite = [words objectAtIndex:i];
        CCParticleSystemQuad *fire = [CCParticleSystemQuad particleWithFile:@"fire.plist"];
        fire.position = nSprite.position;
        fire.autoRemoveOnFinish=YES;
        [self addChild:fire];
        
        //爆炸声音
        [[SimpleAudioEngine sharedEngine]playEffect:@"word_exp1.wav"];
        
        [self removeChild:nSprite];
        

    }
    //加分
    points = points + 10;
    
    [scoreLabel setString:[NSString stringWithFormat:@"%d",points]];
    
    //解锁
    for (CCNode *sprite in self.children) {
        
        if ([sprite isKindOfClass:[CYWordSprite class]]) {
            
            CYWordSprite *tSprite = (CYWordSprite*)sprite;
            
            if (tSprite.isLocked) {
                
                [tSprite setLockState:NO];
            }
        }
    }
    
    //解除冰封
    [frizTimer stopTimer];
}
- (void)gameManagerNeedResrvePreWordsState:(NSArray *)words
{
    if (words.count==0) {
        return;
    }
    for (int i=0; i<words.count; i++) {
        
        CYWordSprite *sprite = [words objectAtIndex:i];
        
        [sprite changeSelectedState];
    }
    
    //犯错
    mistakes = mistakes + 1;
    [mistakesLabel setString:[NSString stringWithFormat:@"%d",mistakes]];
    [pTimer reduceTimeWithSecond:30];
    
    [frizTimer restartTimer];
}

//初始化失败界面
- (void)initFaildSprites
{
    CGSize winSize = [[CCDirector sharedDirector]winSize];
    
    //输掉了
    NSString *menuBackFile = nil;
    if (IS_IPHONE_5) {
        menuBackFile = @"menu_back_i5.png";
    }else{
        menuBackFile = @"menu_back1.png";
    }
    CCSprite *menuNewBack = [CCSprite spriteWithFile:menuBackFile];
    menuNewBack.tag = kMenuTag;
    menuNewBack.zOrder = 555;
    menuNewBack.position = ccp(winSize.width/2,winSize.height+menuNewBack.contentSize.height/2);
    [self addChild:menuNewBack];
    
    //title
    CCSprite *faildTile = [CCSprite spriteWithFile:@"tag_result_faild.png"];
    faildTile.position = ccp(menuNewBack.contentSize.width/2,menuNewBack.contentSize.height/2+60);
    [menuNewBack addChild:faildTile];
    
    //
    CCMenuItemImage *homePageItem = [CCMenuItemImage itemWithNormalImage:@"tag_home.png" selectedImage:nil disabledImage:nil target:self selector:@selector(returnToHome)];
    homePageItem.position = ccp(0,0);
    
    CCMenuItemImage *retryItem = [CCMenuItemImage itemWithNormalImage:@"retry.png" selectedImage:nil disabledImage:nil target:self selector:@selector(nextGoundRandom)];
    retryItem.position =   ccp(100,0);
    
    CCMenu *menuNew = [CCMenu menuWithArray:[NSArray arrayWithObjects:homePageItem,retryItem,nil]];
    menuNew.position = ccp(menuNewBack.contentSize.width/2,menuNewBack.contentSize.height/2);
    [menuNewBack addChild:menuNew];
    
    CCSequence *moveDown = [CCSequence actionWithArray:[NSArray arrayWithObjects:[CCMoveTo actionWithDuration:0.3f position:ccp(self.contentSize.width/2,self.contentSize.height/2)], nil]];
    [menuNewBack runAction:moveDown];
}

#pragma mark - 倒计时
- (void)updatePTimer:(NSNumber*)num
{
    
    //如果倒计时到了，你就输了
    if ([num intValue]==0) {
        
        [self initFaildSprites];
        
    }
    
    int min = [num intValue]/60;
    int second = [num intValue] - min*60;
    [timerLabel setString:[NSString stringWithFormat:@"%d:%d",min,second]];
}

- (void)frizTimer:(NSNumber*)num
{
    //逐渐冰冻
    CYWordSprite *resultSprite = nil;
    for (int i=0; i<self.children.count;i++) {
        
        CCNode *item = [self.children objectAtIndex:i];
        
        if ([item isKindOfClass:[CYWordSprite class]]) {
            
            CYWordSprite *sSprite = (CYWordSprite *)item;
        
            if (!sSprite.isLocked) {
                resultSprite = sSprite;
                break;
            }
        }
        
    }
    
    if (resultSprite) {
        if (resultSprite.isSelected) {
            [gameManager removeInputWord:resultSprite];
            [resultSprite changeSelectedState];
        }
        [resultSprite setLockState:YES];
        
        CCParticleSystemQuad *fire = [CCParticleSystemQuad particleWithFile:@"friz.plist"];
        fire.position = ccp(resultSprite.position.x+resultSprite.contentSize.width/2,resultSprite.position.y+resultSprite.contentSize.height/2);
        fire.duration = 0.8;
        fire.autoRemoveOnFinish=YES;
        [self addChild:fire];
    }else{
        
        //失败了，没有可以冰封的字了
        [self initFaildSprites];
        
    }

}

@end
