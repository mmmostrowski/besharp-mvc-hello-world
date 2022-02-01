#!/usr/bin/env bash

@class FrameWidget @implements Widget ContainerWidget

    @var @inject CanvasPrinter canvasPrinter

    @var Widget composedWidget
    @var Vector children


    function FrameWidget()
    {
        $this.composedWidget = "${1}"
        @let $this.children = @vectors.single "${1}"
    }

    function FrameWidget.initialize()
    {
      :
    }

    function FrameWidget.calculateMinSize()
    {
        local calculator="${1}"

        @let composedWidget = $this.composedWidget
        $calculator.calculateMinSize $composedWidget

        $calculator.resizeWidthBy 2
        $calculator.resizeHeightBy 2
    }

    function FrameWidget.childrenWidgets()
    {
        @returning @of $this.children
    }

    function FrameWidget.operativeChildrenWidget()
    {
        @returning @of $this.children
    }

    function FrameWidget.organizeChildrenOnLayout()
    {
        local context="${1}"
        local widgetsLayout="${2}"

        @let x1 = $context.x1
        @let y1 = $context.y1
        @let width = $context.width
        @let height = $context.height

        @let composedWidget = $this.composedWidget
        $widgetsLayout.setupContextWindow $composedWidget \
            "$(( x1 + 1 ))" "$(( y1 + 1 ))" "$(( width - 2 ))" "$(( height - 2 ))" \
        ;
    }

    function FrameWidget.draw()
    {
        local context="${1}"
        local canvas="${2}"
        local widgetsLayout="${3}"

        @let composedWidget = $this.composedWidget
        $widgetsLayout.drawWidget $composedWidget $canvas

        eval "
            local x1=\"\${${context}_x1}\"
            local y1=\"\${${context}_y1}\"
            local width=\"\${${context}_width}\"
            local height=\"\${${context}_height}\"
            local canvasPrinter=\"\${${this}_canvasPrinter}\"
        "

        if @true $context.isHighlighted; then
            $canvasPrinter.printHighlightFrame $canvas "${x1}" "${y1}" "${width}" "${height}"
        else
            $canvasPrinter.printFrame $canvas "${x1}" "${y1}" "${width}" "${height}"
        fi
    }

@classdone