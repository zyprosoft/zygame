//
//  PlayTimer.h
//  FunnyColors
//
//  Created by barfoo2 on 13-4-7.
//  Copyright (c) 2013年 FunnyColors. All rights reserved.
//

#import <Foundation/Foundation.h>

//游戏计时器
@interface PlayTimer : NSObject
{
    @private
    NSTimer *_timer;
    NSInteger usedTime;//已经耗时多少
    
    SEL            updateSelector;         //计时器每次更新需要触发的方法,必须可以返回参数，将当前时间返回出去
    id             updateOwner;            // 谁拥有这个计时器
    NSTimeInterval timeInterVal;           //计时器频率

}
@property (nonatomic,assign)NSInteger totalTime;//总共计时
@property (nonatomic,assign)BOOL      isStoped;//是否已经停止

- (id)initWithOwner:(id)owner WithUpdateSelector:(SEL)updateSel withTimeInterval:(NSTimeInterval)timeInteval;
- (id)initWithOwner:(id)owner WithUpdateSelector:(SEL)updateSel withIncreaseTimeInterval:(NSTimeInterval)timeInteval;

- (void)startTimer;
- (void)stopTimer;
- (void)restartTimer;
- (void)reduceTimeWithSecond:(NSInteger)seconds;
- (void)increaseTimeWithSecond:(NSInteger)seconds;
- (NSInteger)totalTimeNeedWithTimeInterval:(NSTimeInterval)eachTime withTimerCount:(NSInteger)timeCount;

@end
