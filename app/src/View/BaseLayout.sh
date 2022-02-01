#!/usr/bin/env bash

@abstract @class BaseLayout

    @var @inject AppState appState
    @var @inject AppController appController
    @var @inject WidgetStateKeeperAdapter widgetsState
    @var @inject WidgetsLayout widgetsLayout
    @var @inject WidgetsFactory widgetsFactory

    @var initialFocusIndex = 0

    @var Widget rootWidget


    @abstract function BaseLayout.prepareRootWidget


    function BaseLayout.prepare()
    {
        @let $this.rootWidget = $this.prepareRootWidget
    }

    function BaseLayout.createWidget()
    {
        @args.make \
            id construct placement placementSize focusIndex focusGroup bindAppState \
            @from "${@}"

        # create
        @let widgetsFactory = $this.widgetsFactory
        @let idVector = @args.requireVector id
        @let constructVector = @args.requireVector construct
        @let widget = $constructVector.call $widgetsFactory.create
        @let id = $idVector.get 0

        # add to layout
        @let widgetsLayout = $this.widgetsLayout
        $widgetsLayout.addWidget $widget "${id}"
        $widget.initialize $widgetsLayout

        # focus setup
        @let focusIndex = @args.optionalInt focusIndex -1
        if (( focusIndex >= 0 )); then
            @let focusGroup = @args.optionalText focusGroup ""
            $widgetsLayout.setupWidgetFocusable $widget "${focusIndex}" "${focusGroup}"
        fi

        # placement setup
        @let placementVector = @args.optionalVector placement
        if [[ -z "${placementVector}" ]]; then
            local placementLeft=0
            local placementUp=0
            local placementRight=0
            local placementDown=0
        else
            @let placementLeft = $placementVector.get 0
            @let placementUp = $placementVector.get 1
            @let placementRight = $placementVector.get 2
            @let placementDown = $placementVector.get 3
        fi

        @let placementSizeVector = @args.optionalVector placementSize
        if [[ -z "${placementSizeVector}" ]]; then
            local placementWidth=-1
            local placementHeight=-1
        else
            @let placementWidth = $placementSizeVector.get 0
            @let placementHeight = $placementSizeVector.get 1
        fi

        $widgetsLayout.setupWidgetPlacement \
            $widget \
            "${placementLeft}" \
            "${placementUp}" \
            "${placementRight}" \
            "${placementDown}" \
            "${placementWidth}" \
            "${placementHeight}" \
        ;

        # binding setup
        @let bindingVector = @args.optionalVector bindAppState
        if [[ -n "${bindingVector}" ]]; then
            @let bindingMap = @maps.make
            while @iterate $bindingVector @in entry; do
                local entryArr=( ${entry//:/ } )
                $bindingMap.set "${entryArr[0]}" "${entryArr[1]}"
            done

            @let widgetsState = $this.widgetsState
            $widgetsState.setupWidgetBindings \
                $widget $bindingMap
        fi

        @returning $widget
    }

@classdone