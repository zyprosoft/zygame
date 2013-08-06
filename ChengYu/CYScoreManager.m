//
//  CYScoreManager.m
//  ChengYu
//
//  Created by barfoo2 on 13-6-17.
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
