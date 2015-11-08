//
// Created by Edelweiss on 2015/11/08.
// Copyright (c) 2015 Edelweiss. All rights reserved.
//

#import "CirclePoint.h"


@implementation CirclePoint {
    GLKVector3 _originalPos; //初期位置
    float _originalWeight;   //初期ウェイト

    GLKVector3 _pos;         //現在位置
    GLKVector3 _normal;      //法線
    GLKVector2 _uv;          //テクスチャ座標

    float _weight;           //現在ウェイト
}

-(id)initWithPos:(GLKVector3)pos uv:(GLKVector2)uv{
    if(self = [super init]){
        _originalPos = _pos = pos;
        _normal = (GLKVector3){0.0f, 0.0f, 1.0f};
        _uv = uv;

        _originalWeight = _weight = 0.0f;
    }
    return self;
}

-(void)culcCurrentPoint:(float)power rad:(float)rad{
    _pos.x = _originalPos.x - _weight * power * cosf(rad);
    _pos.y = _originalPos.y - _weight * power * sinf(rad);
}

-(void)setWeight:(float)weight{
    _weight = weight;
    _originalWeight = weight;
}

-(void)multWieight:(float)ratio{
    _weight = _originalWeight * ratio;
}

-(GLKVector3)getPosition{
    return _pos;
}

-(GLKVector3)getNormal{
    return _normal;
}

-(GLKVector2)getUV{
    return _uv;
}

-(float)getDistanceWithPos:(GLKVector2)pos{
    float diffX = pos.x - _originalPos.x;
    float diffY = pos.y - _originalPos.y;

    return sqrtf(diffX * diffX + diffY * diffY);
}

@end