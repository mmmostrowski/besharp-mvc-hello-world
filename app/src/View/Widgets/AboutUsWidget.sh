#!/usr/bin/env bash

@class AboutUsWidget @implements Widget WidgetWithSize

    @var @inject CanvasPrinter canvasPrinter

    function AboutUsWidget.initialize()
    {
        :
    }

    function AboutUsWidget.calculateMinSize()
    {
        local calculator="${1}"

        $calculator.setupSize 25 8
    }

    function AboutUsWidget.widgetWidth()
    {
        @returning 25
    }

    function AboutUsWidget.widgetHeight()
    {
        @returning 8
    }

    function AboutUsWidget.draw()
    {
        local context="${1}"
        local canvas="${2}"
        local widgetsLayout="${3}"

        @let canvasPrinter = $this.canvasPrinter
        @let x = $context.x1
        @let y = $context.y1

        @let bgColor = @pixel_modes.dGray
        @let txtColor = @pixel_modes.yellow

        $canvas.putPixelsBox $(( x )) $(( y )) 25 8 '.' "${bgColor}"


        $canvasPrinter.printText $canvas $(( x + 2 )) $(( y + 2 )) "BeSharp ( B# ${besharp_runtime_version} )" "${txtColor}"
        $canvasPrinter.printText $canvas  $(( x + 10 )) $(( y + 4 )) "by" "${txtColor}"
        $canvasPrinter.printText $canvas  $(( x + 4 )) $(( y + 6 )) "Maciej Ostrowski" "${txtColor}"
    }

@classdone



