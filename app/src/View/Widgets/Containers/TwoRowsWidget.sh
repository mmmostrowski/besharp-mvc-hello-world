#!/usr/bin/env bash

@class TwoRowsWidget @implements Widget ContainerWidget

    @var Widget upWidget
    @var Widget downWidget
    @var upSize
    @var downSize

    @var Vector bothWidgets


    function TwoRowsWidget()
    {
        $this.upWidget = "${1}"
        $this.upSize = "${2}"
        $this.downWidget = "${3}"
        $this.downSize = "${4}"

        @let $this.bothWidgets = @vectors.make "${1}" "${3}"
    }

    function TwoRowsWidget.replaceUpWidget()
    {
        local widget="${1}"

        $this.upWidget = $widget

        @let bothWidgets = $this.bothWidgets
        $bothWidgets.set 0 $widget
    }

    function TwoRowsWidget.replaceDownWidget()
    {
        local widget="${1}"

        $this.downWidget = $widget

        @let bothWidgets = $this.bothWidgets
        $bothWidgets.set 1 $widget
    }

    function TwoRowsWidget.childrenWidgets()
    {
        @returning @of $this.bothWidgets
    }

    function TwoRowsWidget.operativeChildrenWidget()
    {
        @returning @of $this.bothWidgets
    }

    function TwoRowsWidget.initialize()
    {
        @let upWidget = $this.upWidget
        @let downWidget = $this.downWidget
        @let upSize = $this.upSize
        @let downSize = $this.downSize

        if [[ "${downSize}" == 'auto' ]] && [[ "${upSize}" == 'auto' ]]; then
            besharp.runtime.error "One of two rows in TwoRowsWidget must have 'auto' set as row size!"
        fi
        if [[ "${downSize}" != 'auto' ]] && [[ "${upSize}" != 'auto' ]]; then
            besharp.runtime.error "There only one of two rows in TwoRowsWidget can have 'auto' set as row size!"
        fi
    }

    function TwoRowsWidget.organizeChildrenOnLayout()
    {
        local context="${1}"
        local widgetsLayout="${2}"

        @let upWidget = $this.upWidget
        @let downWidget = $this.downWidget
        @let downSize = $this.downSize
        @let x1 = $context.x1
        @let y1 = $context.y1
        @let width = $context.width
        @let height = $context.height

        if [[ "${downSize}" == 'auto' ]]; then
            @let upSize = $this.upSize
            if [[ "${upSize%\%}" != "${upSize}" ]]; then
                upSize=$(( ( "${upSize%\%}" * height ) / 100 ))
            fi

            $widgetsLayout.setupContextWindow $upWidget \
                "${x1}" "${y1}" "${width}" "${upSize}"

            $widgetsLayout.setupContextWindow $downWidget \
                "${x1}" $(( upSize + y1 )) "${width}" $(( height - upSize ))

        else
            if [[ "${downSize%\%}" != "${downSize}" ]]; then
                downSize=$(( ( "${downSize%\%}" * height ) / 100 ))
            fi

            $widgetsLayout.setupContextWindow $upWidget \
                "${x1}" "${y1}" "${width}" $(( height - downSize ))

            $widgetsLayout.setupContextWindow $downWidget \
                "${x1}" $(( y1 + height - downSize )) "${width}" "${downSize}"
        fi
    }

    function TwoRowsWidget.calculateMinSize()
    {
        local calculator="${1}"

        @let upWidget = $this.upWidget
        $calculator.calculateMinSize $upWidget

        @let upWidth = $calculator.width
        @let upHeight = $calculator.height

        @let downWidget = $this.downWidget
        $calculator.calculateMinSize $downWidget

        $calculator.takeGreaterWidth "${upWidth}"
        $calculator.resizeHeightBy "${upHeight}"
    }

    function TwoRowsWidget.draw()
    {
        local context="${1}"
        local canvas="${2}"
        local widgetsLayout="${3}"

        @let upWidget = $this.upWidget
        @let downWidget = $this.downWidget

        $widgetsLayout.drawWidget $downWidget $canvas
        $widgetsLayout.drawWidget $upWidget $canvas
    }

@classdone