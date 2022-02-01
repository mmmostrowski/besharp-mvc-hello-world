#!/usr/bin/env bash

@interface Canvas

    @interface function Canvas.initialize

    @interface function Canvas.setupMinimalSize

    @interface function Canvas.beginFrame

    @interface function Canvas.putPixel
    @interface function Canvas.putPixelModes
    @interface function Canvas.putPixelChar
    @interface function Canvas.putPixelsHoriz
    @interface function Canvas.putPixelsHorizChar
    @interface function Canvas.putPixelsHorizModes
    @interface function Canvas.putPixelsVert
    @interface function Canvas.putPixelsVertChar
    @interface function Canvas.putPixelsVertModes
    @interface function Canvas.putPixelsBox
    @interface function Canvas.putPixelsBoxChar
    @interface function Canvas.putPixelsBoxModes

    @interface function Canvas.render

@intdone