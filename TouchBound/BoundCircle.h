//
// Created by Edelweiss on 2015/11/08.
// Copyright (c) 2015 Edelweiss. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GLSetting.h"

@interface BoundCircle : NSObject

/**
 可視・不可視
 */
@property (nonatomic)BOOL visible;

/**
 * 初期化
 * @param pos 位置
 * @param radius 半径
 */
-(id)initWithPos:(GLKVector2)pos radius:(float)radius;

/**
 更新
 @param trans 平行移動
 @param rotate 回転
 @param scale 拡大
 */
-(void)updateWithTrans:(CGTrans)trans rotate:(CGRotate)rotate scale:(CGScale)scale;

/**
 描画
 @param texInfo テクスチャ情報
 @param program シェーダープログラム
 @param alpha 透明度
 */
-(void)drawWithTexInfo:(GLKTextureInfo *)texInfo program:(GLuint)program alpha:(float)alpha;

/**
 *  ワイヤーフレーム描画
 *  @param program シェーダープログラム
 *  @param alpha 透明度
 */
-(void)drawWireframeWithProgram:(GLuint)program color:(UIColor *)color;

/**
 データ削除
 */
-(void)finish;

/**
 頂点にウェイトをつけて、頂点位置を変更する
 @param pos タッチ位置
 @param isTouchStart タッチ開始か
 @param isTouching タッチ中か
 @param isTouchEnd タッチ終了か
 @param power 押した強さ
 */
-(void)boundWithPos:(GLKVector2)pos isTouchStart:(BOOL)isTouchStart isTouching:(BOOL)isTouching isTouchEnd:(BOOL)isTouchEnd power:(float)power;

@end