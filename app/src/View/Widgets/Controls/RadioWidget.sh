#!/usr/bin/env bash

@class RadioWidget @implements Widget WidgetWithSize StatefulWidget FocusableWidget

    @var @inject CanvasPrinter canvasPrinter

    @var WidgetStateKeeper state

    @var valueKey


    function RadioWidget()
    {
        $this.valueKey = "${1}"
    }

    function RadioWidget.initialize()
    {
        :
    }

    function RadioWidget.processKeyboardEvent()
    {
        local event="${1}"

         if @true $event.consumeWhenCommandRequested 'action'; then
              $this.check
         fi
    }

    function RadioWidget.bindWidgetState()
    {
        $this.state = "${1}"
    }

    function RadioWidget.widgetWidth()
    {
        @let text = $this.text

        @returning $(( ${#text} + 6 ))
    }

    function RadioWidget.widgetHeight()
    {
        @returning 1
    }

    function RadioWidget.calculateMinSize()
    {
        local calculator="${1}"

        @let text = $this.text

        $calculator.setupSize "${#text}" 1
    }

    function RadioWidget.draw()
    {
        local context="${1}"
        local canvas="${2}"
        local widgetsLayout="${3}"

        @let text = $this.text
        @let x = $context.x1
        @let y = $context.y1

        @let canvasPrinter = $this.canvasPrinter
        if @true $context.focusedFlag; then
            if @true $this.isChecked; then
                $canvasPrinter.printText $canvas "${x}" "${y}" "-(*) ${text}-"
            else
                $canvasPrinter.printText $canvas "${x}" "${y}" "-( ) ${text}-"
            fi
        else
            if @true $this.isChecked; then
                $canvasPrinter.printText $canvas "${x}" "${y}" " (*) ${text} "
            else
                $canvasPrinter.printText $canvas "${x}" "${y}" " ( ) ${text} "
            fi
        fi
    }

    function RadioWidget.isChecked()
    {
        @let state = $this.state
        @let valueKey = $this.valueKey

        if @returned @of $state.readWidgetState $this 'value' '' == "${valueKey}"; then
            @returning true
        else
            @returning false
        fi
    }

    function RadioWidget.check()
    {
        @let state = $this.state
        @let valueKey = $this.valueKey

        $state.writeWidgetState $this 'value' "${valueKey}"
    }

    function RadioWidget.text()
    {
        @let state = $this.state
        @returning @of $state.readWidgetState $this 'text' ''
    }

@classdone



