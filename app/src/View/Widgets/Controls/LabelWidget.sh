#!/usr/bin/env bash

@class LabelWidget @implements Widget WidgetWithSize

    @var @inject CanvasPrinter canvasPrinter

    @var text

    function LabelWidget()
    {
        $this.text = "${1}"
    }

    function LabelWidget.initialize()
    {
        :
    }

    function LabelWidget.widgetWidth()
    {
        @let text = $this.text

        @returning "${#text}"
    }

    function LabelWidget.widgetHeight()
    {
        @returning 1
    }

    function LabelWidget.calculateMinSize()
    {
        local calculator="${1}"

        @let text = $this.text

        $calculator.setupSize "${#text}" 1
    }

    function LabelWidget.draw()
    {
        local context="${1}"
        local canvas="${2}"
        local widgetsLayout="${3}"

        @let text = $this.text
        @let x = $context.x1
        @let y = $context.y1

        @let canvasPrinter = $this.canvasPrinter
        $canvasPrinter.printText $canvas "${x}" "${y}" "${text}"
    }

@classdone



