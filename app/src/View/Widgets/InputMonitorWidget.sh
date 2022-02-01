#!/usr/bin/env bash

@class InputMonitorWidget @implements Widget

    @var @inject InputDriver inputDriver
    @var @inject CanvasPrinter CanvasPrinter

    function InputMonitorWidget.initialize()
    {
        :
    }

    function InputMonitorWidget.calculateMinSize()
    {
        local calculator="${1}"


    }

    function InputMonitorWidget.draw()
    {
        local context="${1}"
        local canvas="${2}"
        local widgetsLayout="${3}"

        @let x = $context.x1
        @let y = $context.y1
        @let CanvasPrinter = $this.CanvasPrinter
        @let inputDriver = $this.inputDriver
        @let pressedKey = $inputDriver.keyboardPressedKey
        @let mouseX = $inputDriver.mouseX
        @let mouseY = $inputDriver.mouseY
        @let mouseButtonLeft = $inputDriver.mouseButtonLeft
        @let mouseButtonRight = $inputDriver.mouseButtonRight

        $CanvasPrinter.printText $canvas "${x}" "${y}" \
            "Keyboard: |${pressedKey}|  Mouse: |${mouseX}x${mouseY}  L:${mouseButtonLeft} R:${mouseButtonRight}|"
    }

@classdone



