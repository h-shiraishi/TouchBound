//
//  GLSetting.h
//  TouchBound
//
//  Created by Edelweiss on 2015/11/01.
//  Copyright © 2015年 Edelweiss. All rights reserved.
//

#import <GLKit/GLKit.h>
#import <OpenGLES/ES2/glext.h>

#ifndef GLSetting_h
#define GLSetting_h

#define BUFFER_OFFSET(i) ((char *)NULL + (i))

#define TEX_SPRITE_OPTIONS @{@"attribute" : @[@{@"index" : [NSNumber numberWithInt:0], @"name" : @"position"},@{@"index" : [NSNumber numberWithInt:1], @"name" : @"normal"}, @{@"index" : [NSNumber numberWithInt:2], @"name" : @"uv"}]}
#define WIREFRAME_OPTIONS @{@"attribute" : @[@{@"index" : [NSNumber numberWithInt:0], @"name" : @"position"}]}

typedef enum TouchType : NSInteger{
    TOUCH_NONE,
    TOUCH_DOWN,
    TOUCH_UP_INSIDE
}TouchType;

typedef enum touchingMode : NSInteger{
    CHANGE_NONE,
    CHANGE_COLOR,
    CHANGE_MOVE,
    CHANGE_TEX
}TouchingMode;

typedef struct {
    float x;
    float y;
    float z;
}CGTrans;

typedef struct {
    float x;
    float y;
    float z;
}CGRotate;

typedef struct {
    float x;
    float y;
    float z;
}CGScale;

#endif /* GLSetting_h */
