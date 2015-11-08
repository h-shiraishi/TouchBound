//
// Created by Edelweiss on 2015/11/07.
// Copyright (c) 2015 Edelweiss. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SpriteManager : NSObject

+ (SpriteManager *)manager;

-(void)initNum;
-(NSInteger)register;
-(void)delete:(NSInteger)spriteID;

@end