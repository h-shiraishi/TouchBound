//
//  Sprite.h
//  TouchBound
//
//  Created by Edelweiss on 2015/11/01.
//  Copyright © 2015年 Edelweiss. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GLSetting.h"

@protocol SpriteDelegate<NSObject>
/*
 * 実行する処理
 * @praram spriteID スプライトID
 */
-(void)perform:(NSInteger)spriteID;
/**
 * タッチ中の処理
 * @param spriteID スプライトID
 */
-(void)touching:(NSInteger)spriteID;
/**
 * タッチ終了の処理
 * @param spriteID スプライトID
 */
-(void)touchEnd:(NSInteger)spriteID;

@end

@interface Sprite : NSObject

@property (nonatomic, weak)id<SpriteDelegate>delegate;
/**
 可視・不可視
 */
@property (nonatomic)BOOL visible;
/**
 タッチ可・不可
 */
@property (nonatomic)BOOL enableTouch;

/**
 * スプライトID
 */
@property (nonatomic)NSInteger spriteID;

/**
 * タッチ中か
 */
@property (nonatomic, readonly, getter=isTouching)BOOL isSpriteTouching;

/**
 初期化
 @param frame フレーム
 @param  texArea テクスチャUV
 @param texSize テクスチャサイズ
 @param type タッチしたときの挙動
 @param mode タッチしているときの挙動
 */
-(id)initWithFrame:(CGRect)frame texArea:(CGRect)texArea type:(TouchType)type mode:(TouchingMode)mode;

/**
 初期化
 @param frame フレーム
 @param  texArea テクスチャUV
 */
-(id)initWithFrame:(CGRect)frame texArea:(CGRect)texArea;

/**
 初期化
 @param frame フレーム
 */
-(id)initWithFrame:(CGRect)frame;

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
 タッチ判定
 @param touchPos タッチ位置
 @param isTouchStart タッチ開始
 @param isTouching タッチ中
 @param isTouchEnd タッチ終了
 */
-(void)touchCheck:(GLKVector2)touchPos isTouchStart:(BOOL)isTouchStart isTouching:(BOOL)isTouching isTouchEnd:(BOOL)isTouchEnd;

/**
 データ削除
 */
-(void)finish;

/**
 * 頂点データ更新
 * @param frame フレーム
 * @param texArea テクスチャUV
 */
-(void)updateVertexWithFrame:(CGRect)frame texArea:(CGRect)texArea;

@end
