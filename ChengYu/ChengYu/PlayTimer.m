//
//  PlayTimer.m
//  FunnyColors
//
//  Created by ZYVincent on 13-4-7.
//  QQ群:219357847 个人QQ:1003081775
//  github:https://github.com/zyprosoft
//  Copyright (c) 2013年 FunnyColors. All rights reserved.
//

#import "PlayTimer.h"

@implementation PlayTimer
@synthesize totalTime;
@synthesize isStoped;

- (id)initWithOwner:(id)owner WithUpdateSelector:(SEL)updateSel withTimeInterval:(NSTimeInterval)timeInteval
{
    if (self = [super init]) {
        
        updateOwner = [owner retain];
        updateSelector = updateSel;
        timeInterVal = timeInteval;
        
        _timer = [NSTimer scheduledTimerWithTimeInterval:timeInterVal target:self selector:@selector(updateCurrentTimer:) userInfo:nil repeats:YES];
    }
    return self;
}

- (id)initWithOwner:(id)owner WithUpdateSelector:(SEL)updateSel withIncreaseTimeInterval:(NSTimeInterval)timeInteval
{
    if (self = [super init]) {
        
        updateOwner = [owner retain];
        updateSelector = updateSel;
        timeInterVal = timeInteval;
        
        _timer = [NSTimer scheduledTimerWithTimeInterval:timeInterVal target:self selector:@selector(updateCurrentTimerIncrease:) userInfo:nil repeats:YES];
    }
    return self;
}

- (void)dealloc
{
    [updateOwner release];
    [super dealloc];
}

- (void)startTimer
{
    if (_timer ) {
        [_timer fire];
        isStoped = NO;
    }
}
- (void)restartTimer
{
    _timer = [NSTimer scheduledTimerWithTimeInterval:timeInterVal target:self selector:@selector(updateCurrentTimer:) userInfo:nil repeats:YES];
    
    [_timer fire];
    isStoped = NO;
}
- (void)stopTimer
{
    if (isStoped) {
        return;
    }
    if (_timer) {
        [_timer invalidate];
        isStoped = YES;
    }
}

- (void)reduceTimeWithSecond:(NSInteger)seconds
{
    NSInteger changeToInterval = seconds;
    usedTime = usedTime + changeToInterval;
}

- (void)increaseTimeWithSecond:(NSInteger)seconds
{
    NSInteger changeToInterval = seconds;
    usedTime = usedTime - changeToInterval;
}


#pragma mark - 计时器刷新时候执行的方法
- (void)updateCurrentTimerIncrease:(NSTimer*)timer
{
    usedTime = usedTime + timeInterVal;//每次都加上时间
    [updateOwner performSelector:updateSelector withObject:[NSNumber numberWithInt:usedTime]];//每次更新,花去多少秒
}
- (void)updateCurrentTimer:(NSTimer*)timer
{
    usedTime = usedTime + timeInterVal;//每次都加上时间
    
    if (usedTime > self.totalTime) {
        
        [timer invalidate];//计时已经到了
    }else{
        
//        NSLog(@"update timer ---->%d",usedTime);
        [updateOwner performSelector:updateSelector withObject:[NSNumber numberWithInt:self.totalTime-usedTime]];//每次更新,花去多少秒
        
    }
    
}

- (NSInteger)totalTimeNeedWithTimeInterval:(NSTimeInterval)eachTime withTimerCount:(NSInteger)timeCount
{
    return eachTime * (timeCount+1);//1到0,多一次
}

@end
