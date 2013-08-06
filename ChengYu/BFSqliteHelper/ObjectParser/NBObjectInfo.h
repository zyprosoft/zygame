//
//  NBObjectInfo.h
//  YXPiOSClient
//
//  Created by liudi on 6/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#define  INT                    0
#define  FLOAT                  1
#define  DOUBLE                 2
#define  STRING                 3

//这枚举的定义和DataBaseUtils.h中的定义相对应
typedef enum{

    intType       = 0,
    floatType     = 1,
    doubleType    = 2,
    stringType    = 3,
    unSupportType = 4
    
}DataType;

@interface NBObjectInfo : NSObject{

    @private
    
    id         _value;
    DataType   _valueType;
} 
@property (nonatomic, retain) id  value;
@property (nonatomic ,assign) DataType valueType;

@end
