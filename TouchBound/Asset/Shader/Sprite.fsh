//
// Created by Edelweiss on 2015/11/06.
// Copyright (c) 2015 Edelweiss. All rights reserved.
//

precision mediump float;

varying lowp vec4 colorVarying;
varying lowp vec2 uvOut;

uniform sampler2D u_texture;

void main()
{
    gl_FragColor = texture2D(u_texture, uvOut) * colorVarying;
}
