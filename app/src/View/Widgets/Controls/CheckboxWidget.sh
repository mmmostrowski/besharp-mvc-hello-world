#!/usr/bin/env bash

@class CheckboxWidget @implements Widget WidgetWithSize StatefulWidget FocusableWidget

    @var @inject CanvasPrinter canvasPrinter

    @var WidgetStateKeeper state

    function CheckboxWidget.initialize()
    {
        :
    }

    function CheckboxWidget.processKeyboardEvent()
    {
        local event="${1}"

         if @true $event.consumeWhenCommandRequested 'action'; then
              $this.toggle
         fi
    }

    function CheckboxWidget.bindWidgetState()
    {
        $this.state = "${1}"
    }

    function CheckboxWidget.widgetWidth()
    {
        @let text = $this.text

        @returning $(( ${#text} + 6 ))
    }

    function CheckboxWidget.widgetHeight()
    {
        @returning 1
    }

    function CheckboxWidget.calculateMinSize()
    {
        local calculator="${1}"

        @let text = $this.text

        $calculator.setupSize "${#text}" 1
    }

    function CheckboxWidget.draw()
    {
        local context="${1}"
        local canvas="${2}"
        local widgetsLayout="${3}"

        @let text = $this.text
        @let x = $context.x1
        @let y = $context.y1

        @let canvasPrinter = $this.canvasPrinter
        @let reset = @pixel_modes.reset
        if @true $context.focusedFlag; then
            @let color = @pixel_modes.white
            if @true $this.isChecked; then
                $canvasPrinter.printText $canvas "${x}" "${y}" "-[x] ${text}-" "${reset}${color}"
            else
                $canvasPrinter.printText $canvas "${x}" "${y}" "-[ ] ${text}-" "${reset}${color}"
            fi
        else
            @let color = @pixel_modes.dGray
            if @true $this.isChecked; then
                $canvasPrinter.printText $canvas "${x}" "${y}" " [x] ${text} " "${reset}${color}"
            else
                $canvasPrinter.printText $canvas "${x}" "${y}" " [ ] ${text} " "${reset}${color}"
            fi
        fi
    }

    function CheckboxWidget.isChecked()
    {
        @let state = $this.state
        @returning @of $state.readWidgetState $this 'checked' false
    }

    function CheckboxWidget.toggle()
    {
        if @true $this.isChecked; then
            $this.uncheck
        else
            $this.check
        fi
    }

    function CheckboxWidget.check()
    {
        @let state = $this.state

        $state.writeWidgetState $this 'checked' true
    }

    function CheckboxWidget.uncheck()
    {
        @let state = $this.state

        $state.writeWidgetState $this 'checked' false
    }

    function CheckboxWidget.text()
    {
        @let state = $this.state
        @returning @of $state.readWidgetState $this 'text' ''
    }

@classdone



