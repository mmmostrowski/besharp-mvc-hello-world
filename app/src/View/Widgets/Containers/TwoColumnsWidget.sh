#!/usr/bin/env bash

@class TwoColumnsWidget @implements Widget ContainerWidget

    @var Widget leftWidget
    @var Widget rightWidget
    @var leftSize
    @var rightSize

    @var Vector bothWidgets


    function TwoColumnsWidget()
    {
        $this.leftWidget = "${1}"
        $this.leftSize = "${2}"
        $this.rightWidget = "${3}"
        $this.rightSize = "${4}"

        @let $this.bothWidgets = @vectors.makeImmutable "${1}" "${3}"
    }

    function TwoColumnsWidget.childrenWidgets()
    {
        @returning @of $this.bothWidgets
    }

    function TwoColumnsWidget.operativeChildrenWidget()
    {
        @returning @of $this.bothWidgets
    }

    function TwoColumnsWidget.initialize()
    {
        @let leftWidget = $this.leftWidget
        @let rightWidget = $this.rightWidget
        @let leftSize = $this.leftSize
        @let rightSize = $this.rightSize

        if [[ "${leftSize}" == 'auto' ]] && [[ "${rightSize}" == 'auto' ]]; then
            besharp.runtime.error "One of two columns in TwoColumnsWidget must have 'auto' set as column size!"
        fi
        if [[ "${leftSize}" != 'auto' ]] && [[ "${rightSize}" != 'auto' ]]; then
            besharp.runtime.error "There only one of two columns in TwoColumnsWidget can have 'auto' set as column size!"
        fi
    }

    function TwoColumnsWidget.calculateMinSize()
    {
        local calculator="${1}"

        @let leftWidget = $this.leftWidget
        $calculator.calculateMinSize $leftWidget

        @let leftWidth = $calculator.width
        @let leftHeight = $calculator.height

        @let rightWidget = $this.rightWidget
        $calculator.calculateMinSize $rightWidget

        $calculator.resizeWidthBy "${leftWidth}"
        $calculator.takeGreaterHeight "${leftHeight}"
    }

    function TwoColumnsWidget.organizeChildrenOnLayout()
    {
        local context="${1}"
        local widgetsLayout="${2}"

        @let leftWidget = $this.leftWidget
        @let rightWidget = $this.rightWidget
        @let leftSize = $this.leftSize
        @let x1 = $context.x1
        @let y1 = $context.y1
        @let width = $context.width
        @let height = $context.height

        if [[ "${leftSize}" == 'auto' ]]; then
            @let rightSize = $this.rightSize
            if [[ "${rightSize%\%}" != "${rightSize}" ]]; then
                rightSize=$(( ( "${rightSize%\%}" * width ) / 100 ))
            fi

            $widgetsLayout.setupContextWindow $leftWidget \
                "${x1}" "${y1}" "$(( width - rightSize ))" "${height}"

            $widgetsLayout.setupContextWindow $rightWidget \
                "$(( width - rightSize + x1 ))" "${y1}" "${rightSize}" "${height}"
        else
            if [[ "${leftSize%\%}" != "${leftSize}" ]]; then
                leftSize="$(( ( "${leftSize%\%}" * width ) / 100 ))"
            fi

            $widgetsLayout.setupContextWindow $leftWidget \
                "${x1}" "${y1}" "${leftSize}" "${height}"

            $widgetsLayout.setupContextWindow $rightWidget \
               "$(( leftSize + x1 ))" "${y1}" "$(( width - leftSize ))" "${height}"
        fi

    }

    function TwoColumnsWidget.draw()
    {
        local context="${1}"
        local canvas="${2}"
        local widgetsLayout="${3}"

        @let leftWidget = $this.leftWidget
        @let rightWidget = $this.rightWidget

        $widgetsLayout.drawWidget $leftWidget $canvas
        $widgetsLayout.drawWidget $rightWidget $canvas
    }

@classdone