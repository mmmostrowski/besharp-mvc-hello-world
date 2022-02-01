#!/usr/bin/env bash

@class PopupFrameWidget @implements Widget ContainerWidget StatefulWidget FocusableWidget

    @var @inject CanvasPrinter canvasPrinter

    @var Vector widgets

    @var WidgetStateKeeper state

    function PopupFrameWidget()
    {
        @let $this.widgets = @vectors.make "${@}"
    }

    function PopupFrameWidget.childrenWidgets()
    {
        @returning @of $this.widgets
    }

    function PopupFrameWidget.operativeChildrenWidget()
    {
        @returning @of $this.widgets
    }

    function PopupFrameWidget.initialize()
    {
        :
    }

    function PopupFrameWidget.processKeyboardEvent()
    {
        local event="${1}"

        if @true $event.consumeWhenCommandRequested 'escape'; then
            @let state = $this.state
            $state.requestWidgetEvent $this 'on_escape'
        fi
    }

    function PopupFrameWidget.isShadowsRenderingEnabled()
    {
        @let state = $this.state

        @returning @of $state.readWidgetState $this 'shadowsEnabled' true
    }

    function PopupFrameWidget.title()
    {
        @let state = $this.state

        @returning @of $state.readWidgetState $this 'title' ''
    }

    function PopupFrameWidget.bindWidgetState()
    {
        $this.state = "${1}"
    }

    function PopupFrameWidget.calculateMinSize()
    {
        local calculator="${1}"

        local maxWidth=-1
        local maxHeight=-1
        while @iterate @of $this.widgets @in children; do
            $calculator.calculateMinSize $children

            @let maxWidth = $calculator.greaterWidth "${maxWidth}"
            @let maxHeight = $calculator.greaterHeight "${maxHeight}"
        done

        # frame
        (( ++maxWidth))
        (( ++maxHeight ))

        $calculator.setupSize "${maxWidth}" "${maxHeight}"
    }

   function PopupFrameWidget.organizeChildrenOnLayout()
    {
        local context="${1}"
        local widgetsLayout="${2}"

        @let x1 = $context.x1
        @let y1 = $context.y1
        @let width = $context.width
        @let height = $context.height

        while @iterate @of $this.widgets @in children; do
            $widgetsLayout.setupContextWindow $children \
                "$(( x1 + 1 ))" "$(( y1 + 1 ))" "$(( width - 2 ))" "$(( height - 2 ))" \
            ;
        done
    }

    function PopupFrameWidget.draw()
    {
        local context="${1}"
        local canvas="${2}"
        local widgetsLayout="${3}"

        eval "
            local x1=\"\${${context}_x1}\"
            local y1=\"\${${context}_y1}\"
            local width=\"\${${context}_width}\"
            local height=\"\${${context}_height}\"
            local canvasPrinter=\"\${${this}_canvasPrinter}\"
        "

        @let dimReset = @pixel_modes.dimReset
        @let backgroundColor = @pixel_modes.blue
        $canvas.putPixelsBox "$(( x1 + 1 ))" "$(( y1 + 1 ))" "$(( width - 2 ))" "$(( height - 2 ))" "." "${backgroundColor}"

        if @true $this.isShadowsRenderingEnabled; then
            @let shadowColor = @pixel_modes.dGray
            $canvas.putPixelsHorizModes "$(( x1 + 1  ))" "$(( y1 + height ))"  "${width}" "${shadowColor}"
            $canvas.putPixelsVertModes "$(( x1 + width ))" "$(( y1 + 1 ))"  "${height}" "${shadowColor}"
            $canvas.putPixelsVertModes "$(( x1 + width + 1))" "$(( y1 + 1 ))"  "${height}" "${shadowColor}"
            $canvas.putPixelModes "$(( x1 + width - 1 ))" "$(( y1 + height - 1 ))" "${shadowColor}"
        fi


        @let title = $this.title

        if @true $context.isHighlighted; then
            $canvasPrinter.printHighlightFrame $canvas "${x1}" "${y1}" "${width}" "${height}"
        else
            $canvasPrinter.printFrame $canvas "${x1}" "${y1}" "${width}" "${height}"
        fi
        $canvasPrinter.printText $canvas $(( x1 + 3 )) "${y1}" " ${title} "

        @let widgets = $this.widgets
        @let widgetsSize = $widgets.size
        local idx=0
        while (( idx < widgetsSize )); do
            @let widget = $widgets.get "$(( idx++ ))"
            $widgetsLayout.drawWidget $widget $canvas
        done
    }

@classdone