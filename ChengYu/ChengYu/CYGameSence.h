//
//  CYGameSence.h
//  ChengYu
//
//  Created by ZYVincent on 13-6-17.
//  QQ群:219357847 个人QQ:1003081775
//  github:https://github.com/zyprosoft
//  Copyright (c) 2013年 ZYVincent. All rights reserved.
//

#import "CCLayer.h"
#import "CYGameManager.h"
#import "CYWordSprite.h"
#import "PlayTimer.h"
#import "CocosDenshion.h"
#import "SimpleAudioEngine.h"

@interface CYGameSence : CCLayer<CYGameManagerDelegate,CCTouchDelegate>
{
    CYGameManager *gameManager;
        
    int points;
    int mistakes;
    
    BOOL stopFriz;//停止冰冻
    
    CCSprite      *glass;//眼镜
    CCLabelTTF    *scoreLabel;
    CCLabelTTF    *mistakesLabel;
    CCLabelTTF    *timerLabel;
    CCMenuItemImage      *homeSprite;//返回主页
    
    CCSprite *menuBack;
    CCMenu   *menu;
    
    PlayTimer     *pTimer;//倒计时
    PlayTimer     *frizTimer;//冰冻倒计时
}

+ (CCScene *)scene;

@end
