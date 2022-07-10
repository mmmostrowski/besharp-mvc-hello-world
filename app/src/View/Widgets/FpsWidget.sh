#!/usr/bin/env bash

@class FpsWidget @implements Widget

    @var @inject CanvasPrinter CanvasPrinter

    @var fps = '?'
    @var frameCounter = 0
    @var lastSecond

    function FpsWidget.initialize()
    {
        $this.lastSecond = "$( date +%s < /dev/null )"
    }

    function FpsWidget.calculateMinSize()
    {
        local calculator="${1}"

    }

    function FpsWidget.draw()
    {
        local context="${1}"
        local canvas="${2}"
        local widgetsLayout="${3}"

        @let x = $context.x1
        @let y = $context.y1

        @let CanvasPrinter = $this.CanvasPrinter
        @let fps = $this.fps

        @let color = @pixel_modes.dGray

        $CanvasPrinter.printText $canvas "${x}" "${y}" "FPS ${fps}" "${color}"

        local currentSecond=""
        currentSecond="$( date +%s 2> /dev/null || true )"
        if [[ -z "${currentSecond}" ]]; then
            return
        fi

        @let frameCounter = $this.frameCounter
        @let lastSecond = $this.lastSecond
        (( ++frameCounter ))
        if (( currentSecond > lastSecond )); then
              $this.fps = $(( frameCounter / ( currentSecond - lastSecond ) ))
              $this.frameCounter = 0
              $this.lastSecond = "${currentSecond}"
        else
            $this.frameCounter = "${frameCounter}"
        fi
    }

@classdone



