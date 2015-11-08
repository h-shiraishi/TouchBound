//
// Created by Edelweiss on 2015/11/07.
// Copyright (c) 2015 Edelweiss. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GLSetting.h"

@interface ShaderLoader : NSObject

+(BOOL)loadShaders:(NSString *)shaderName program:(GLuint *)program options:(NSDictionary *)options;
+(BOOL)compileShader:(GLuint *)shader type:(GLenum)type file:(NSString *)file;
+(BOOL)linkProgram:(GLuint)program;
+(BOOL)validateProgram:(GLuint)program;

@end