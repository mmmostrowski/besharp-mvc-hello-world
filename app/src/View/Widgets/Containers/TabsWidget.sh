#!/usr/bin/env bash

@class TabsWidget @implements Widget ContainerWidget FocusableWidget

    @var @inject CanvasPrinter printer
    @var @inject WidgetsCoordinator coordinator

    @var Vector widgets
    @var Map widgetPositions
    @var Vector tabNames

    @var activeTab = -1
    @var Vector activeOne
    @var Widget activeWidget


    function TabsWidget()
    {
        @let $this.widgets = @vectors.make
        @let $this.widgetPositions = @maps.make
        @let $this.tabNames = @vectors.make
        @let $this.activeOne = @vectors.make ""

        local name
        local isEven=true
        for item in "${@}"; do
            if $isEven; then
                isEven=false
                name="${item}"
            else
                isEven=true
                $this.addTab "${name}" "${item}"
            fi
        done
    }

    function TabsWidget.addTab()
    {
        local name="${1}"
        local widget="${2}"

        @let widgets = $this.widgets
        if @true $widgets.isEmpty; then
            $this.activeTab = 0
        fi

        @let tabNames = $this.tabNames
        @let widgetPositions = $this.widgetPositions
        @let idx = $widgets.size

        $widgets.add $widget
        $tabNames.add "${name}"
        $widgetPositions.set $widget "${idx}"
    }

    function TabsWidget.initialize()
    {
        @let coordinator = $this.coordinator
        @let widgets = $this.widgets

        while @iterate @of $this.widgets @in widget; do
            $coordinator.deactivateWidget $widget
            $coordinator.makeWidgetInvisible $widget
        done

        @let activeTab = $this.activeTab
        if (( activeTab >= 0 )); then
            $this.selectTab "${activeTab}"
        fi
    }

    function TabsWidget.selectTab()
    {
        local tab="${1}"

        @let coordinator = $this.coordinator
        @let previousActive = $this.activeTab

        if (( previousActive >= 0 )); then
            @let previousWidget = $this.activeWidget
            if [[ -n $previousWidget ]]; then
                $coordinator.deactivateWidget $previousWidget
                $coordinator.makeWidgetInvisible $previousWidget
            fi
        fi

        @let widgets = $this.widgets
        @let newWidget = $widgets.get "${tab}"

        $this.activeTab = "${tab}"

        @let activeOne = $this.activeOne
        $activeOne.set 0 $newWidget

        $this.activeWidget = $newWidget
        $coordinator.activateWidget $newWidget
        $coordinator.makeWidgetVisible $newWidget
    }

    function TabsWidget.selectWidget()
    {
        local widget="${1}"

        @let idx = $widgetPositions.get $widget
        $this.selectTab "${idx}"
    }

    function TabsWidget.selectNextTab()
    {
        @let tab = $this.activeTab

        @let widgets = $this.widgets
        @let tabsNum = $widgets.size

        if (( ++tab >= tabsNum )); then
            tab=0
        fi

        $this.selectTab "${tab}"
    }

    function TabsWidget.selectPrevTab()
    {
        @let tab = $this.activeTab

        @let widgets = $this.widgets
        @let tabsNum = $widgets.size

        if (( --tab < 0 )); then
            tab=$(( tabsNum - 1 ))
        fi

        $this.selectTab "${tab}"
    }

    function TabsWidget.childrenWidgets()
    {
        @returning @of $this.widgets
    }

    function TabsWidget.operativeChildrenWidget()
    {
        @returning @of $this.activeOne
    }

    function TabsWidget.calculateMinSize()
    {
        local calculator="${1}"

        local maxWidth=0
        while @iterate @of $this.tabNames @in tabName; do
            (( maxWidth += ( ${#tabName} + 10 ) ))
        done

        local maxHeight=-1
        while @iterate @of $this.widgets @in children; do
            $calculator.calculateMinSize $children

            @let maxWidth = $calculator.greaterWidth "${maxWidth}"
            @let maxHeight = $calculator.greaterHeight "${maxHeight}"
        done

        (( ++maxHeight ))

        $calculator.setupSize "${maxWidth}" "${maxHeight}"
    }

    function TabsWidget.processKeyboardEvent()
    {
        local event="${1}"
        local isDirect="${2}"

        if $isDirect && @true $event.consumeWhenCommandRequested 'down' 'right'; then
            $this.selectNextTab
        elif $isDirect && @true $event.consumeWhenCommandRequested 'up' 'left'; then
            $this.selectPrevTab
        fi
    }

   function TabsWidget.organizeChildrenOnLayout()
    {
        local context="${1}"
        local widgetsLayout="${2}"

        @let x1 = $context.x1
        @let y1 = $context.y1
        @let width = $context.width
        @let height = $context.height

        (( ++y1 ))
        (( --height ))

        while @iterate @of $this.widgets @in children; do
            $widgetsLayout.setupContextWindow $children \
                "${x1}" "${y1}" "${width}" "${height}"
        done
    }

    function TabsWidget.draw()
    {
        local context="${1}"
        local canvas="${2}"
        local widgetsLayout="${3}"

        @let activeWidget = $this.activeWidget
        @let activeTab = $this.activeTab

        if [[ -z "${activeWidget}" ]] || [[ -z "${activeTab}" ]]; then
            return
        fi

        @let printer = $this.printer
        @let x1 = $context.x1
        @let y1 = $context.y1

        @let isFocused = $context.focusedFlag
        @let isHighlighted = $context.isHighlighted
        @let activeColor = @pixel_modes.white
        @let inactiveColor = @pixel_modes.dGray

        @let tabNames = $this.tabNames
        @let tabNamesSize = $tabNames.size


        (( ++x1 ))
        if $isHighlighted; then
            if $isFocused; then
                local idx=0
                while (( idx < tabNamesSize )); do
                    @let tabName = $tabNames.get "${idx}"
                    if (( idx++ == activeTab )); then
                        $printer.printText $canvas "${x1}" "${y1}" "[ < ${tabName} > ]" "${activeColor}"
                        (( x1 += ${#tabName} ))
                        (( x1 += 10 ))
                    else
                        $printer.printText $canvas "${x1}" "${y1}" "[ ${tabName} ]" "${inactiveColor}"
                        (( x1 += ${#tabName} ))
                        (( x1 += 6 ))
                    fi
                done
            else
                local idx=0
                while (( idx < tabNamesSize )); do
                    @let tabName = $tabNames.get "$(( idx++ ))"

                    $printer.printText $canvas "${x1}" "${y1}" "[ ${tabName} ]" "${inactiveColor}"
                    (( x1 += ${#tabName} ))
                    (( x1 += 6 ))
                done
            fi
        else
            local idx=0
            while (( idx < tabNamesSize )); do
                @let tabName = $tabNames.get "${idx}"
                if (( idx++ == activeTab )); then
                    $printer.printText $canvas "${x1}" "${y1}" "| ${tabName} |" "${activeColor}" "${inactiveColor}"
                    (( x1 += ${#tabName} ))
                    (( x1 += 6 ))
                else
                    $printer.printText $canvas "${x1}" "${y1}" "| ${tabName} |" "${inactiveColor}"
                    (( x1 += ${#tabName} ))
                    (( x1 += 6 ))
                fi
            done
        fi

        $widgetsLayout.drawWidget $activeWidget $canvas
    }

@classdone