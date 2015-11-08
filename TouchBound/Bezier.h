//
// Created by Edelweiss on 2015/11/08.
// Copyright (c) 2015 Edelweiss. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

typedef struct {
    GLKVector2 start;
    GLKVector2 end;
}ControlPoint;

@interface Bezier : NSObject


/**
 * ベジェ曲線初期化
 * @param control1 始点
 * @param control2 終点
 */
-(id)initWithControl1:(ControlPoint)control1 control2:(ControlPoint)control2 divide:(NSInteger)divide;

/**
 * ベジェ曲線の分割したところの位置を取得する
 * @param pos 分割した位置
 */
-(GLKVector2)getPosition:(NSInteger)pos;

@end