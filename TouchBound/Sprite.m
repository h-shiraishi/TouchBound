//
//  Sprite.m
//  TouchBound
//
//  Created by Edelweiss on 2015/11/01.
//  Copyright © 2015年 Edelweiss. All rights reserved.
//

#import "Sprite.h"
#import "Quaternion.h"
#import "SpriteManager.h"

@implementation Sprite{
    GLfloat *_gFaceVertexData;             //データ
    int _dataSize;                         //データサイズ
    GLKMatrix4 _modelViewProjectionMatrix; //変換行列
    GLKMatrix3 _normalMatrix;              //法線行列
    GLuint _vertexArray;                   //頂点データ
    GLuint _vertexBuffer;                  //バッファーデータ
    CGRect _frame;                         //フレーム
    CGRect _texArea;                       //UV

    CGTrans _trans;                        //並行移動
    CGScale _scale;                        //拡大

    float _displayScale;                   //ディスプレイ拡大率
    float _renderWidth;                    //レンダリング幅
    float _renderHeight;                   //レンダリング高さ

    TouchType _type;                       //タッチしたときの挙動
    TouchingMode _mode;                    //タッチしているときの挙動
}

- (id)initWithFrame:(CGRect)frame texArea:(CGRect)texArea type:(TouchType)type mode:(TouchingMode)mode {
    if (self = [super init]) {
        _renderWidth = [UIScreen mainScreen].bounds.size.width * [UIScreen mainScreen].scale;
        _renderHeight = [UIScreen mainScreen].bounds.size.height * [UIScreen mainScreen].scale;
        _displayScale = _renderWidth / 320.0f;
        _dataSize = 48;

        _vertexArray = 0;
        _vertexBuffer = 0;

        _gFaceVertexData = (GLfloat *) malloc(sizeof(GLfloat) * _dataSize);
        _gFaceVertexData[0] = frame.size.width * 0.5f * _displayScale;
        _gFaceVertexData[1] = frame.size.height * 0.5f * _displayScale;
        _gFaceVertexData[2] = 0.0f;
        _gFaceVertexData[3] = 0.0f;
        _gFaceVertexData[4] = 0.0f;
        _gFaceVertexData[5] = 1.0f;
        _gFaceVertexData[6] = texArea.origin.x + texArea.size.width;
        _gFaceVertexData[7] = texArea.origin.y + texArea.size.height;

        _gFaceVertexData[8] = -frame.size.width * 0.5f * _displayScale;
        _gFaceVertexData[9] = frame.size.height * 0.5f * _displayScale;
        _gFaceVertexData[10] = 0.0f;
        _gFaceVertexData[11] = 0.0f;
        _gFaceVertexData[12] = 0.0f;
        _gFaceVertexData[13] = 1.0f;
        _gFaceVertexData[14] = texArea.origin.x;
        _gFaceVertexData[15] = texArea.origin.y + texArea.size.height;

        _gFaceVertexData[16] = frame.size.width * 0.5f * _displayScale;
        _gFaceVertexData[17] = -frame.size.height * 0.5f * _displayScale;
        _gFaceVertexData[18] = 0.0f;
        _gFaceVertexData[19] = 0.0f;
        _gFaceVertexData[20] = 0.0f;
        _gFaceVertexData[21] = 1.0f;
        _gFaceVertexData[22] = texArea.origin.x + texArea.size.width;
        _gFaceVertexData[23] = texArea.origin.y;

        _gFaceVertexData[24] = -frame.size.width * 0.5f * _displayScale;
        _gFaceVertexData[25] = frame.size.height * 0.5f * _displayScale;
        _gFaceVertexData[26] = 0.0f;
        _gFaceVertexData[27] = 0.0f;
        _gFaceVertexData[28] = 0.0f;
        _gFaceVertexData[29] = 1.0f;
        _gFaceVertexData[30] = texArea.origin.x;
        _gFaceVertexData[31] = texArea.origin.y + texArea.size.height;

        _gFaceVertexData[32] = -frame.size.width * 0.5f * _displayScale;
        _gFaceVertexData[33] = -frame.size.height * 0.5f * _displayScale;
        _gFaceVertexData[34] = 0.0f;
        _gFaceVertexData[35] = 0.0f;
        _gFaceVertexData[36] = 0.0f;
        _gFaceVertexData[37] = 1.0f;
        _gFaceVertexData[38] = texArea.origin.x;
        _gFaceVertexData[39] = texArea.origin.y;

        _gFaceVertexData[40] = frame.size.width * 0.5f * _displayScale;
        _gFaceVertexData[41] = -frame.size.height * 0.5f * _displayScale;
        _gFaceVertexData[42] = 0.0f;
        _gFaceVertexData[43] = 0.0f;
        _gFaceVertexData[44] = 0.0f;
        _gFaceVertexData[45] = 1.0f;
        _gFaceVertexData[46] = texArea.origin.x + texArea.size.width;
        _gFaceVertexData[47] = texArea.origin.y;

        glGenVertexArraysOES(1, &_vertexArray);
        glBindVertexArrayOES(_vertexArray);

        glGenBuffers(1, &_vertexBuffer);
        glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer);
        glBufferData(GL_ARRAY_BUFFER, sizeof(GLfloat) * _dataSize, _gFaceVertexData, GL_STATIC_DRAW);

        glEnableVertexAttribArray(0);
        glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, 32, BUFFER_OFFSET(0));
        glEnableVertexAttribArray(1);
        glVertexAttribPointer(1, 3, GL_FLOAT, GL_FALSE, 32, BUFFER_OFFSET(12));
        glEnableVertexAttribArray(2);
        glVertexAttribPointer(2, 2, GL_FLOAT, GL_FALSE, 32, BUFFER_OFFSET(24));

        glBindVertexArrayOES(0);

        _frame = frame;
        _texArea = texArea;

        _type = type;
        _mode = mode;

        _visible = YES;
        _enableTouch = YES;

        _isSpriteTouching = NO;

        _spriteID = [[SpriteManager manager] register];
    }

    return self;
}

- (id)initWithFrame:(CGRect)frame texArea:(CGRect)texArea {
    return [self initWithFrame:frame texArea:texArea type:TOUCH_UP_INSIDE mode:CHANGE_MOVE];
}

- (id)initWithFrame:(CGRect)frame {
    return [self initWithFrame:frame texArea:(CGRect) {0.0f, 0.0f, 1.0f, 1.0f}];
}

- (void)updateWithTrans:(CGTrans)trans rotate:(CGRotate)rotate scale:(CGScale)scale {
    if (_visible) {
        _trans = trans;
        CGTrans pos = (CGTrans) {(_frame.origin.x + trans.x) * _displayScale, (_frame.origin.y + trans.y) * _displayScale, trans.z * _displayScale};
        _scale = scale;

        //タッチ中にスプライトをずらす処理
        if (_type == TOUCH_UP_INSIDE && _mode == CHANGE_MOVE && _isSpriteTouching) {
            pos.x += 6.0f;
            pos.y += 6.0f;
        }

        GLKVector3 axis = GLKVector3Make(1.0f, 0.0f, 0.0f);
        Quat mdlQtn = (Quat) {1.0f, 0.0f, 0.0f, 0.0f};
        Quat dqtn;

        //X軸回転
        axis = [Quaternion quatNormalize:axis];
        dqtn = [Quaternion quatRotateWithRad:M_PI * (float) rotate.x / 180.0f axis:axis];
        mdlQtn = [Quaternion quatMultWithQuatP:dqtn quatQ:mdlQtn];

        //Y軸回転
        axis = GLKVector3Make(0.0f, 1.0f, 0.0f);
        axis = [Quaternion quatNormalize:axis];
        dqtn = [Quaternion quatRotateWithRad:M_PI * (float) rotate.y / 180.0f axis:axis];
        mdlQtn = [Quaternion quatMultWithQuatP:dqtn quatQ:mdlQtn];

        //Z軸回転
        axis = GLKVector3Make(0.0f, 0.0f, 1.0f);
        axis = [Quaternion quatNormalize:axis];
        dqtn = [Quaternion quatRotateWithRad:M_PI * (float) rotate.z / 180.0f axis:axis];
        mdlQtn = [Quaternion quatMultWithQuatP:dqtn quatQ:mdlQtn];

        //回転行列
        GLKMatrix4 rotMat = [Quaternion quatToMatrix:mdlQtn];

        GLKMatrix4 projectionMatrix = GLKMatrix4MakeOrtho(-_renderWidth * 0.5f, _renderWidth * 0.5f, _renderHeight * 0.5f, -_renderHeight * 0.5f, -100, 100);
        GLKMatrix4 modelViewMatrix = GLKMatrix4MakeTranslation(pos.x, pos.y, pos.z);
        modelViewMatrix = GLKMatrix4Multiply(modelViewMatrix, rotMat);
        modelViewMatrix = GLKMatrix4Scale(modelViewMatrix, _scale.x, _scale.y, _scale.z);

        _normalMatrix = GLKMatrix3InvertAndTranspose(GLKMatrix4GetMatrix3(modelViewMatrix), NULL);

        _modelViewProjectionMatrix = GLKMatrix4Multiply(projectionMatrix, modelViewMatrix);

    }
}

- (void)touchCheck:(GLKVector2)touchPos isTouchStart:(BOOL)isTouchStart isTouching:(BOOL)isTouching isTouchEnd:(BOOL)isTouchEnd {
    //タッチなしでない かつ 表示中 かつ タッチ可能
    if (_type != TOUCH_NONE && _visible && _enableTouch) {
        float currentPosX = (_frame.origin.x + _trans.x) * _displayScale;
        float currentPosY = (_frame.origin.y + _trans.y) * _displayScale;
        float currentWidth = _frame.size.width * _displayScale;
        float currentHeight = _frame.size.height * _displayScale;
        GLKVector2 currentTouchPos = (GLKVector2){touchPos.x * _displayScale, touchPos.y * _displayScale};

        if (_isSpriteTouching) {
            if (isTouching) {
                //タッチ中に範囲外に出たら、実行しない
                if (currentTouchPos.x > currentPosX + currentWidth * 0.5f || currentTouchPos.x < currentPosX - currentWidth * 0.5f || currentTouchPos.y > currentPosY + currentHeight * 0.5f || currentTouchPos.y < currentPosY - currentHeight * 0.5f) {
                    _isSpriteTouching = NO;
//                    if(_mode == CHANGE_TEX){
//
//                    }
                    if([self.delegate respondsToSelector:@selector(touchEnd:)]){
                        [self.delegate touchEnd:_spriteID];
                    }
                }else{
                    if([self.delegate respondsToSelector:@selector(touching:)]){
                        [self.delegate touching:_spriteID];
                    }
                }
            } else if (isTouchEnd) {
                //タッチが終わった位置が範囲内のときに実行
                if (currentTouchPos.x <= currentPosX + currentWidth * 0.5f && currentTouchPos.x >= currentPosX - currentWidth * 0.5f && currentTouchPos.y <= currentPosY + currentHeight * 0.5f && currentTouchPos.y >= currentPosY - currentHeight * 0.5f) {
                    if ([self.delegate respondsToSelector:@selector(perform:)]) {
                        [self.delegate perform:_spriteID];
                    }

                }else{
                    if([self.delegate respondsToSelector:@selector(touchEnd:)]){
                        [self.delegate touchEnd:_spriteID];
                    }
                }
                _isSpriteTouching = NO;
//                if(_mode == CHANGE_TEX){
//
//                }
            }
        } else {
            if (isTouchStart) {
                if (currentTouchPos.x <= currentPosX + currentWidth * 0.5f && currentTouchPos.x >= currentPosX - currentWidth * 0.5f && currentTouchPos.y <= currentPosY + currentHeight * 0.5f && currentTouchPos.y >= currentPosY - currentHeight * 0.5f) {
                    if (_type == TOUCH_DOWN) {
                        //タッチ直後に実行
                        if ([self.delegate respondsToSelector:@selector(perform:)]) {
                            [self.delegate perform:_spriteID];
                        }
                    } else {
                        _isSpriteTouching = YES;
//                        if (_mode == CHANGE_TEX){
//
//                        }
                        if([self.delegate respondsToSelector:@selector(touching:)]){
                            [self.delegate touching:_spriteID];
                        }
                    }
                }
            }
        }
    }
}

- (void)drawWithTexInfo:(GLKTextureInfo *)texInfo program:(GLuint)program alpha:(float)alpha {
    if (_visible) {
        glEnable(GL_TEXTURE);

        glBindVertexArrayOES(_vertexArray);

        glUseProgram(program);
        glUniform1i(glGetUniformLocation(program, "u_texture"), 0);

        glActiveTexture(GL_TEXTURE0);
        glBindTexture(GL_TEXTURE_2D, texInfo.name);

        glUniformMatrix4fv(glGetUniformLocation(program, "modelViewProjectionMatrix"), 1, 0, _modelViewProjectionMatrix.m);
        glUniformMatrix3fv(glGetUniformLocation(program, "normalMatrix"), 1, 0, _normalMatrix.m);
        float cAlpha = alpha;
        if (_type == TOUCH_UP_INSIDE && _mode == CHANGE_COLOR && _isSpriteTouching) {
            cAlpha *= 0.6f;
        }
        glUniform4f(glGetUniformLocation(program, "diffuseColor"), 1.0f, 1.0f, 1.0f, cAlpha);

        glDrawArrays(GL_TRIANGLES, 0, _dataSize / 8);
        glBindVertexArrayOES(0);

        glDisable(GL_TEXTURE);
    }
}

- (void)finish {
    glDeleteBuffers(1, &_vertexBuffer);
    glDeleteVertexArraysOES(1, &_vertexArray);
    free(_gFaceVertexData);
    [[SpriteManager manager] delete:_spriteID];
}

-(void)updateVertexWithFrame:(CGRect)frame texArea:(CGRect)texArea {
    glDeleteBuffers(1, &_vertexBuffer);
    glDeleteVertexArraysOES(1, &_vertexArray);

    _gFaceVertexData[0] = frame.size.width * 0.5f * _displayScale;
    _gFaceVertexData[1] = frame.size.height * 0.5f * _displayScale;
    _gFaceVertexData[2] = 0.0f;
    _gFaceVertexData[3] = 0.0f;
    _gFaceVertexData[4] = 0.0f;
    _gFaceVertexData[5] = 1.0f;
    _gFaceVertexData[6] = texArea.origin.x + texArea.size.width;
    _gFaceVertexData[7] = texArea.origin.y + texArea.size.height;

    _gFaceVertexData[8] = -frame.size.width * 0.5f * _displayScale;
    _gFaceVertexData[9] = frame.size.height * 0.5f * _displayScale;
    _gFaceVertexData[10] = 0.0f;
    _gFaceVertexData[11] = 0.0f;
    _gFaceVertexData[12] = 0.0f;
    _gFaceVertexData[13] = 1.0f;
    _gFaceVertexData[14] = texArea.origin.x;
    _gFaceVertexData[15] = texArea.origin.y + texArea.size.height;

    _gFaceVertexData[16] = frame.size.width * 0.5f * _displayScale;
    _gFaceVertexData[17] = -frame.size.height * 0.5f * _displayScale;
    _gFaceVertexData[18] = 0.0f;
    _gFaceVertexData[19] = 0.0f;
    _gFaceVertexData[20] = 0.0f;
    _gFaceVertexData[21] = 1.0f;
    _gFaceVertexData[22] = texArea.origin.x + texArea.size.width;
    _gFaceVertexData[23] = texArea.origin.y;

    _gFaceVertexData[24] = -frame.size.width * 0.5f * _displayScale;
    _gFaceVertexData[25] = frame.size.height * 0.5f * _displayScale;
    _gFaceVertexData[26] = 0.0f;
    _gFaceVertexData[27] = 0.0f;
    _gFaceVertexData[28] = 0.0f;
    _gFaceVertexData[29] = 1.0f;
    _gFaceVertexData[30] = texArea.origin.x;
    _gFaceVertexData[31] = texArea.origin.y + texArea.size.height;

    _gFaceVertexData[32] = -frame.size.width * 0.5f * _displayScale;
    _gFaceVertexData[33] = -frame.size.height * 0.5f * _displayScale;
    _gFaceVertexData[34] = 0.0f;
    _gFaceVertexData[35] = 0.0f;
    _gFaceVertexData[36] = 0.0f;
    _gFaceVertexData[37] = 1.0f;
    _gFaceVertexData[38] = texArea.origin.x;
    _gFaceVertexData[39] = texArea.origin.y;

    _gFaceVertexData[40] = frame.size.width * 0.5f * _displayScale;
    _gFaceVertexData[41] = -frame.size.height * 0.5f * _displayScale;
    _gFaceVertexData[42] = 0.0f;
    _gFaceVertexData[43] = 0.0f;
    _gFaceVertexData[44] = 0.0f;
    _gFaceVertexData[45] = 1.0f;
    _gFaceVertexData[46] = texArea.origin.x + texArea.size.width;
    _gFaceVertexData[47] = texArea.origin.y;

    glGenVertexArraysOES(1, &_vertexArray);
    glBindVertexArrayOES(_vertexArray);

    glGenBuffers(1, &_vertexBuffer);
    glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer);
    glBufferData(GL_ARRAY_BUFFER, sizeof(GLfloat) * _dataSize, _gFaceVertexData, GL_STATIC_DRAW);

    glEnableVertexAttribArray(0);
    glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, 32, BUFFER_OFFSET(0));
    glEnableVertexAttribArray(1);
    glVertexAttribPointer(1, 3, GL_FLOAT, GL_FALSE, 32, BUFFER_OFFSET(12));
    glEnableVertexAttribArray(2);
    glVertexAttribPointer(2, 2, GL_FLOAT, GL_FALSE, 32, BUFFER_OFFSET(24));

    glBindVertexArrayOES(0);

    _frame = frame;
    _texArea = texArea;
}

@end
