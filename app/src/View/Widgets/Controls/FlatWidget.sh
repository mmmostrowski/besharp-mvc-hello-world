#!/usr/bin/env bash

@class FlatWidget @implements Widget FocusableWidget

    @var pixelModes

    function FlatWidget()
    {
        $this.pixelModes = "${*}"
    }

    function FlatWidget.initialize()
    {
        :
    }

    function FlatWidget.calculateMinSize()
    {
        local calculator="${1}"
    }

    function FlatWidget.draw()
    {
        local context="${1}"
        local canvas="${2}"
        local widgetsLayout="${3}"

        @let pixelModes = $this.pixelModes
        @let x1 = $context.x1
        @let y1 = $context.y1
        @let width = $context.width
        @let height = $context.height

        $canvas.putPixelsBox "${x1}" "${y1}" "${width}" "${height}" "." "${pixelModes}"
    }

    function FlatWidget.processKeyboardEvent()
    {
        :
    }

@classdone