#!/usr/bin/env bash

@class LayersWidget @implements Widget ContainerWidget

    @var @inject WidgetsCoordinator coordinator

    @var Vector layersKey
    @var Vector layersWidget
    @var Map key2idx
    @var Map key2widget
    @var Map key2focusWidget

    @var Set activeLayers
    @var Set activeWidgets
    @var Vector visibleWidgets


    function LayersWidget()
    {
        @let $this.layersKey = @vectors.make
        @let $this.layersWidget = @vectors.make
        @let $this.key2idx = @maps.make
        @let $this.key2widget = @maps.make
        @let $this.key2focusWidget = @maps.make
        @let $this.activeWidgets = @sets.make
        @let $this.activeLayers = @sets.make
        @let $this.visibleWidgets = @vectors.make

        @let layersKey = $this.layersKey
        @let layersWidget = $this.layersWidget
        @let key2idx = $this.key2idx
        @let key2widget = $this.key2widget

        local item
        local key
        local isEven=true
        local idx=0
        local widget
        for item in "${@}"; do
            if $isEven; then
                isEven=false
                key="${item}"
            else
                isEven=true
                widget="${item}"

                $layersKey.add "${key}"
                $layersWidget.add $widget
                $key2widget.set "${key}" $widget
                $key2idx.set "${key}" "$(( idx++ ))"
            fi
        done
    }

    function LayersWidget.setupInitialFocusWidget()
    {
        local layerKey="${1}"
        local widget="${2}"

        @let key2focusWidget = $this.key2focusWidget
        $key2focusWidget.set "${layerKey}" "${widget}"
    }

    function LayersWidget.childrenWidgets()
    {
        @returning @of $this.layersWidget
    }

    function LayersWidget.operativeChildrenWidget()
    {
        @returning @of $this.activeWidgets
    }

    function LayersWidget.initialize()
    {
        @let coordinator = $this.coordinator

        while @iterate @of $this.layersWidget @in widget; do
            $coordinator.deactivateWidget $widget
            $coordinator.makeWidgetInvisible $widget
        done
    }

    function LayersWidget.turnOnLayer()
    {
        local layerKey="${1}"

        $layers.activateLayer "${layerKey}"
        $layers.showLayer "${layerKey}"
    }

    function LayersWidget.turnOffLayer()
    {
        local layerKey="${1}"

        $layers.hideLayer "${layerKey}"
        $layers.deactivateLayer "${layerKey}"
    }

    function LayersWidget.activateLayer()
    {
        local layerKey="${1}"

        @let activeWidgets = $this.activeWidgets
        @let key2widget = $this.key2widget

        @let widget = $key2widget.get "${layerKey}"
        $activeWidgets.add $widget

        @let coordinator = $this.coordinator
        $coordinator.activateWidget $widget

        @let activeLayers = $this.activeLayers
        $activeLayers.add "${layerKey}"
    }

    function LayersWidget.deactivateLayer()
    {
        local layerKey="${1}"

        @let key2widget = $this.key2widget
        @let widget = $key2widget.get "${layerKey}"

        @let activeWidgets = $this.activeWidgets
        $activeWidgets.remove $widget

        @let coordinator = $this.coordinator
        $coordinator.deactivateWidget $widget

        @let activeLayers = $this.activeLayers
        $activeLayers.remove "${layerKey}"
    }

    function LayersWidget.isLayerActive()
    {
        local layerKey="${1}"

        @let activeLayers = $this.activeLayers
        @returning @of $activeLayers.has "${layerKey}"
    }

    function LayersWidget.switchLayerFocusIndex()
    {
        local layerKey="${1}"

        @let key2focusWidget = $this.key2focusWidget
        @let focusWidget = $key2focusWidget.get "${layerKey}"

        $coordinator.switchFocusWidget $focusWidget
    }

    function LayersWidget.pushLayerFocusIndex()
    {
        local layerKey="${1}"

        @let key2focusWidget = $this.key2focusWidget
        @let focusWidget = $key2focusWidget.get "${layerKey}"

        @let coordinator = $this.coordinator
        $coordinator.pushFocusWidget $focusWidget
    }

    function LayersWidget.popLastFocusIndex()
    {
        @let coordinator = $this.coordinator
        $coordinator.popFocusWidget
    }

    function LayersWidget.showLayer()
    {
        local layerKey="${1}"

        @let key2widget = $this.key2widget
        @let widget = $key2widget.get "${layerKey}"


        # remaking visible widgets in the same order
        @let visibleWidgets = $this.visibleWidgets
        @let alreadyVisible = @sets.makeOf $visibleWidgets

        $visibleWidgets.removeAll
        while @iterate @of $this.layersWidget @in layerWidget; do
            if @true $alreadyVisible.has $layerWidget \
                || @same $layerWidget $widget \
            ; then
                $visibleWidgets.add $layerWidget
            fi
        done

        @unset $alreadyVisible

        @let coordinator = $this.coordinator
        $coordinator.makeWidgetVisible $widget
    }

    function LayersWidget.hideLayer()
    {
        local layerKey="${1}"

        @let key2widget = $this.key2widget
        @let widget = $key2widget.get "${layerKey}"

        @let visibleWidgets = $this.visibleWidgets
        $visibleWidgets.remove $widget

        @let coordinator = $this.coordinator
        $coordinator.makeWidgetInvisible $widget
    }

    function LayersWidget.calculateMinSize()
    {
        local calculator="${1}"

        local maxWidth=-1
        local maxHeight=-1
        while @iterate @of $this.layersWidget @in children; do
            $calculator.calculateMinSize $children

            @let maxWidth = $calculator.greaterWidth "${maxWidth}"
            @let maxHeight = $calculator.greaterHeight "${maxHeight}"
        done

        $calculator.setupSize "${maxWidth}" "${maxHeight}"
    }

   function LayersWidget.organizeChildrenOnLayout()
    {
        local context="${1}"
        local widgetsLayout="${2}"

        @let x1 = $context.x1
        @let y1 = $context.y1
        @let width = $context.width
        @let height = $context.height

        while @iterate @of $this.visibleWidgets @in children; do
            $widgetsLayout.setupContextWindow $children \
                "${x1}" "${y1}" "${width}" "${height}"
        done
    }

    function LayersWidget.draw()
    {
        local context="${1}"
        local canvas="${2}"
        local widgetsLayout="${3}"

        @let visibleWidgets = $this.visibleWidgets
        @let visibleWidgetsSize = $visibleWidgets.size
        local idx=0
        while (( idx < visibleWidgetsSize )); do
            @let widget = $visibleWidgets.get "$(( idx++ ))"

            $widgetsLayout.drawWidget $widget $canvas
        done
    }

@classdone