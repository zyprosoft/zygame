//
//  CYWord.h
//  ChengYu
//
//  Created by ZYVincent on 13-6-17.
//  QQ群:219357847 个人QQ:1003081775
//  github:https://github.com/zyprosoft
//  Copyright (c) 2013年 ZYVincent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CYWord : NSObject
@property (nonatomic,retain)NSString *w_id;
@property (nonatomic,retain)NSString *w_value;
@property (nonatomic,assign)BOOL     isLocked;
- (id)initWithDict:(NSDictionary*)values;

@end
