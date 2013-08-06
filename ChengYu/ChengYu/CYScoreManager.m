//
//  CYScoreManager.m
//  ChengYu
//
//  Created by ZYVincent on 13-6-17.
//  QQ群:219357847 个人QQ:1003081775
//  github:https://github.com/zyprosoft
//  Copyright (c) 2013年 ZYVincent. All rights reserved.
//

#import "CYScoreManager.h"

@implementation CYScoreManager

- (void)addPoints:(int)points
{
    currentPoints = currentPoints + points;
}

- (void)increaseDoor
{
    currentDoor++;
}

- (void)decreaseDoor
{
    currentDoor--;
}

- (void)addMistakes:(int)mistakes
{
    currentMistakes = currentMistakes + mistakes;
}

- (void)chooseDiff:(int)diff
{
    currentDiff = diff;
}

- (int)cDiff
{
    return currentDiff;
}

- (int)cDorrs
{
    return currentDoor;
}

- (int)cMistakes
{
    return currentMistakes;
}

- (int)cPoints
{
    return currentPoints;
}

@end
