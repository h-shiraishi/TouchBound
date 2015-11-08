//
// Created by Edelweiss on 2015/11/06.
// Copyright (c) 2015 Edelweiss. All rights reserved.
//

#import "StartScene.h"
#import "ShaderLoader.h"
#import "BoundCircle.h"

@implementation StartScene{
    GLuint _spriteProgram;
    GLuint _simpleProgram;

    Sprite *_wireframeBtn;
    GLKTextureInfo *_wireFrameBtnTex;

    Sprite *_finger;
    GLKTextureInfo *_fingerTex;

    BoundCircle *_leftCircle;
    BoundCircle *_rightCircle;
    BoundCircle *_topCircle;
    BoundCircle *_underCircle;
    GLKTextureInfo *_circleTex;

    BOOL _isShowWireframe;
}

-(id)initScene {
    if(self = [super initScene]){
        _isShowWireframe = NO;

        //シェーダーの読み込み
        [ShaderLoader loadShaders:@"Sprite" program:&_spriteProgram options:TEX_SPRITE_OPTIONS];
        [ShaderLoader loadShaders:@"Simple" program:&_simpleProgram options:WIREFRAME_OPTIONS];

        //テクスチャ画像の読み込み
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"btn_wireframe" ofType:@"png"];
        _wireFrameBtnTex = [GLKTextureLoader textureWithContentsOfFile:filePath options:nil error:nil];

        filePath = [[NSBundle mainBundle] pathForResource:@"finger" ofType:@"png"];
        _fingerTex = [GLKTextureLoader textureWithContentsOfFile:filePath options:nil error:nil];

        filePath = [[NSBundle mainBundle] pathForResource:@"neko" ofType:@"png"];
        _circleTex = [GLKTextureLoader textureWithContentsOfFile:filePath options:nil error:nil];

        //ワイヤーフレーム表示・非表示ボタンの作成
        _wireframeBtn = [[Sprite alloc] initWithFrame:(CGRect){95.0f, 265.0f, 120.5, 24.5} texArea:(CGRect){0.0f, 0.5f, 1.0f, 0.5f}];
        _wireframeBtn.delegate = self;

        //タッチ位置の指の作成
        _finger = [[Sprite alloc] initWithFrame:(CGRect){0.0f, 0.0f, 45.0f, 48.0f}];
        _finger.visible = NO;

        _leftCircle = [[BoundCircle alloc] initWithPos:(GLKVector2){-100.0f, 0.0f} radius:50.0f];
        _rightCircle = [[BoundCircle alloc] initWithPos:(GLKVector2){100.0f, 0.0f} radius:50.0f];
        _topCircle = [[BoundCircle alloc] initWithPos:(GLKVector2){0.0f, 100.0f} radius:50.0f];
        _underCircle = [[BoundCircle alloc] initWithPos:(GLKVector2){0.0f, -100.0f} radius:50.0f];
    }
    return self;
}

-(void)updateScene:(NSDictionary *)data touchPos:(GLKVector2)touchPos isTouchStart:(BOOL)isTouchStart isTouching:(BOOL)isTouching isTouchEnd:(BOOL)isTouchEnd power:(float)power {
    [super updateScene:data touchPos:(GLKVector2)touchPos isTouchStart:(BOOL)isTouchStart isTouching:(BOOL)isTouching isTouchEnd:(BOOL)isTouchEnd power:(float)power];
    //ワイヤーフレーム表示・非表示ボタンの更新
    [_wireframeBtn updateWithTrans:(CGTrans){0.0f, 0.0f, 0.0f} rotate:(CGRotate){0.0f, 0.0f, 0.0f} scale:(CGScale){1.0f, 1.0f, 1.0f}];
    //ワイヤーフレーム表示・非表示ボタンのタッチ確認
    [_wireframeBtn touchCheck:touchPos isTouchStart:isTouchStart isTouching:isTouching isTouchEnd:isTouchEnd];

    //円の更新
    [_leftCircle updateWithTrans:(CGTrans){0.0f, 0.0f, 0.0f} rotate:(CGRotate){0.0f, 0.0f, 0.0f} scale:(CGScale){1.0f, 1.0f, 1.0f}];
    [_rightCircle updateWithTrans:(CGTrans){0.0f, 0.0f, 0.0f} rotate:(CGRotate){0.0f, 0.0f, 0.0f} scale:(CGScale){1.0f, 1.0f, 1.0f}];
    [_topCircle updateWithTrans:(CGTrans){0.0f, 0.0f, 0.0f} rotate:(CGRotate){0.0f, 0.0f, 0.0f} scale:(CGScale){1.0f, 1.0f, 1.0f}];
    [_underCircle updateWithTrans:(CGTrans){0.0f, 0.0f, 0.0f} rotate:(CGRotate){0.0f, 0.0f, 0.0f} scale:(CGScale){1.0f, 1.0f, 1.0f}];

    //弾み判定
    if(!_wireframeBtn.isTouching){
        [_leftCircle boundWithPos:touchPos isTouchStart:isTouchStart isTouching:isTouching isTouchEnd:isTouchEnd power:power];
        [_rightCircle boundWithPos:touchPos isTouchStart:isTouchStart isTouching:isTouching isTouchEnd:isTouchEnd power:power];
        [_topCircle boundWithPos:touchPos isTouchStart:isTouchStart isTouching:isTouching isTouchEnd:isTouchEnd power:power];
        [_underCircle boundWithPos:touchPos isTouchStart:isTouchStart isTouching:isTouching isTouchEnd:isTouchEnd power:power];
    }

    //タッチ位置の指の更新
    if(isTouching){
        _finger.visible = YES;
        [_finger updateWithTrans:(CGTrans){
                touchPos.x, touchPos.y, 0.0f
        } rotate:(CGRotate){0.0f, 0.0f, 0.0f} scale:(CGScale){1.0f, 1.0f, 1.0f}];
    }else if(isTouchEnd){
        _finger.visible = NO;
    }
}

-(void)drawScene {
    [super drawScene];

    //円の描画
    [_leftCircle drawWithTexInfo:_circleTex program:_spriteProgram alpha:1.0f];
    [_rightCircle drawWithTexInfo:_circleTex program:_spriteProgram alpha:1.0f];
    [_topCircle drawWithTexInfo:_circleTex program:_spriteProgram alpha:1.0f];
    [_underCircle drawWithTexInfo:_circleTex program:_spriteProgram alpha:1.0f];
    //ワイヤーフレームの描画
    if(_isShowWireframe){
        [_leftCircle drawWireframeWithProgram:_simpleProgram color:[UIColor redColor]];
        [_rightCircle drawWireframeWithProgram:_simpleProgram color:[UIColor redColor]];
        [_topCircle drawWireframeWithProgram:_simpleProgram color:[UIColor redColor]];
        [_underCircle drawWireframeWithProgram:_simpleProgram color:[UIColor redColor]];
    }

    //ワイヤーフレーム表示・非表示ボタンの描画
    [_wireframeBtn drawWithTexInfo:_wireFrameBtnTex program:_spriteProgram alpha:1.0f];

    //タッチ位置の指の描画
    [_finger drawWithTexInfo:_fingerTex program:_spriteProgram alpha:1.0f];
}

-(void)finishScene {
    [super finishScene];

    //テクスチャ破棄
    GLuint name = _wireFrameBtnTex.name;
    glDeleteTextures(1, &name);

    name = _fingerTex.name;
    glDeleteTextures(1, &name);

    name = _circleTex.name;
    glDeleteTextures(1, &name);

    //ワイヤーテクスチャボタン破棄
    [_wireframeBtn finish];

    //タッチ位置の指破棄
    [_finger finish];

    //円の破棄
    [_leftCircle finish];
    [_rightCircle finish];
    [_topCircle finish];
    [_underCircle finish];

    //プログラムの破棄
    if(_spriteProgram){
        glDeleteProgram(_spriteProgram);
        _spriteProgram = 0;
    }

    if(_simpleProgram){
        glDeleteProgram(_simpleProgram);
        _simpleProgram = 0;
    }
}

-(void)perform:(NSInteger)spriteID {
    if(spriteID == _wireframeBtn.spriteID){
        //テクスチャUVの変更処理
        if(_isShowWireframe){
            [_wireframeBtn updateVertexWithFrame:(CGRect){95.0f, 265.0f, 120.5, 24.5} texArea:(CGRect){0.0f, 0.5f, 1.0f, 0.5f}];
        }else{
            [_wireframeBtn updateVertexWithFrame:(CGRect){95.0f, 265.0f, 120.5, 24.5} texArea:(CGRect){0.0f, 0.0f, 1.0f, 0.5f}];
        }
        _isShowWireframe = !_isShowWireframe;
    }
}

-(void)touching:(NSInteger)spriteID {

}

-(void)touchEnd:(NSInteger)spriteID {

}

@end