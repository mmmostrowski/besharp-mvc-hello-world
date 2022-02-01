#!/usr/bin/env bash

@class WidgetsCoordinator @implements WidgetMonitor

    @var @inject WidgetsTree tree
    @var @inject WidgetsLayout layout
    @var @inject WidgetAnimationController animationController

    @var Widget focusedWidget

    @var currentSortIndex = -1

    @var Set activeWidgets
    @var Set visibleWidgets
    @var Stack focusIndicesStack

    function WidgetsCoordinator()
    {
        @let $this.activeWidgets = @sets.make
        @let $this.visibleWidgets = @sets.make
        @let $this.focusIndicesStack = @collections.makeStack
    }

    function WidgetsCoordinator.processInput()
    {
        local input="${1}"

        @let focusedWidget = $this.focusedWidget
        if [[ -n "${focusedWidget}" ]]; then
            @let layout = $this.layout
            @let context = $layout.widgetContext $focusedWidget
            @let event = @new WidgetInputEvent $input $context

            @let tree = $this.tree
            $tree.walkUpTreeUntil $focusedWidget \
                  $this.processSingleWidgetInput $focusedWidget $event

            if @true $event.isConsumed; then
                @returning true
                return
            fi

            @unset $event
        fi

        $this.processOrphanInputEvent $input

        @returning false
    }

    function WidgetsCoordinator.processSingleWidgetInput()
    {
        local widget="${1}"
        local sourceWidget="${2}"
        local event="${3}"

        if ! @is $widget FocusableWidget; then
            @returning true # continue event bubble up
            return
        fi

        if @same $widget $sourceWidget; then
            $widget.processKeyboardEvent $event true
        else
            $widget.processKeyboardEvent $event false
        fi

        if @true $event.isConsumed; then
            @returning false
        else
            @returning true
        fi
    }

    function WidgetsCoordinator.processOrphanInputEvent()
    {
        local input="${1}"

        @let command = $input.requestedCommand
        if [[ "${command}" == 'next' ]]; then
            $this.switchWidgetFocusToNext
        elif [[ "${command}" == 'prev' ]]; then
            $this.switchWidgetFocusToPrev
        fi
    }

    function WidgetsCoordinator.switchWidgetFocusToNext()
    {
        @let currentSortIndex = $this.currentSortIndex
        @let activeWidgets = $this.activeWidgets
        @let layout = $this.layout

        local firstFocusable=
        local lowestFoundSortIndex=100000000000000
        local closestGreaterIndex=100000000000000
        local nextWidget=
        while @iterate $activeWidgets @in widget; do
            @let widgetSortIndex = $layout.widgetSortIndex $widget
            if (( widgetSortIndex == -1 )); then
                continue
            fi

            if (( widgetSortIndex < lowestFoundSortIndex )); then
                lowestFoundSortIndex="${widgetSortIndex}"
                firstFocusable=$widget
            fi

            if (( widgetSortIndex > currentSortIndex )) \
                && (( widgetSortIndex < closestGreaterIndex ));
            then
                closestGreaterIndex="${widgetSortIndex}"
                nextWidget=$widget
            fi
        done

        if [[ -n $nextWidget ]]; then
            $this.focusWidget $nextWidget
            $this.highlightWidget $nextWidget
        elif [[ -n $firstFocusable ]]; then
            $this.focusWidget $firstFocusable
            $this.highlightWidget $firstFocusable
        fi
    }

    function WidgetsCoordinator.switchWidgetFocusToPrev()
    {
        @let currentSortIndex = $this.currentSortIndex
        @let activeWidgets = $this.activeWidgets
        @let layout = $this.layout

        local lastFocusable=
        local highestFoundSortIndex=-1
        local closestLowerIndex=-1
        local prevWidget=
        while @iterate $activeWidgets @in widget; do
            @let widgetSortIndex = $layout.widgetSortIndex $widget
            if (( widgetSortIndex == -1 )); then
                continue
            fi

            if (( widgetSortIndex > highestFoundSortIndex )); then
                highestFoundSortIndex="${widgetSortIndex}"
                lastFocusable=$widget
            fi

            if (( widgetSortIndex < currentSortIndex )) \
                && (( widgetSortIndex > closestLowerIndex ));
            then
                closestLowerIndex="${widgetSortIndex}"
                prevWidget=$widget
            fi
        done

        if [[ -n $prevWidget ]]; then
            $this.focusWidget $prevWidget
            $this.highlightWidget $prevWidget
        elif [[ -n $lastFocusable ]]; then
            $this.focusWidget $lastFocusable
            $this.highlightWidget $lastFocusable
        fi
    }

    function WidgetsCoordinator.switchFocusWidget()
    {
        local widget="${1}"

        @let layout = $this.layout
        @let focusIndex = $layout.widgetSortIndex $widget

        $this.switchToFocusIndex "${focusIndex}"
    }

    function WidgetsCoordinator.switchToFocusIndex()
    {
        local sortIndex="${1}"

        @let layout = $this.layout

        $this.currentSortIndex = "${sortIndex}"
        while @iterate @of $this.activeWidgets @in widget; do
            @let widgetSortIndex = $layout.widgetSortIndex $widget
            if (( widgetSortIndex == sortIndex )); then
                $this.focusWidget $widget
                $this.highlightWidget $widget
                return
            fi
        done
    }

    function WidgetsCoordinator.pushFocusWidget()
    {
        local widget="${1}"

        @let layout = $this.layout
        @let focusIndex = $layout.widgetSortIndex $widget

        $this.pushFocusIndex "${focusIndex}"
    }

    function WidgetsCoordinator.pushFocusIndex()
    {
        local sortIndex="${1}"

        @let currentSortIndex = $this.currentSortIndex
        @let focusIndicesStack = $this.focusIndicesStack
        $focusIndicesStack.add "${currentSortIndex}"

        $this.switchToFocusIndex "${sortIndex}"
    }

    function WidgetsCoordinator.popFocusWidget()
    {
        $this.popFocusIndex
    }

    function WidgetsCoordinator.popFocusIndex()
    {
        @let focusIndicesStack = $this.focusIndicesStack
        @let sortIndex = $focusIndicesStack.pull

        $this.switchToFocusIndex "${sortIndex}"

        @returning "${sortIndex}"
    }

    function WidgetsCoordinator.initializeWidgets()
    {
        local widget="${1}"

        @let tree = $this.tree
        $tree.walkDownTree $widget $this.initializeSingleWidget
    }

    function WidgetsCoordinator.initializeSingleWidget()
    {
        local widget="${1}"

        $widget.initialize
    }

    function WidgetsCoordinator.activateWidget()
    {
        local widget="${1}"
        local active="${2:-true}"

        @let tree = $this.tree
        $tree.walkDownTreeOperatives $widget $this.activateSingleWidget "${active}"
    }

    function WidgetsCoordinator.deactivateWidget()
    {
        local widget="${1}"

        @let tree = $this.tree
        $tree.walkDownTree $widget $this.activateSingleWidget "false"
    }

    function WidgetsCoordinator.isWidgetActive()
    {
        local widget="${1}"

        @let activeWidgets = $this.activeWidgets

        @returning @of $activeWidgets.has "${widget}"
    }

    function WidgetsCoordinator.makeWidgetVisible()
    {
        local widget="${1}"

        @let tree = $this.tree
        $tree.walkDownTreeOperatives $widget $this.makeSingleWidgetVisible "true"
    }

    function WidgetsCoordinator.makeWidgetInvisible()
    {
        local widget="${1}"

        @let tree = $this.tree
        $tree.walkDownTree $widget $this.makeSingleWidgetVisible "false"
    }

    function WidgetsCoordinator.isWidgetVisible()
    {
        local widget="${1}"

        @let visibleWidgets = $this.visibleWidgets

        @returning @of $visibleWidgets.has "${widget}"
    }

    function WidgetsCoordinator.focusWidget()
    {
        local widget="${1}"

        @let layout = $this.layout

        if @returned @of $this.focusedWidget != ''; then
            @let focusedWidget = $this.focusedWidget
            @let context = $layout.widgetContext $focusedWidget
            $context.focusedFlag = false
        fi

        @let context = $layout.widgetContext $widget
        $context.focusedFlag = true

        $this.focusedWidget = $widget
        @let $this.currentSortIndex = $layout.widgetSortIndex $widget
    }

    function WidgetsCoordinator.highlightWidget()
    {
        local widget="${1}"

        @let layout = $this.layout
        while @iterate @of $layout.widget2Context @in context; do
            $context.turnHighlightOff
        done

        @let tree = $this.tree
        $tree.walkUpTree $widget $this.highlightSingleWidget
    }

    function WidgetsCoordinator.highlightSingleWidget()
    {
        local widget="${1}"

        @let layout = $this.layout
        @let context = $layout.widgetContext $widget
        $context.turnHighlightOn
    }

    function WidgetsCoordinator.activateSingleWidget()
    {
        local widget="${1}"
        local active="${2:-true}"

        @let activeWidgets = $this.activeWidgets

        if $active; then
            $activeWidgets.add $widget
        else
            $activeWidgets.remove $widget
        fi
    }

    function WidgetsCoordinator.makeSingleWidgetVisible()
    {
        local widget="${1}"
        local visible="${2:-true}"

        @let visibleWidgets = $this.visibleWidgets

        if $visible; then
            $visibleWidgets.add $widget
        else
            $visibleWidgets.remove $widget
        fi

        if @is $widget AnimatedWidget; then
            @let animationController = $this.animationController

            if $visible; then
                $animationController.activateWidgetAnimation $widget
            else
                $animationController.deactivateWidgetAnimation $widget
            fi
        fi
    }

@classdone