//
// Created by Edelweiss on 2015/11/05.
// Copyright (c) 2015 Edelweiss. All rights reserved.
//

#import "Quaternion.h"


@implementation Quaternion

+ (GLKMatrix4)quatToMatrix:(Quat)lpQ {
    float qw, qx, qy, qz;
    float x2, y2, z2;
    float xy, yz, zx;
    float wx, wy, wz;

    qw = lpQ.w;
    qx = lpQ.x;
    qy = lpQ.y;
    qz = lpQ.z;

    x2 = 2.0f * qx * qx;
    y2 = 2.0f * qy * qy;
    z2 = 2.0f * qz * qz;

    xy = 2.0f * qx * qy;
    yz = 2.0f * qy * qz;
    zx = 2.0f * qz * qx;

    wx = 2.0f * qw * qx;
    wy = 2.0f * qw * qy;
    wz = 2.0f * qw * qz;

    return GLKMatrix4Make(
            1.0f - y2 - z2, xy - wz, zx + wy, 0.0f,
            xy + wz, 1.0f - z2 - x2, yz - wx, 0.0f,
            zx - wy, yz + wx, 1.0f - x2 - y2, 0.0f,
            0.0f, 0.0f, 0.0f, 1.0f
    );
}

+(Quat)quatMultWithQuatP:(Quat)lpP quatQ:(Quat)lpQ {
    float pw, px, py, pz;
    float qw, qx, qy, qz;

    pw = lpP.w; px = lpP.x; py = lpP.y; pz = lpP.z;
    qw = lpQ.w; qx = lpQ.x; qy = lpQ.y; qz = lpQ.z;

    return (Quat){
            .w = pw * qw - px * qx - py * qy - pz * qz,
            .x = pw * qx + px * qw + py * qz - pz * qy,
            .y = pw * qy - px * qz + py * qw + pz * qx,
            .z = pw * qz + px * qy - py * qx + pz * qw
    };
}

+(GLKVector3)quatNormalize:(GLKVector3)vec {
    float length = sqrtf(vec.x * vec.x + vec.y * vec.y + vec.z * vec.z);
    if(length == 0.0f){
        return vec;
    }

    return GLKVector3Make(
            vec.x / length, vec.y / length, vec.z / length
    );
}

+(Quat)quatRotateWithRad:(float)rad axis:(GLKVector3)axis{
    float hrad;
    float s;

    hrad = 0.5f * rad;
    s = sinf(hrad);

    return (Quat){
            .w = cosf(hrad), .x = s * axis.x, .y = s * axis.y, .z = s * axis.z
    };
}

@end