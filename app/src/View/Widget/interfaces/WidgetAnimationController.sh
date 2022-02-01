#!/usr/bin/env bash

@class WidgetAnimationController

    @var @inject WidgetsLayout widgetsLayout

    @var @inject AppState appState

    @var isAnimationActive = false

    @var Vector activeAnimatedWidgets

    @var Vector cloneOfActiveWidgets


    function WidgetAnimationController()
    {
        @let $this.activeAnimatedWidgets = @vectors.make
        @let $this.cloneOfActiveWidgets = @vectors.make
    }

    function WidgetAnimationController.registerAnimatedWidget()
    {
        local widget="${1}"

        @let widgetsLayout = $this.widgetsLayout
        @let widgetContext = $widgetsLayout.widgetContext $widget

        $widget.initializeAnimation $widgetContext $widgetsLayout
    }

    function WidgetAnimationController.unregisterAnimatedWidget()
    {
        local widget="${1}"

    }

    function WidgetAnimationController.activateWidgetAnimation()
    {
        local widget="${1}"

        @let activeAnimatedWidgets = $this.activeAnimatedWidgets
        if @true $activeAnimatedWidgets.has $widget; then
            return
        fi

        $activeAnimatedWidgets.add $widget
    }

    function WidgetAnimationController.deactivateWidgetAnimation()
    {
        local widget="${1}"

        @let activeAnimatedWidgets = $this.activeAnimatedWidgets
        $activeAnimatedWidgets.remove $widget
    }

    function WidgetAnimationController.processAnimationStep()
    {
        @let widgetsLayout = $this.widgetsLayout

        $this.isAnimationActive = false
        @let activeAnimatedWidgets = $this.activeAnimatedWidgets

        if @true $activeAnimatedWidgets.isEmpty; then
            return
        fi

        @let cloneOfActiveWidgets = $this.cloneOfActiveWidgets
        @collections.cloneTo $cloneOfActiveWidgets $activeAnimatedWidgets

        @let count = $cloneOfActiveWidgets.size
        while (( --count >= 0 )); do
            @let widget = $cloneOfActiveWidgets.get "${count}"
            @let widgetContext = $widgetsLayout.widgetContext $widget

            if @is $widget StoppableAnimationWidget; then
                @let appState = $this.appState
                if @false $appState.isAnimationEnabled; then
                    continue
                fi
            fi

            @let animationFramesNum = $widget.processAnimationFrame $widgetContext $widgetsLayout
            if (( animationFramesNum > 0 )); then
                $this.isAnimationActive = true
            fi
        done
    }

@classdone