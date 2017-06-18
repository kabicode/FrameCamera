//
//  ViewController.m
//  LearnOpenGLESWithGPUImage
//
//  Created by loyinglin on 16/5/10.
//  Copyright © 2016年 loyinglin. All rights reserved.
//

attribute vec4 position;
attribute vec2 texCoord;
attribute vec2 sampleCoord;

varying vec2 texCoordVarying;
varying vec2 sampleCoordVarying;

void main()
{
    gl_Position = position;
    texCoordVarying = texCoord;
    sampleCoordVarying = sampleCoord;
}

