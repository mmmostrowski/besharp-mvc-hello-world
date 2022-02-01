#!/usr/bin/env bash

@class CompositionWidget @implements Widget ContainerWidget

    @var Vector widgets

    function CompositionWidget()
    {
        @let $this.widgets = @vectors.make "${@}"
    }

    function CompositionWidget.childrenWidgets()
    {
        @returning @of $this.widgets
    }

    function CompositionWidget.operativeChildrenWidget()
    {
        @returning @of $this.widgets
    }

    function CompositionWidget.initialize()
    {
        :
    }

    function CompositionWidget.calculateMinSize()
    {
        local calculator="${1}"

        local maxWidth=-1
        local maxHeight=-1
        while @iterate @of $this.widgets @in children; do
            $calculator.calculateMinSize $children

            @let maxWidth = $calculator.greaterWidth "${maxWidth}"
            @let maxHeight = $calculator.greaterHeight "${maxHeight}"
        done

        $calculator.setupSize "${maxWidth}" "${maxHeight}"
    }

   function CompositionWidget.organizeChildrenOnLayout()
    {
        local context="${1}"
        local widgetsLayout="${2}"

        @let x1 = $context.x1
        @let y1 = $context.y1
        @let width = $context.width
        @let height = $context.height

        while @iterate @of $this.widgets @in children; do
            $widgetsLayout.setupContextWindow $children \
                "${x1}" "${y1}" "${width}" "${height}"
        done
    }

    function CompositionWidget.draw()
    {
        local context="${1}"
        local canvas="${2}"
        local widgetsLayout="${3}"

        @let widgets = $this.widgets
        @let widgetsSize = $widgets.size
        local idx=0
        while (( idx < widgetsSize )); do
            @let widget = $widgets.get "$(( idx++ ))"

            $widgetsLayout.drawWidget $widget $canvas
        done
    }

@classdone