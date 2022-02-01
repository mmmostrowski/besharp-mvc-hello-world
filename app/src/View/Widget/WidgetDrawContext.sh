#!/usr/bin/env bash

@class WidgetDrawContext

    @var widgetId = ''

    @var x1 = 0
    @var y1 = 0
    @var width = 0
    @var height = 0

    @var placementLeft = 0
    @var placementUp = 0
    @var placementRight = 0
    @var placementDown = 0

    @var placementWidth = -1
    @var placementHeight = -1

    @var focusedFlag = false
    @var highlightedFlag = false


    function WidgetDrawContext.x2()
    {
        @let x1 = $this.x1
        @let width = $this.width

        @returning $(( x1 + width - 1 ))
    }

    function WidgetDrawContext.y2()
    {
        @let y1 = $this.y1
        @let height = $this.height

        @returning $(( y1 + height - 1 ))
    }

    function WidgetDrawContext.setupWindow()
    {
        $this.x1 = "${1}"
        $this.y1 = "${2}"
        $this.width = "${3}"
        $this.height = "${4}"
    }

    function WidgetDrawContext.isHighlighted()
    {
        @returning @of $this.highlightedFlag
    }

    function WidgetDrawContext.turnHighlightOn()
    {
        $this.highlightedFlag = true
    }

    function WidgetDrawContext.turnHighlightOff()
    {
        $this.highlightedFlag = false
    }

@classdone