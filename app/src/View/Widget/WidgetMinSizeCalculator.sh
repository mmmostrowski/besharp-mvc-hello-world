#!/usr/bin/env bash

@class WidgetMinSizeCalculator

    @var @inject WidgetContextProvider contexts

    @var width = 0
    @var height = 0

    function WidgetMinSizeCalculator()
    {
        :
    }

    function WidgetMinSizeCalculator.calculateMinSize()
    {
        local widget="${1}"

        $this.width = 0
        $this.height = 0

        $widget.calculateMinSize $this

        @let contexts = $this.contexts
        @let context = $contexts.widgetContext $widget
        @let placementLeft = $context.placementLeft
        @let placementRight = $context.placementRight
        @let placementUp = $context.placementUp
        @let placementDown = $context.placementDown
        @let placementWidth = $context.placementWidth
        @let placementHeight = $context.placementHeight

        if [[ "${placementUp}" == 'auto' ]] || (( placementUp < 0 )); then
            placementUp=0
        fi
        if [[ "${placementDown}" == 'auto' ]] || (( placementDown < 0 )); then
            placementDown=0
        fi
        if [[ "${placementLeft}" == 'auto' ]] || (( placementLeft < 0 )); then
            placementLeft=0
        fi
        if [[ "${placementRight}" == 'auto' ]] || (( placementRight < 0 )); then
            placementRight=0
        fi


        $this.takeGreaterWidth "${placementWidth}"
        $this.takeGreaterHeight "${placementHeight}"

        $this.resizeWidthBy $(( placementLeft + placementRight ))
        $this.resizeHeightBy $(( placementUp + placementDown ))
    }

    function WidgetMinSizeCalculator.setupSize()
    {
        $this.width = "${1}"
        $this.height = "${2}"
    }

    function WidgetMinSizeCalculator.resizeWidthBy()
    {
        local resizeBy="${1}"

        @let w = $this.width
        $this.width = "$(( w + resizeBy ))"
    }

    function WidgetMinSizeCalculator.resizeHeightBy()
    {
        local resizeBy="${1}"

        @let h = $this.height
        $this.height = "$(( h + resizeBy ))"
    }

    function WidgetMinSizeCalculator.greaterWidth()
    {
        local toCompare="${1}"

        @let w = $this.width
        if (( toCompare > w )); then
            @returning "${toCompare}"
        else
            @returning "${w}"
        fi
    }

    function WidgetMinSizeCalculator.takeGreaterWidth()
    {
        local toCompare="${1}"

        @let w = $this.width
        if (( toCompare > w )); then
            $this.width = "${toCompare}"
        fi
    }

    function WidgetMinSizeCalculator.greaterHeight()
    {
        local toCompare="${1}"

        @let h = $this.height
        if (( toCompare > h )); then
            @returning "${toCompare}"
        else
            @returning "${h}"
        fi
    }

    function WidgetMinSizeCalculator.takeGreaterHeight()
    {
        local toCompare="${1}"

        @let h = $this.height
        if (( toCompare > h )); then
            $this.height = "${toCompare}"
        fi
    }

@classdone
