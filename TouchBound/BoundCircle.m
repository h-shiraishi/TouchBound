//
// Created by Edelweiss on 2015/11/08.
// Copyright (c) 2015 Edelweiss. All rights reserved.
//

#import "BoundCircle.h"
#import "CirclePoint.h"
#import "Bezier.h"
#import "Spring.h"
#import "Quaternion.h"
#import "SpriteManager.h"

#define DIVIDE_NUM 120
#define MAX_RADIUS 50.0f
#define MAX_POWER 30.0f
#define BEZIER_DIVIDE 40

@implementation BoundCircle {
    GLfloat *_gFaceVertexData;
    GLfloat *_gLineVertexData;
    NSMutableArray *_circlePoints;
    int _dataSize;
    GLKMatrix4 _modelViewProjectionMatrix;
    GLKMatrix3 _normalMatrix;
    GLuint _vertexArray;
    GLuint _vertexBuffer;
    GLuint _vertexLineArray;
    GLuint _vertexLineBuffer;

    CGTrans _trans;
    CGScale _scale;

    float _displayScale;
    float _renderWidth;
    float _renderHeight;

    Bezier *_bezier;
    Spring *_spring;
    float _prevPower;

    GLKVector2 _pos;
    float _radius;

    NSInteger _spriteID;
}

-(id)initWithPos:(GLKVector2)pos radius:(float)radius{
    if(self = [super init]){
        _renderWidth = [UIScreen mainScreen].bounds.size.width * [UIScreen mainScreen].scale;
        _renderHeight = [UIScreen mainScreen].bounds.size.height * [UIScreen mainScreen].scale;
        _displayScale = _renderWidth / 320.0f;
        _dataSize = 24 * DIVIDE_NUM;

        _vertexArray = 0;
        _vertexBuffer = 0;
        _vertexLineArray = 0;
        _vertexLineBuffer = 0;

        _gFaceVertexData = (GLfloat *)malloc(sizeof(GLfloat) * 8 * 3 * DIVIDE_NUM);
        _gLineVertexData = (GLfloat *)malloc(sizeof(GLfloat) * 6 * 2 * DIVIDE_NUM);

        //頂点情報の作成
        _circlePoints = [NSMutableArray array];
        float interval = 2.0f * M_PI / (float)DIVIDE_NUM;
        float tRadius = _displayScale * radius;
        for(int i = 0; i < DIVIDE_NUM; i++){
            float pointX = cosf(interval * (float)i);
            float pointY = sinf(interval * (float)i);
            CirclePoint *circlePoint = [[CirclePoint alloc] initWithPos:(GLKVector3){
                    tRadius * pointX, tRadius * pointY, 0.0f
            } uv:(GLKVector2){
                    0.5 * pointX + 0.5f, 0.5 * pointY + 0.5f
            }];
            [_circlePoints addObject:circlePoint];
        }

        _visible = YES;

        _bezier = [[Bezier alloc] initWithControl1:(ControlPoint){
                (GLKVector2){-1.0f, 0.0f},
                (GLKVector2){-1.0f, 0.8f}
        } control2:(ControlPoint){
                (GLKVector2){1.0f, 0.0f},
                (GLKVector2){1.0f, 0.8f}
        } divide:BEZIER_DIVIDE];

        _spriteID = [[SpriteManager manager] register];

        _pos = pos;
        _radius = radius;

        [self makeCircleData];
    }
    return self;
}

/**
 * 円情報の作成
 */
-(void)makeCircleData{
    if(_vertexBuffer != 0){
        glDeleteBuffers(1, &_vertexBuffer);
        glDeleteVertexArraysOES(1, &_vertexArray);
    }

    if(_vertexLineBuffer != 0){
        glDeleteBuffers(1, &_vertexLineBuffer);
        glDeleteVertexArraysOES(1, &_vertexLineArray);
    }

    for(int i = 0; i < DIVIDE_NUM; i++){
        _gFaceVertexData[i * 24]      = 0.0f;
        _gFaceVertexData[i * 24 +  1] = 0.0f;
        _gFaceVertexData[i * 24 +  2] = 0.0f;
        _gFaceVertexData[i * 24 +  3] = 0.0f;
        _gFaceVertexData[i * 24 +  4] = 0.0f;
        _gFaceVertexData[i * 24 +  5] = 1.0f;
        _gFaceVertexData[i * 24 +  6] = 0.5f;
        _gFaceVertexData[i * 24 +  7] = 0.5f;

        _gFaceVertexData[i * 24 +  8] = [_circlePoints[i] getPosition].x;
        _gFaceVertexData[i * 24 +  9] = [_circlePoints[i] getPosition].y;
        _gFaceVertexData[i * 24 + 10] = [_circlePoints[i] getPosition].z;
        _gFaceVertexData[i * 24 + 11] = [_circlePoints[i] getNormal].x;
        _gFaceVertexData[i * 24 + 12] = [_circlePoints[i] getNormal].y;
        _gFaceVertexData[i * 24 + 13] = [_circlePoints[i] getNormal].z;
        _gFaceVertexData[i * 24 + 14] = [_circlePoints[i] getUV].s;
        _gFaceVertexData[i * 24 + 15] = [_circlePoints[i] getUV].t;

        _gFaceVertexData[i * 24 + 16] = [_circlePoints[(i + 1) % DIVIDE_NUM] getPosition].x;
        _gFaceVertexData[i * 24 + 17] = [_circlePoints[(i + 1) % DIVIDE_NUM] getPosition].y;
        _gFaceVertexData[i * 24 + 18] = [_circlePoints[(i + 1) % DIVIDE_NUM] getPosition].z;
        _gFaceVertexData[i * 24 + 19] = [_circlePoints[(i + 1) % DIVIDE_NUM] getNormal].x;
        _gFaceVertexData[i * 24 + 20] = [_circlePoints[(i + 1) % DIVIDE_NUM] getNormal].y;
        _gFaceVertexData[i * 24 + 21] = [_circlePoints[(i + 1) % DIVIDE_NUM] getNormal].z;
        _gFaceVertexData[i * 24 + 22] = [_circlePoints[(i + 1) % DIVIDE_NUM] getUV].s;
        _gFaceVertexData[i * 24 + 23] = [_circlePoints[(i + 1) % DIVIDE_NUM] getUV].t;

        //ワイヤーフレームデータ
        //中心と現在点を結ぶ線
        _gLineVertexData[i * 12     ] = 0.0f;
        _gLineVertexData[i * 12 +  1] = 0.0f;
        _gLineVertexData[i * 12 +  2] = 0.0f;

        _gLineVertexData[i * 12 +  3] = [_circlePoints[i] getPosition].x;
        _gLineVertexData[i * 12 +  4] = [_circlePoints[i] getPosition].y;
        _gLineVertexData[i * 12 +  5] = [_circlePoints[i] getPosition].z;

        //現在点と次の点を結ぶの線
        _gLineVertexData[i * 12 +  6] = [_circlePoints[i] getPosition].x;
        _gLineVertexData[i * 12 +  7] = [_circlePoints[i] getPosition].y;
        _gLineVertexData[i * 12 +  8] = [_circlePoints[i] getPosition].z;

        _gLineVertexData[i * 12 +  9] = [_circlePoints[(i + 1) % DIVIDE_NUM] getPosition].x;
        _gLineVertexData[i * 12 + 10] = [_circlePoints[(i + 1) % DIVIDE_NUM] getPosition].y;
        _gLineVertexData[i * 12 + 11] = [_circlePoints[(i + 1) % DIVIDE_NUM] getPosition].z;
    }

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

    glGenVertexArraysOES(1, &_vertexLineArray);
    glBindVertexArrayOES(_vertexLineArray);

    glGenBuffers(1, &_vertexLineBuffer);
    glBindBuffer(GL_ARRAY_BUFFER, _vertexLineBuffer);
    glBufferData(GL_ARRAY_BUFFER, sizeof(GLfloat) * 12 * DIVIDE_NUM, _gLineVertexData, GL_STATIC_DRAW);

    glEnableVertexAttribArray(0);
    glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, 12, BUFFER_OFFSET(0));

    glBindVertexArrayOES(0);
}

-(void)updateWithTrans:(CGTrans)trans rotate:(CGRotate)rotate scale:(CGScale)scale {
    if (_visible) {
        _trans = trans;
        CGTrans pos = (CGTrans) {(_pos.x + trans.x) * _displayScale, (_pos.y + trans.y) * _displayScale, trans.z * _displayScale};
        _scale = scale;

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

-(void)drawWithTexInfo:(GLKTextureInfo *)texInfo program:(GLuint)program alpha:(float)alpha {
    if (_visible) {
        glEnable(GL_TEXTURE);

        glBindVertexArrayOES(_vertexArray);

        // Render the object again with ES2
        glUseProgram(program);
        glUniform1i(glGetUniformLocation(program, "u_texture"), 0);

        glActiveTexture(GL_TEXTURE0);
        glBindTexture(GL_TEXTURE_2D, texInfo.name);

        glUniformMatrix4fv(glGetUniformLocation(program, "modelViewProjectionMatrix"), 1, 0, _modelViewProjectionMatrix.m);
        glUniformMatrix3fv(glGetUniformLocation(program, "normalMatrix"), 1, 0, _normalMatrix.m);
        glUniform4f(glGetUniformLocation(program, "diffuseColor"), 1.0f, 1.0f, 1.0f, alpha);

        glDrawArrays(GL_TRIANGLES, 0, _dataSize / 8);

        glBindVertexArrayOES(0);

        glDisable(GL_TEXTURE);
    }
}

-(void)drawWireframeWithProgram:(GLuint)program color:(UIColor *)color {
    if (_visible) {
        glBindVertexArrayOES(_vertexLineArray);

        // Render the object again with ES2
        glUseProgram(program);

        glUniformMatrix4fv(glGetUniformLocation(program, "modelViewProjectionMatrix"), 1, 0, _modelViewProjectionMatrix.m);
        CGFloat red, green, blue, alpha;
        [color getRed:&red green:&green blue:&blue alpha:&alpha];
        glUniform4f(glGetUniformLocation(program, "diffuseColor"), red, green, blue, alpha);

        glLineWidth(3.0f);
        glDrawArrays(GL_LINES, 0, 4 * DIVIDE_NUM);

        glBindVertexArrayOES(0);
    }
}

-(void)finish {
    glDeleteBuffers(1, &_vertexBuffer);
    glDeleteBuffers(1, &_vertexLineBuffer);
    glDeleteVertexArraysOES(1, &_vertexArray);
    glDeleteVertexArraysOES(1, &_vertexLineArray);
    _vertexBuffer = 0;
    _vertexLineBuffer = 0;
    _vertexArray = 0;
    _vertexLineArray = 0;
    free(_gFaceVertexData);
    free(_gLineVertexData);
    [[SpriteManager manager] delete:_spriteID];
}

-(void)boundWithPos:(GLKVector2)pos isTouchStart:(BOOL)isTouchStart isTouching:(BOOL)isTouching isTouchEnd:(BOOL)isTouchEnd power:(float)power{
    BOOL isBounding = NO;

    GLKVector2 currentPos = (GLKVector2){_pos.x * _displayScale, _pos.y * _displayScale};
    GLKVector2 currentTouchPos = (GLKVector2){pos.x * _displayScale, pos.y * _displayScale};
    float currentRadius = _radius * _displayScale;

    float distance = (currentPos.x - currentTouchPos.x) * (currentPos.x - currentTouchPos.x) + (currentPos.y - currentTouchPos.y) * (currentPos.y - currentTouchPos.y);
    if(distance >= currentRadius * currentRadius){
        if(distance <= (currentRadius + MAX_RADIUS * _displayScale) * (currentRadius + MAX_RADIUS * _displayScale)){
            isBounding = YES;
        }
    }

    if(isTouching && isBounding){
        //タッチ位置から一番近い頂点を求めつつ、すべてのウェイトをリセットする
        _prevPower = power;
        float nearest = 9999.0f;
        int target = 0;
        for(int i = 0; i < DIVIDE_NUM; i++){
            GLfloat distance = [_circlePoints[i] getDistanceWithPos:(GLKVector2){currentTouchPos.x - currentPos.x, currentTouchPos.y - currentPos.y}];
            if(distance < nearest){
                nearest = distance;
                target = i;
            }
            [_circlePoints[i] setWeight:0.0f];
            [_circlePoints[i] culcCurrentPoint:0.0f rad:0.0f];
        }

        //一番近い頂点の更新
        GLKVector2 bezierPoint = [_bezier getPosition:BEZIER_DIVIDE / 2];

        _spring = [[Spring alloc] initWithPos:(GLKVector2){0.0f, bezierPoint.y * 100.0f} mass:1.0f];

        [_circlePoints[target] setWeight:bezierPoint.y];
        [_circlePoints[target] culcCurrentPoint:MAX_POWER * _displayScale * power rad:((float)target / (float)DIVIDE_NUM) * 2.0f * M_PI];

        //頂点から左右にBEZIER_DIVIDE頂点分の更新を行う
        for(int i = 1; i <= BEZIER_DIVIDE / 2; i++){
            bezierPoint = [_bezier getPosition:BEZIER_DIVIDE / 2 - i];
            [_circlePoints[(target - i + DIVIDE_NUM) % DIVIDE_NUM] setWeight:bezierPoint.y];
            [_circlePoints[(target - i + DIVIDE_NUM) % DIVIDE_NUM] culcCurrentPoint:MAX_POWER * _displayScale * power rad:((float)((target - i + DIVIDE_NUM) % DIVIDE_NUM) / (float)DIVIDE_NUM) * 2.0f * M_PI];

            bezierPoint = [_bezier getPosition:BEZIER_DIVIDE / 2 + i];
            [_circlePoints[(target + i + DIVIDE_NUM) % DIVIDE_NUM] setWeight:bezierPoint.y];
            [_circlePoints[(target + i + DIVIDE_NUM) % DIVIDE_NUM] culcCurrentPoint:MAX_POWER * _displayScale * power rad:((float)((target + i + DIVIDE_NUM) % DIVIDE_NUM) / (float)DIVIDE_NUM) * 2.0f * M_PI];
        }
        //円のバッファーデータを新しく作成する
        [self makeCircleData];
    }else{
        //バネのアニメーションをするためにタッチ中以外はアニメーションさせる
        GLKVector2 sprigPoint = [_spring updateWithTarget:(GLKVector2){0.0f, 100.0f}];
        for(int i = 0; i < DIVIDE_NUM; i++){
            [_circlePoints[i] multWieight:((100.0f - sprigPoint.y) / 100.0f)];
            [_circlePoints[i] culcCurrentPoint:MAX_POWER * _displayScale * _prevPower rad:((float)i / (float)DIVIDE_NUM) * 2.0f * M_PI];
        }
        //円のバッファーデータを新しく作成する
        [self makeCircleData];
    }
}

@end