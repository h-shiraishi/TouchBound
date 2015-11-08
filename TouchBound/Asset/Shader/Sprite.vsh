//
// Created by Edelweiss on 2015/11/06.
// Copyright (c) 2015 Edelweiss. All rights reserved.
//

attribute vec4 position;
attribute vec3 normal;
attribute vec2 uv;

varying lowp vec4 colorVarying;
varying lowp vec2 uvOut;

uniform mat4 modelViewProjectionMatrix;
uniform mat3 normalMatrix;
uniform vec4 diffuseColor;

void main()
{
    vec3 eyeNormal = normalize(normalMatrix * normal);
    vec3 lightPosition = vec3(0.0, 0.0, 1.0);
    
    float nDotVP = max(0.0, dot(eyeNormal, normalize(lightPosition)));
                 
    colorVarying = diffuseColor * nDotVP;
    
    uvOut = uv;
    
    gl_Position = modelViewProjectionMatrix * position;
}
