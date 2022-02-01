#!/usr/bin/env bash

@class WidgetInputEvent

    @var isConsumed = false

    @var input

    @var widgetContext

    function WidgetInputEvent()
    {
        $this.input = "${1}"
        $this.widgetContext = "${2}"
    }

    function WidgetInputEvent.consumeWhenCommandRequested()
    {
        @let input = $this.input

        @returning false

        local command
        for command in "${@}"; do
            if @returned @of $input.requestedCommand == "${command}"; then
                $this.isConsumed = true
                @returning true
                return
            fi
        done
    }


@classdone

