//
// Created by Edelweiss on 2015/11/08.
// Copyright (c) 2015 Edelweiss. All rights reserved.
//

#import "Spring.h"

#define GRAVITY 0.0f   //重力
#define STIFFNESS 0.5f //ばね定数
#define DAMPING 0.9f   //減衰力

@implementation Spring {
    GLKVector2 _pos;      //位置
    GLKVector2 _velocity; //速度
    float _mass;     //重さ
}

-(id)initWithPos:(GLKVector2)pos mass:(float)mass{
    if(self = [super init]) {
        _pos = pos;
        _mass = mass;
        _velocity = (GLKVector2) {0.0f, 0.0f};
    }
    return self;
}

-(GLKVector2)updateWithTarget:(GLKVector2)target{
    //力
    GLKVector2 force = (GLKVector2){
            (target.x - _pos.x) * STIFFNESS,
            (target.y - _pos.y) * STIFFNESS + GRAVITY
    };

    //加速度
    GLKVector2 acceleration = (GLKVector2){
            force.x / _mass,
            force.y / _mass
    };

    //速度
    _velocity = (GLKVector2){
            (_velocity.x + acceleration.x) * DAMPING,
            (_velocity.y + acceleration.y) * DAMPING
    };

    //位置
    _pos = (GLKVector2){
            _pos.x + _velocity.x,
            _pos.y + _velocity.y
    };

    return _pos;
}

@end