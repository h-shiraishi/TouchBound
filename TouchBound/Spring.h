//
// Created by Edelweiss on 2015/11/08.
// Copyright (c) 2015 Edelweiss. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

@interface Spring : NSObject

/**
 * 初期化
 * @param pos 初期位置
 * @param mass 重り
 */
-(id)initWithPos:(GLKVector2)pos mass:(float)mass;

/**
 * 位置を更新する
 * @param target 目標位置
 */
-(GLKVector2)updateWithTarget:(GLKVector2)target;

@end