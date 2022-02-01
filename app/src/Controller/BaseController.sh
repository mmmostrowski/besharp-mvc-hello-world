#!/usr/bin/env bash

@abstract @class BaseController

    @var @inject Canvas canvas
    @var @inject WidgetDrawContextFactory drawContextFactory
    @var @inject InputDriver input
    @var @inject BaseLayout appLayout
    @var @inject WidgetsTree widgetsTree
    @var @inject WidgetsLayout widgetsLayout
    @var @inject WidgetsCoordinator widgetsCoordinator
    @var @inject WidgetAnimationController animationController

    @var active = true

    function BaseController.initialize()
    {
        @let canvas = $this.canvas
        $canvas.initialize

        @let widgetsLayout = $this.widgetsLayout
        $widgetsLayout.initialize

        @let appLayout = $this.appLayout
        $appLayout.prepare
    }

    function BaseController.run()
    {
        $this.prepareRootWidget

        $this.initializeWidgets

        @let widgetsLayout = $this.widgetsLayout

        while @true $this.active; do
            $this.newFrame

            $this.stepFrame

            if @true $widgetsLayout.needsUpdate; then
                continue
            fi

            $this.renderFrame

            $this.processInput
        done

        $this.resetTerminal
    }

    function BaseController.prepareRootWidget()
    {
        @let appLayout = $this.appLayout
        @let rootWidget = $appLayout.rootWidget
        @let canvas = $this.canvas
        @let widgetsLayout = $this.widgetsLayout
        @let widgetsCoordinator = $this.widgetsCoordinator
        @let initialFocusIndex = $appLayout.initialFocusIndex

        $widgetsCoordinator.initializeWidgets $rootWidget
        $widgetsCoordinator.activateWidget $rootWidget
        $widgetsCoordinator.makeWidgetVisible $rootWidget
        $widgetsCoordinator.switchToFocusIndex "${initialFocusIndex}"

        $widgetsLayout.updateLayoutFor $rootWidget $canvas
        $widgetsLayout.calculateCanvasMinimalSize $canvas $rootWidget
    }

    function BaseController.initializeWidgets()
    {
        @let widgetsLayout = $this.widgetsLayout
        @let widgetsTree = $this.widgetsTree

        @let animationController = $this.animationController

        while @iterate @of $widgetsTree.widgets @in widget; do
            if @is $widget AnimatedWidget; then
                $animationController.registerAnimatedWidget $widget
            fi
        done
    }

    function BaseController.addNewWidgetOnTheFly()
    {
        local widget="${1}"
        local makeVisible="${2:-false}"


        @let rootWidget = $appLayout.rootWidget
        @let canvas = $this.canvas
        @let widgetsLayout = $this.widgetsLayout
        @let layout = $this.widgetsLayout
        $layout.needsUpdate = true
        $widgetsLayout.updateLayoutFor $rootWidget $canvas

        @let widgetsCoordinator = $this.widgetsCoordinator
        $widgetsCoordinator.initializeWidgets $widget
        $widgetsCoordinator.activateWidget $widget

        @let animationController = $this.animationController
        if @is $widget AnimatedWidget; then
            $animationController.registerAnimatedWidget $widget
        fi

        if $makeVisible; then
            $widgetsCoordinator.makeWidgetVisible $widget
        fi
    }

    function BaseController.removeWidgetOnTheFly()
    {
        local widget="${1}"

        @let rootWidget = $appLayout.rootWidget
        @let canvas = $this.canvas
        @let widgetsLayout = $this.widgetsLayout
        @let layout = $this.widgetsLayout
        $layout.needsUpdate = true
        $widgetsLayout.updateLayoutFor $rootWidget $canvas

        @let widgetsCoordinator = $this.widgetsCoordinator
        $widgetsCoordinator.deactivateWidget $widget
        $widgetsCoordinator.makeSingleWidgetVisible $widget false

        @let animationController = $this.animationController
        if @is $widget AnimatedWidget; then
            $animationController.unregisterAnimatedWidget $widget
        fi
    }

    function BaseController.stepFrame()
    {
        @let animationController = $this.animationController

        $animationController.processAnimationStep
    }

    function BaseController.newFrame()
    {
        @let canvas = $this.canvas
        @let widgetsLayout = $this.widgetsLayout
        @let appLayout = $this.appLayout
        @let rootWidget = $appLayout.rootWidget

        $canvas.beginFrame
        $widgetsLayout.updateLayoutFor $rootWidget $canvas
    }

    function BaseController.renderFrame()
    {
        @let canvas = $this.canvas
        @let widgetsLayout = $this.widgetsLayout
        @let appLayout = $this.appLayout
        @let rootWidget = $appLayout.rootWidget

        $widgetsLayout.drawWidget $rootWidget $canvas
        $canvas.render
    }

    function BaseController.processInput()
    {
        @let widgetsLayout = $this.widgetsLayout
        @let widgetsCoordinator = $this.widgetsCoordinator
        @let animationController = $this.animationController
        @let input = $this.input

        local needsRedraw=false
        if @true $widgetsLayout.needsRedraw; then
             needsRedraw=true
             $widgetsLayout.needsRedraw = false
        fi

        if $needsRedraw || @true $animationController.isAnimationActive; then
            $input.scanInput
        else
            local counter=20
            while (( --counter > 0 )); do
                $input.scanInput
                if @true $input.isAnyKeyboardKeyPressed; then
                    break
                fi
                sleep 0.1
            done
        fi

        if @true $widgetsCoordinator.processInput $input; then
            return
        fi

        if @true $input.isKeyboardKeyPressed 'f1'; then
            $this.onHelpCommandRequested
        elif @true $input.isKeyboardKeyPressed 'esc'; then
            $this.onEscapeCommandRequested
        fi
    }

    @abstract function BaseController.onEscapeCommandRequested

    @abstract function BaseController.onHelpCommandRequested

    function BaseController.runWidgetAction
    {
        local widget="${1}"
        local action="${2}"
        shift 2

        @let widgetsLayout = $this.widgetsLayout
        $widgetsLayout.callWidgetAction $widget "${action}" "${@}"
    }

    function BaseController.resetTerminal()
    {
        reset
    }

@classdone

