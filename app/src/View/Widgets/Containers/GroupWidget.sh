#!/usr/bin/env bash

@class GroupWidget @extends FrameWidget @implements StatefulWidget

    @var WidgetStateKeeper state

    function GroupWidget.bindWidgetState()
    {
        $this.state = "${1}"
    }

    function GroupWidget.text()
    {
        @let state = $this.state
        @returning @of $state.readWidgetState $this 'title' ''
    }

    function GroupWidget.calculateMinSize()
    {
        local calculator="${1}"

        @let composedWidget = $this.composedWidget
        $calculator.calculateMinSize $composedWidget

        $calculator.resizeWidthBy 4
        $calculator.resizeHeightBy 4

        @let text = $this.text
        $calculator.takeGreaterWidth $(( ${#text} + 6 ))
    }

    function GroupWidget.organizeChildrenOnLayout()
    {
        local context="${1}"
        local widgetsLayout="${2}"

        @let x1 = $context.x1
        @let y1 = $context.y1
        @let width = $context.width
        @let height = $context.height

        @let composedWidget = $this.composedWidget
        $widgetsLayout.setupContextWindow $composedWidget \
            $(( x1 + 2 )) $(( y1 + 2 )) $(( width - 4 )) $(( height - 4 )) \
        ;
    }

    function GroupWidget.draw()
    {
        local context="${1}"
        local canvas="${2}"
        local widgetsLayout="${3}"

        @parent "${@}"

        @let composedWidget = $this.composedWidget
        $widgetsLayout.drawWidget $composedWidget $canvas

        @let text = $this.text

        @let dimColor = @pixel_modes.dGray

        eval "
            local x1=\"\${${context}_x1}\"
            local y1=\"\${${context}_y1}\"
            local width=\"\${${context}_width}\"
            local height=\"\${${context}_height}\"
            local canvasPrinter=\"\${${this}_canvasPrinter}\"
        "

        if @true $context.isHighlighted; then
            $canvasPrinter.printText $canvas $(( x1 + 2 )) $(( y1 )) " ${text^^} "
        else
            $canvasPrinter.printText $canvas $(( x1 + 2 )) $(( y1 )) " ${text} " "${dimColor}"
        fi
    }

@classdone