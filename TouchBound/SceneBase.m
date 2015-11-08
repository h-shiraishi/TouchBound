//
// Created by Edelweiss on 2015/11/06.
// Copyright (c) 2015 Edelweiss. All rights reserved.
//

#import "SceneBase.h"


@implementation SceneBase

-(id)initScene{
    if(self = [super init]){

    }
    return self;
}

-(void)updateScene:(NSDictionary *)data touchPos:(GLKVector2)touchPos isTouchStart:(BOOL)isTouchStart isTouching:(BOOL)isTouching isTouchEnd:(BOOL)isTouchEnd power:(float)power {
}

-(void)drawScene{

}

-(void)finishScene {
}

@end