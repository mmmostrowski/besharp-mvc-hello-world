#!/usr/bin/env bash

@class ButtonWidget @implements Widget WidgetWithSize StatefulWidget FocusableWidget AnimatedWidget LayoutChangesListeningWidget

    @var @inject CanvasPrinter canvasPrinter

    @var WidgetStateKeeper state

    @var clickAnimationFrame = 0
    @var isActionRequested = false
    @var Vector clickAnimationDataStart
    @var Vector clickAnimationDataLength


    function ButtonWidget.initialize()
    {
        @let $this.clickAnimationDataStart = @vectors.make
        @let $this.clickAnimationDataLength = @vectors.make
    }

    function ButtonWidget.initializeAnimation()
    {
      :
    }

    function ButtonWidget.processAnimationFrame()
    {
        @let clickAnimationFrame = $this.clickAnimationFrame
        $this.clickAnimationFrame = $(( --clickAnimationFrame ))

        if (( clickAnimationFrame == 1 )); then
            if @true $this.isActionRequested; then
                 $this.isActionRequested = fale
                 @let state = $this.state
                 $state.requestWidgetEvent $this 'clicked'
            fi
        fi
        @returning "${clickAnimationFrame}"
    }

    function ButtonWidget.bindWidgetState()
    {
        $this.state = "${1}"
    }

    function ButtonWidget.text()
    {
        @let state = $this.state
        @returning @of $state.readWidgetState $this 'text' ''
    }

    function ButtonWidget.processKeyboardEvent()
    {
        local event="${1}"

        if @true $this.isActionRequested; then
            return
        fi

        if @true $event.consumeWhenCommandRequested 'action'; then
            @let state = $this.state
            $this.isActionRequested = true
            $this.clickAnimationFrame = 4
        fi
    }

    function ButtonWidget.processLayoutChanges()
    {
        local context="${1}"
        local layout="${2}"

        @let clickAnimationDataStart = $this.clickAnimationDataStart
        @let clickAnimationDataLength = $this.clickAnimationDataLength
        @let text = $this.text
        @let x1 = $context.x1
        @let y1 = $context.y1
        local buttonWidth="$(( ${#text} + 6 ))"
        local buttonWidth2="$(( buttonWidth / 2 ))"

        $clickAnimationDataStart.setPlain \
            -1 "$(( x1 + buttonWidth2 ))" "${x1}" "${x1}"

        $clickAnimationDataLength.setPlain \
            -1 "${buttonWidth2}" "${buttonWidth}" "${buttonWidth2}"
    }

    function ButtonWidget.widgetWidth()
    {
        @let text = $this.text

        @returning "$(( ${#text} + 6 ))"
    }

    function ButtonWidget.widgetHeight()
    {
        @returning 1
    }

    function ButtonWidget.calculateMinSize()
    {
        local calculator="${1}"

        @let text = $this.text

        $calculator.setupSize "$(( ${#text} + 6 ))" 1
    }

    function ButtonWidget.draw()
    {
        local context="${1}"
        local canvas="${2}"
        local widgetsLayout="${3}"

        @let text = $this.text
        @let clickAnimationDataStart = $this.clickAnimationDataStart
        @let clickAnimationDataLength = $this.clickAnimationDataLength
        @let canvasPrinter = $this.canvasPrinter

        @let resetStyle = @pixel_modes.reset
        @let focusedStyle = @pixel_modes.white
        @let normalStyle = @pixel_modes.dGray
        @let highlightStyle1 = @pixel_modes.white
        @let highlightStyle2 = @pixel_modes.bold
        local highlightStyle="${highlightStyle1}${highlightStyle2}"

        @let clickAnimationFrame = $this.clickAnimationFrame
        @let x = $context.x1
        @let y = $context.y1

        if @true $context.focusedFlag; then
            if (( clickAnimationFrame == 3 )); then
                $canvasPrinter.printText $canvas "${x}" "${y}" " -[${text}]- " "${resetStyle}${focusedStyle}"
            else
                $canvasPrinter.printText $canvas "${x}" "${y}" "-[ ${text} ]-" "${resetStyle}${focusedStyle}"
            fi
        else
            if (( clickAnimationFrame == 3 )); then
                $canvasPrinter.printText $canvas "${x}" "${y}" "  [${text}]  " "${resetStyle}${normalStyle}"
            else
                $canvasPrinter.printText $canvas "${x}" "${y}" " [ ${text} ] " "${resetStyle}${normalStyle}"
            fi
        fi

        if (( clickAnimationFrame >= 0 )) && (( clickAnimationFrame < 4 )); then
            @let highlightStart = $clickAnimationDataStart.get "${clickAnimationFrame}"
            if (( highlightStart > 0 )); then
                @let highlightLength = $clickAnimationDataLength.get "${clickAnimationFrame}"

                $canvas.putPixelsHorizModes "${highlightStart}" "${y}" "${highlightLength}" "${resetStyle}${highlightStyle}"
            fi
        fi
    }

@classdone



