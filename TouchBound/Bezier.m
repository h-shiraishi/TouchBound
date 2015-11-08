//
// Created by Edelweiss on 2015/11/08.
// Copyright (c) 2015 Edelweiss. All rights reserved.
//

#import "Bezier.h"


@implementation Bezier {
    ControlPoint _control1; //始点
    ControlPoint _control2; //終点
    float _interval;      //間隔
    NSInteger _divide;      //分割数
}

-(id)initWithControl1:(ControlPoint)control1 control2:(ControlPoint)control2 divide:(NSInteger)divide{
    if (self = [super init]) {
        _control1 = control1;
        _control2 = control2;

        _divide = divide;
        _interval = 1.0f / (float) _divide;
    }
    return self;
}

-(GLKVector2)getPosition:(NSInteger)pos{
    float t = _interval * (float)pos;

    if(pos > _divide){
        return (GLKVector2){0.0f, 0.0f};
    }

    return (GLKVector2){
            powf(1.0f - t, 3.0f) * _control1.start.x + powf(1.0f - t, 2.0f) * 3.0f * t * _control2.end.x +
                    (1.0f - t) * t * t * 3.0f * _control1.end.x + t * t * t * _control2.start.x,
            powf(1.0f - t, 3.0f) * _control1.start.y + powf(1.0f - t, 2.0f) * 3.0f * t * _control2.end.y +
                    (1.0f - t) * t * t * 3.0f * _control1.end.y + t * t * t * _control2.start.y
    };
}

@end