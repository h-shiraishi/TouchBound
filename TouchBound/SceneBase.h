//
// Created by Edelweiss on 2015/11/06.
// Copyright (c) 2015 Edelweiss. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

@interface SceneBase : NSObject

/**
 * シーンの初期化
 */
-(id)initScene;

/**
 * シーンの更新
 * @param data コントローラからの情報
 * @param touchPos タッチ位置
 * @param isTouchStart タッチ開始フラグ
 * @param isTouching タッチ中フラグ
 * @param isTouchEnd タッチ終了フラグ
 * @param power タッチした強さ
 */
-(void)updateScene:(NSDictionary *)data touchPos:(GLKVector2)touchPos isTouchStart:(BOOL)isTouchStart isTouching:(BOOL)isTouching isTouchEnd:(BOOL)isTouchEnd power:(float)power;

/**
 * シーンの描画
 */
-(void)drawScene;

/**
 * シーンの破棄
 */
-(void)finishScene;

@end