//
//  CYHomeSence.m
//  ChengYu
//
//  Created by ZYVincent on 13-6-21.
//  QQ群:219357847 个人QQ:1003081775
//  github:https://github.com/zyprosoft
//  Copyright (c) 2013年 ZYVincent. All rights reserved.
//

#import "CYHomeSence.h"
#import "CYGameSence.h"

#define IS_IPHONE_5  [[UIScreen mainScreen]bounds].size.height==568

@implementation CYHomeSence

- (id)init
{
    if(self= [super init]){
        
        CGSize winSize = [[CCDirector sharedDirector]winSize];
        
        NSString *homeBack = nil;
        if (IS_IPHONE_5) {
            homeBack = @"home1_i5.png";
        }else{
            homeBack = @"home1.png";
        }
        CCSprite *back = [CCSprite spriteWithFile:homeBack];
        back.position = ccp(back.contentSize.width/2,back.contentSize.height/2);
        [self addChild:back];
        
        CCMenuItemImage *start = [CCMenuItemImage itemWithNormalImage:@"menu_item_start.png" selectedImage:nil disabledImage:nil target:self selector:@selector(playNow)];
        start.position = ccp(340,132.25);
        
        CCMenuItemImage *sound = [CCMenuItemImage itemWithNormalImage:@"menu_item_sound.png" selectedImage:nil disabledImage:nil target:self selector:@selector(soundSet)];
        sound.position = ccp(90,210);

        CCMenuItemImage *superDoor = [CCMenuItemImage itemWithNormalImage:@"menu_item_super.png" selectedImage:nil disabledImage:nil target:self selector:@selector(superDoor)];
        superDoor.position = ccp(90,155);

        CCMenuItemImage *rateUs = [CCMenuItemImage itemWithNormalImage:@"menu_item_rate.png" selectedImage:nil disabledImage:nil target:self selector:@selector(rateMe)];
        rateUs.position = ccp(90,100);

        CCMenuItemImage *about = [CCMenuItemImage itemWithNormalImage:@"menu_item_about.png" selectedImage:nil disabledImage:nil target:self selector:@selector(aboutAs)];
        about.position = ccp(90,45);
        
        
        NSMutableArray *menuArray = [NSMutableArray array];
        [menuArray addObject:start];
        [menuArray addObject:sound];
        [menuArray addObject:superDoor];
        [menuArray addObject:rateUs];
        [menuArray addObject:about];
        
        menu = [CCMenu menuWithArray:menuArray];
        
        menu.position = ccp(30,40);
        [self addChild:menu];
        
    }
    return self;
}

+ (CCScene*)scene
{
    CCScene *newScene = [CCScene node];
    
    CYHomeSence *home = [CYHomeSence node];
    
    [newScene addChild:home];
    
    return newScene;
}

- (void)playNow
{
    [[CCDirector sharedDirector]replaceScene:[CCTransitionSlideInR transitionWithDuration:1.2f scene:[CYGameSence scene]]];
}

- (void)soundSet
{
    
}

- (void)superDoor
{
    
}

- (void)rateMe
{
    
}

- (void)aboutAs
{
    
}
@end
