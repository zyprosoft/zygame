//
//  CYWord.h
//  ChengYu
//
//  Created by barfoo2 on 13-6-17.
//  Copyright (c) 2013年 ZYVincent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CYWord : NSObject
@property (nonatomic,retain)NSString *w_id;
@property (nonatomic,retain)NSString *w_value;
@property (nonatomic,assign)BOOL     isLocked;
- (id)initWithDict:(NSDictionary*)values;

@end
