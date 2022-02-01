#!/usr/bin/env bash

@class InputWidget @implements Widget WidgetWithSize FocusableWidget StatefulWidget

    @var @inject CanvasPrinter canvasPrinter
    @var @inject Cursor cursor

    @var length
    @var isEditing
    @var emptyText = ''


    @var WidgetStateKeeper state

    function InputWidget()
    {
        $this.length = "${1}"

        local emptyText=''
        local i
        for (( i = 0; i < ${1}; ++i )); do
            emptyText+=" "
        done

        $this.emptyText = "${emptyText}"
    }

    function InputWidget.initialize()
    {
        :
    }

    function InputWidget.bindWidgetState()
    {
        $this.state = "${1}"
    }

    function InputWidget.processKeyboardEvent()
    {
        local event="${1}"

        @let input = $event.input

        if @true $event.consumeWhenCommandRequested 'action'; then
            $this.isEditing = true
        fi
    }

    function InputWidget.text()
    {
        @let state = $this.state

        @returning @of $state.readWidgetState $this 'text' ''
    }

    function InputWidget.updateText()
    {
        local text="${1}"

        @let state = $this.state

        $state.writeWidgetState $this 'text' "${text}"
    }

    function InputWidget.label()
    {
        @let state = $this.state

        @returning @of $state.readWidgetState $this 'label' ''
    }

    function InputWidget.widgetWidth()
    {
        @let length = $this.length
        @let label = $this.label

        @returning "$(( length + ${#label} + 4 ))"
    }

    function InputWidget.widgetHeight()
    {
        @returning 1
    }

    function InputWidget.calculateMinSize()
    {
        local calculator="${1}"

        @let width = $this.widgetWidth

        $calculator.setupSize "${width}" 1
    }

    function InputWidget.draw()
    {
        local context="${1}"
        local canvas="${2}"
        local widgetsLayout="${3}"

        @let length = $this.length
        @let label = $this.label
        @let text = $this.text
        @let x = $context.x1
        @let y = $context.y1
        @let cursor = $this.cursor
        @let emptyText = $this.emptyText

        @let canvasPrinter = $this.canvasPrinter

        if @true $context.focusedFlag; then
            @let color = @pixel_modes.white
            $canvasPrinter.printText $canvas "${x}" "${y}" " ${label}:-| ${emptyText} |-" "${color}"
        else
            @let color = @pixel_modes.dGray
            $canvasPrinter.printText $canvas "${x}" "${y}" " ${label}: | ${emptyText} |" "${color}"
        fi
        local caretPos="$(( x + ${#label} + 5 ))"

        $canvasPrinter.printText $canvas "${caretPos}" "${y}" "${text}" "${color}"

        if @true $this.isEditing; then
            $cursor.show

            local input="${text}"
            local previousIFS="${IFS}"
            IFS=''
            while true; do
                $cursor.moveTo "${caretPos}" $(( y - 1 ))
                read -r -e -i "${input}" -n $(( length + 1 )) input
                if (( "${#input}" <= length )); then
                    break
                fi
                input="${input::-1}"

                $cursor.moveTo "$(( caretPos + length ))" $(( y - 1 ))
                echo -ne ' '
            done
            IFS="${previousIFS}"

            $this.updateText "${input}"
            $cursor.hide
            $this.isEditing = false
            $widgetsLayout.needsRedraw = true
       fi
    }

@classdone



