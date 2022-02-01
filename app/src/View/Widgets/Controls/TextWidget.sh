#!/usr/bin/env bash

@class TextWidget @implements Widget WidgetWithSize StatefulWidget

    @var @inject CanvasPrinter canvasPrinter

    @var WidgetStateKeeper state

    function TextWidget.bindWidgetState()
    {
        $this.state = "${1}"
    }

    function TextWidget.initialize()
    {
        :
    }

    function TextWidget.text()
    {
        @let state = $this.state
        @returning @of $state.readWidgetState $this 'text' ''
    }

    function TextWidget.color()
    {
        @let state = $this.state
        @returning @of $state.readWidgetState $this 'color' ''
    }

    function TextWidget.widgetWidth()
    {
        @let text = $this.text

        @returning "${#text}"
    }

    function TextWidget.widgetHeight()
    {
        @returning 1
    }

    function TextWidget.calculateMinSize()
    {
        local calculator="${1}"

        @let text = $this.text

        local line
        local linesCount=0
        while IFS= read -r line; do
            $calculator.takeGreaterWidth "${#line}"
            (( ++linesCount ))
        done<<<"${text}"
        $calculator.takeGreaterHeight ${linesCount}
    }

    function TextWidget.draw()
    {
        local context="${1}"
        local canvas="${2}"
        local widgetsLayout="${3}"

        @let text = $this.text
        @let color = $this.color
        @let x = $context.x1
        @let y = $context.y1

        if [[ -n "${color}" ]]; then
            @let color = @pixel_modes.${color}
        fi

        @let canvasPrinter = $this.canvasPrinter

        local line
        while IFS= read -r line; do
            $canvasPrinter.printSparseText $canvas "${x}" "$(( y++ ))" "${line}" ${color}
        done<<<"${text}"
    }

@classdone



