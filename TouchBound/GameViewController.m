//
//  GameViewController.m
//  TouchBound
//
//  Created by Edelweiss on 2015/11/01.
//  Copyright © 2015年 Edelweiss. All rights reserved.
//

#import "GameViewController.h"
#import <OpenGLES/ES2/glext.h>
#import "StartScene.h"

@interface GameViewController () {
    CGPoint _touchPos;
    BOOL _isTouchStart;
    BOOL _isTouching;
    BOOL _isTouchEnd;

    CGFloat _touchForce;
    CGFloat _maxTouchForce;

    SceneBase *_startScene;
}
@property (strong, nonatomic) EAGLContext *context;
- (void)tearDownGL;
@end

@implementation GameViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _touchPos = CGPointZero;
    _isTouchStart = NO;
    _isTouching = NO;
    _isTouchEnd = NO;

    self.preferredFramesPerSecond = 60;
    self.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];

    if (!self.context) {
        NSLog(@"Failed to create ES context");
    }

    GLKView *view = (GLKView *) self.view;
    view.context = self.context;
    view.drawableDepthFormat = GLKViewDrawableDepthFormat24;
    view.contentScaleFactor = [UIScreen mainScreen].scale;

    [EAGLContext setCurrentContext:self.context];

    //シーンの初期化
    _startScene = [[StartScene alloc] initScene];
}

- (void)dealloc
{    
    [self tearDownGL];
    
    if ([EAGLContext currentContext] == self.context) {
        [EAGLContext setCurrentContext:nil];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

    if ([self isViewLoaded] && ([[self view] window] == nil)) {
        self.view = nil;
        
        [self tearDownGL];
        
        if ([EAGLContext currentContext] == self.context) {
            [EAGLContext setCurrentContext:nil];
        }
        self.context = nil;

        [_startScene finishScene];
    }

    // Dispose of any resources that can be recreated.
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)tearDownGL
{
    [EAGLContext setCurrentContext:self.context];
    
    [_startScene finishScene];
}

#pragma mark - GLKView and GLKViewController delegate methods

- (void)update
{
    CGFloat power = (_maxTouchForce > 0.0f) ? _touchForce / _maxTouchForce : 0.0f;
    //シーンの更新
    [_startScene updateScene:nil touchPos:(GLKVector2){_touchPos.x, _touchPos.y} isTouchStart:_isTouchStart isTouching:_isTouching isTouchEnd:_isTouchEnd power:power];
    
    //タッチスタートは１回のみ
    if(_isTouchStart)_isTouchStart = NO;
    //タッチエンドは１回のみ
    if(_isTouchEnd)_isTouchEnd = NO;
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    glClearColor(0.0f, 0.0f, 0.0f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    glEnable(GL_BLEND);
    glBlendFunc(GL_ONE, GL_ONE_MINUS_SRC_ALPHA);

    [_startScene drawScene];

    glDisable(GL_BLEND);
}

//タッチ開始
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    _isTouchStart = YES;
    _isTouching = YES;

    UITouch *touch = [touches anyObject];
    _touchPos = [touch locationInView:self.view];
    _touchPos.x = _touchPos.x - self.view.frame.size.width * 0.5f;
    _touchPos.y = _touchPos.y - self.view.frame.size.height * 0.5f;

    //幅320の画面でタッチ位置を修正
    _touchPos = (CGPoint){
            _touchPos.x * (320 / [UIScreen mainScreen].bounds.size.width),
            _touchPos.y * (320 / [UIScreen mainScreen].bounds.size.width)
    };
}

//タッチ中
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    _isTouching = YES;

    UITouch *touch = [touches anyObject];
    _touchPos = [touch locationInView:self.view];
    _touchPos.x = _touchPos.x - self.view.frame.size.width * 0.5f;
    _touchPos.y = _touchPos.y - self.view.frame.size.height * 0.5f;

    //幅320の画面でタッチ位置を修正
    _touchPos = (CGPoint){
            _touchPos.x * (320 / [UIScreen mainScreen].bounds.size.width),
            _touchPos.y * (320 / [UIScreen mainScreen].bounds.size.width)
    };

    //forceのプロパティがある場合、画面を押す力を取得
    if(touch.force){
        _touchForce = touch.force;
        _maxTouchForce = touch.maximumPossibleForce;
    }
}

//タッチ終了
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    _isTouchEnd = YES;
    _isTouching = NO;

    UITouch *touch = [touches anyObject];
    _touchPos = [touch locationInView:self.view];
    _touchPos.x = _touchPos.x - self.view.frame.size.width * 0.5f;
    _touchPos.y = _touchPos.y - self.view.frame.size.height * 0.5f;

    //幅320の画面でタッチ位置を修正
    _touchPos = (CGPoint){
            _touchPos.x * (320 / [UIScreen mainScreen].bounds.size.width),
            _touchPos.y * (320 / [UIScreen mainScreen].bounds.size.width)
    };

    if(touch.force){
        _touchForce = 0.0f;
    }
}

@end
