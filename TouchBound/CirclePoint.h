//
// Created by Edelweiss on 2015/11/08.
// Copyright (c) 2015 Edelweiss. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

@interface CirclePoint : NSObject

/**
 * @param pos 位置
 * @param uv テクスチャ座標
 */
-(id)initWithPos:(GLKVector3)pos uv:(GLKVector2)uv;

/**
 * 働く力と角度から位置を更新する
 * @param power 力
 * @param rad 角度
 */
-(void)culcCurrentPoint:(float)power rad:(float)rad;

/**
 * ウェイトをセット
 */
-(void)setWeight:(float)weight;

/**
 * ウェイトにratioをかける
 * @param ratio 割合
 */
-(void)multWieight:(float)ratio;

/**
 * 位置を取得
 */
-(GLKVector3)getPosition;

/**
 * 法線座標を取得
 */
-(GLKVector3)getNormal;

/**
 * テクスチャ座標を取得
 */
-(GLKVector2)getUV;

/**
 * 距離を求める
 * @param pos 位置
 */
-(float)getDistanceWithPos:(GLKVector2)pos;

@end