#!/usr/bin/env bash

@static { @widgets }
@class WidgetsHelper

    @var @inject WidgetsLayout layout

    function WidgetsHelper.info
    {
        local widget="${1}"

        @let layout = $this.layout
        @let context = $layout.widgetContext $widget
        @let widgetId = $layout.widgetId $widget

        @returning "Widget '${widgetId}' [ '${widget}' object of type '$( besharp.rtti.objectType $widget )' ]"
    }

    function WidgetsHelper.debug
    (
        local widget="${1}"
        local label="${2:-}"

        @let layout = $this.layout
        @let context = $layout.widgetContext $widget
        @let widgetId = $layout.widgetId $widget

        @let x1 = $context.x1
        @let y1 = $context.y1
        @let width = $context.width
        @let height = $context.height
        @let focusedFlag = $context.focusedFlag
        @let highlightedFlag = $context.highlightedFlag

        @let details = @maps.make \
            "class" "$( besharp.rtti.objectType $widget )" \
            "id" $widgetId \
            "x1" $x1 \
            "y1" $y1 \
            "width" $width \
            "height" $height \
            "focusedFlag" $focusedFlag \
            "highlightedFlag" $highlightedFlag \
        ;

        if [[ -n "${label}" ]]; then
            d "${label}" $details
        else
            d $details
        fi

        @unset $details
        t
    )


@classdone