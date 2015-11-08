//
// Created by Edelweiss on 2015/11/07.
// Copyright (c) 2015 Edelweiss. All rights reserved.
//

#import "SpriteManager.h"


@implementation SpriteManager{
    NSInteger _currentNum;
    NSMutableArray *_spriteIDs;
}


static SpriteManager* data = nil;

+(SpriteManager *)manager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        data = [SpriteManager new];
        [data initNum];
    });
    return data;
}

-(void)initNum{
    _spriteIDs = [NSMutableArray array];
    _currentNum = 0;
}

-(NSInteger)register {
    _currentNum++;
    [_spriteIDs addObject:@(_currentNum)];

    return _currentNum;
}

-(void)delete:(NSInteger)spriteID {
    [_spriteIDs removeObject:@(spriteID)];
}

@end