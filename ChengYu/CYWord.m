//
//  CYWord.m
//  ChengYu
//
//  Created by barfoo2 on 13-6-17.
//  Copyright (c) 2013年 ZYVincent. All rights reserved.
//

#import "CYWord.h"

@implementation CYWord
@synthesize w_id,w_value,isLocked;

- (id)initWithDict:(NSDictionary *)values
{
    if (self = [super init]) {
        
        self.w_id = [NSString stringWithFormat:@"%d",[[values objectForKey:@"w_id"]intValue]] ;
        self.w_value = [values objectForKey:@"w_value"];
        self.isLocked = NO;
    }
    return self;
}

- (void)dealloc
{
    self.w_id = nil;
    self.w_value = nil;
    [super dealloc];
}

@end
