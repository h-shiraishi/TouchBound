//
// Created by Edelweiss on 2015/11/06.
// Copyright (c) 2015 Edelweiss. All rights reserved.
//

attribute vec4 position;

varying lowp vec4 colorVarying;

uniform mat4 modelViewProjectionMatrix;
uniform vec4 diffuseColor;

void main()
{
    
    colorVarying = diffuseColor;
    
    gl_Position = modelViewProjectionMatrix * position;
}
