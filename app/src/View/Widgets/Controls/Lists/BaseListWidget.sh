#!/usr/bin/env bash

@abstract @class BaseListWidget @implements Widget StatefulWidget FocusableWidget AnimatedWidget LayoutChangesListenerWidget

    @var @inject CanvasPrinter canvasPrinter

    @var WidgetStateKeeper state
    @var slideAnimationFrame = 0
    @var currentSlide = 0
    @var maxSlide = 0
    @var Vector slideAnimationData
    @var nextSlideCommand
    @var prevSlideCommand

    function BaseListWidget()
    {
        $this.prevSlideCommand = "${1}"
        $this.nextSlideCommand = "${2}"
    }

    function BaseListWidget.initialize()
    {
        @let $this.slideAnimationData = @vectors.make
    }

    function BaseListWidget.processKeyboardEvent()
    {
        local event="${1}"

        @let nextSlideCommand = $this.nextSlideCommand
        @let prevSlideCommand = $this.prevSlideCommand

        if @true $event.consumeWhenCommandRequested "${nextSlideCommand}"; then
             @let state = $this.state
             $state.requestWidgetEvent $this 'on_next'
        elif @true $event.consumeWhenCommandRequested "${prevSlideCommand}"; then
             @let state = $this.state
             $state.requestWidgetEvent $this 'on_prev'
        fi
    }

    function BaseListWidget.initializeAnimation()
    {
        @let slideAnimationData = $this.slideAnimationData
        $slideAnimationData.setPlain 0
    }

    function BaseListWidget.processAnimationFrame()
    {
        @let slideAnimationFrame = $this.slideAnimationFrame

        if (( slideAnimationFrame > 0 )); then
            $this.slideAnimationFrame = $(( --slideAnimationFrame ))
        else
            $this.slideAnimationFrame = 0
        fi

        @returning "${slideAnimationFrame}"
    }

    function BaseListWidget.slideAnimationTo()
    {
        local to="${1}"

        @let maxSlide = $this.maxSlide
        if (( to > maxSlide )); then
            to="${maxSlide}"
        fi

        @let from = $this.currentSlide
        local shift="$(( to - from ))"

        $this.slideAnimationFrame = 3

        @let slideAnimationData = $this.slideAnimationData
        $slideAnimationData.setPlain \
            "${to}" \
            "$(( from + 2 * shift / 3 ))" \
            "$(( from + shift / 3 ))" \
            "${from}" \
        ;
    }

    function BaseListWidget.slideAnimationBy()
    {
        local by="${1}"
        @let from = $this.currentSlide
        local to="$(( from + by ))"

        $this.slideAnimationTo "${to}"
    }

    function BaseListWidget.bindWidgetState()
    {
        $this.state = "${1}"
    }

    function BaseListWidget.itemsList()
    {
        @let state = $this.state
        @let emptyList = @vectors.empty

        @returning @of $state.readWidgetState $this 'list' $emptyList
    }

    function BaseListWidget.currentItemIdx()
    {
        @let state = $this.state

        @returning @of $state.readWidgetState $this 'current' 0
    }

@classdone



