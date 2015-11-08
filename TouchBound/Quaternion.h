//
// Created by Edelweiss on 2015/11/05.
// Copyright (c) 2015 Edelweiss. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

typedef struct{
    float w; //実数
    float x; //虚数i
    float y; //虚数j
    float z; //虚数k
}Quat;

@interface Quaternion : NSObject

+(GLKMatrix4)quatToMatrix:(Quat)lpQ;
+(Quat)quatMultWithQuatP:(Quat)lpP quatQ:(Quat)lpQ;
+(GLKVector3)quatNormalize:(GLKVector3)vec;
+(Quat)quatRotateWithRad:(float)rad axis:(GLKVector3)axis;

@end