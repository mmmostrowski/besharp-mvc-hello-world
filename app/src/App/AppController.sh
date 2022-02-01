#!/usr/bin/env bash

@class AppController @extends BaseController

    @var Vector ballsWidgets

    function AppController.prepareRootWidget()
    {
        @parent

        @let appLayout = $this.appLayout

        @let initialBalls = $appLayout.ballsHandlerWidget

        @let $this.ballsWidgets = @vectors.make \
            $initialBalls
    }

    function AppController.quitApp()
    {
        $this.active = false
    }

    function AppController.onEscapeCommandRequested()
    {
        $this.openAreYouSureQuit
    }

    function AppController.onHelpCommandRequested()
    {
        $this.openHelp
    }

    function AppController.addHorizontalBallsSection()
    {
        $this.addBallsSection 'makeNewHorizontalBallsSection'
    }

    function AppController.addVerticalBallsSection()
    {
        $this.addBallsSection 'makeNewVerticalBallsSection'
    }

    function AppController.addBallsSection()
    {
        local layoutCallback="${1}"

        @let appLayout = $this.appLayout

        @let balls = $appLayout.${layoutCallback}

        @let wrapper = $appLayout.ballsHandlerWidget
        $this.addNewWidgetOnTheFly $wrapper true
        $this.addNewWidgetOnTheFly $balls true

        @let ballsWidgets = $this.ballsWidgets
        $ballsWidgets.add $balls
    }

    function AppController.removeBallsSection()
    {
        @let appLayout = $this.appLayout

        @let oldHandler = $appLayout.ballsHandlerWidget

        if @is $oldHandler BallsWidget; then
            return
        elif @is $oldHandler TwoRowsWidget; then
            @let topBalls = $oldHandler.downWidget
            @let newHandler = $oldHandler.upWidget
        elif @is $oldHandler TwoColumnsWidget; then
            @let topBalls = $oldHandler.rightWidget
            @let newHandler = $oldHandler.leftWidget
        fi

        $appLayout.replaceTopBallsSection $newHandler

        $this.removeWidgetOnTheFly $topBalls
        $this.removeWidgetOnTheFly $oldHandler

        @let ballsWidgets = $this.ballsWidgets
        $ballsWidgets.remove $topBalls

        @unset $topBalls
        @unset $oldHandler
    }

    function AppController.addOneBall()
    {
        @let widgets = $this.ballsWidgets
        @let count = $widgets.size

        @let randomBallsWidget = $widgets.get $(( RANDOM % count ))

        $this.runWidgetAction $randomBallsWidget 'addBall'
    }

    function AppController.removeOneBall()
    {
        local count=0
        @let nonEmptyBallsWidgets = @vectors.make
        while @iterate @of $this.ballsWidgets @in widget; do
            if @returned @of $widget.ballsNum @gt 0; then
                (( ++count ))
                $nonEmptyBallsWidgets.add $widget
            fi
        done

        if (( count > 0 )); then
            @let randomBallsWidget = $nonEmptyBallsWidgets.get $(( RANDOM % count ))
            $this.runWidgetAction $randomBallsWidget 'removeBall'
        fi

        @unset $nonEmptyBallsWidgets
    }

    function AppController.removeAllBalls()
    {
        while @iterate @of $this.ballsWidgets @in widget; do
            $this.runWidgetAction $widget 'removeAllBalls'
        done
    }

    function AppController.openAppSettings()
    {
        $this.openPopup "settings"
    }

    function AppController.closeAppSettings()
    {
        $this.closePopup "settings"
    }

    function AppController.openAreYouSureQuit()
    {
        $this.openPopup "are_you_sure_quit"
    }

    function AppController.closeAreYouSureQuit()
    {
        $this.closePopup "are_you_sure_quit"
    }

    function AppController.openHelp()
    {
        $this.openPopup "help"
    }

    function AppController.closeHelp()
    {
        $this.closePopup "help"
    }

    function AppController.openPopup()
    {
        local layer="${1}"

        @let appLayout = $this.appLayout
        @let layers = $appLayout.layers
        if @true $layers.isLayerActive "${layer}"; then
            return
        fi

        @let widgetsLayout = $this.widgetsLayout

        $layers.deactivateLayer 'main'
        $layers.turnOnLayer "${layer}"
        $layers.pushLayerFocusIndex "${layer}"

        $widgetsLayout.needsUpdate = true
    }

    function AppController.closePopup()
    {
        local layer="${1}"

        @let appLayout = $this.appLayout
        @let layers = $appLayout.layers
        if @false $layers.isLayerActive "${layer}"; then
            return
        fi

        @let widgetsLayout = $this.widgetsLayout

        $layers.turnOnLayer 'main'
        $layers.turnOffLayer "${layer}"
        $layers.popLastFocusIndex

        $widgetsLayout.needsUpdate = true
    }

@classdone

