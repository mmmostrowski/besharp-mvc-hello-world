#!/usr/bin/env bash

@class HelloWorldWidget @implements Widget WidgetWithSize StatefulWidget

    @var @inject CanvasPrinter canvasPrinter

    @var WidgetStateKeeper state

    @var boldFormat = ''

    @var format = ''

    function HelloWorldWidget.initialize()
    {
        @let $this.boldFormat = @pixel_modes.bold
    }

    function HelloWorldWidget.bindWidgetState()
    {
        $this.state = "${1}"
    }

    function HelloWorldWidget.widgetWidth()
    {
        @let text = $this.text

        @returning "${#text}"
    }

    function HelloWorldWidget.widgetHeight()
    {
        @returning 1
    }

    function HelloWorldWidget.calculateMinSize()
    {
        local calculator="${1}"

        @let text = $this.text

        $calculator.setupSize "${#text}" 1
    }

    function HelloWorldWidget.text()
    {
        @let state = $this.state

        @let greeting = $state.readWidgetState $this 'greeting' ''
        @let suffix = $state.readWidgetState $this 'suffix' ''
        @let subject = $state.readWidgetState $this 'subject' ''

        @returning "${greeting} ${subject} ${suffix}"
    }

    function HelloWorldWidget.isBoldEnabled()
    {
        @let state = $this.state

        @returning @of $state.readWidgetState $this 'boldEnabled' 'false'
    }

    function HelloWorldWidget.isColorsEnabled()
    {
        @let state = $this.state

        @returning @of $state.readWidgetState $this 'colorsEnabled' 'false'
    }

    function HelloWorldWidget.draw()
    {
        local context="${1}"
        local canvas="${2}"
        local widgetsLayout="${3}"

        @let canvasPrinter = $this.canvasPrinter
        @let state = $this.state
        @let text = $this.text
        @let x = $context.x1
        @let y = $context.y1


        if @true $this.isBoldEnabled; then
            @let format = $this.boldFormat
        else
            @let format = $this.format
        fi

        if @true $this.isColorsEnabled; then
            local i
            for (( i=0; i < ${#text}; ++i )); do
                @let color = @pixel_modes.randomColor
                $canvas.putPixel "$(( x++ ))" "${y}" "${text:$i:1}" "${format}${color}"
            done
        else
            $canvasPrinter.printText $canvas "${x}" "${y}" "${text}" "${format}"
        fi
    }

@classdone



