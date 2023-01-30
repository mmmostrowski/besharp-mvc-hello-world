#!/usr/bin/env bash

@class WidgetsLayout @implements WidgetContextProvider

    @var @inject WidgetsTree tree
    @var @inject WidgetMonitor monitor

    @var Map widget2FocusIndex
    @var Map widget2Context
    @var Map context2Widget
    @var Map widgetId2widget

    @var lastSize
    @var needsUpdate = true
    @var needsRedraw = true


    function WidgetsLayout.initialize()
    {
        @let $this.widget2FocusIndex = @maps.make
        @let $this.widget2Context = @maps.make
        @let $this.context2Widget = @maps.make
        @let $this.widgetId2widget = @maps.make
    }

    function WidgetsLayout.addWidget()
    {
        local widget="${1}"
        local widgetId="${2}"

        @let newContext = @new WidgetDrawContext
        @let widget2FocusIndex = $this.widget2FocusIndex
        @let widget2Context = $this.widget2Context
        @let context2Widget = $this.context2Widget
        @let widgetId2widget = $this.widgetId2widget

        $newContext.widgetId = "${widgetId}"
        if @true $widgetId2widget.hasKey "${widgetId}"; then
            @let currentWidget = $widgetId2widget.get "${widgetId}"
            @let currentWidgetInfo = @widgets.info $currentWidget
            besharp.runtime.error "Widget id must be unique! '${widgetId}' widget id is already in use by: ${currentWidgetInfo}."
        fi
        $widgetId2widget.set "${widgetId}" $widget

        $widget2FocusIndex.set $widget -1
        $widget2Context.set $widget $newContext
        $context2Widget.set $newContext $widget
    }

    function WidgetsLayout.updateLayoutFor()
    {
        local widget="${1}"
        local canvas="${2}"

        @let w = $canvas.width
        @let h = $canvas.height

        if @false $this.needsUpdate; then
            @let lastSize = $this.lastSize
            $this.lastSize = "${w}x${h}"
            if [[ "${w}x${h}" == "${lastSize}" ]]; then
                return
            fi
        fi
        $this.needsUpdate = false


        @let widget2Context = $this.widget2Context
        @let context = $this.widgetContext $widget
        $context.setupWindow 0 0 "${w}" "${h}"

        @let tree = $this.tree
        $tree.walkDownTree $widget $this.updateChildrenLayout
    }

    function WidgetsLayout.updateChildrenLayout()
    {
        local widget="${1}"

        @let widget2Context = $this.widget2Context
        @let context = $widget2Context.get $widget

        @let placementLeft = $context.placementLeft
        @let placementUp = $context.placementUp
        @let placementRight = $context.placementRight
        @let placementDown = $context.placementDown

        if [[ "${placementLeft}" != '0' ]] || [[ "${placementRight}" != '0' ]] \
            || [[ "${placementUp}" != '0' ]] || [[ "${placementDown}" != '0' ]] \
        ; then
            $this.updateChildrenPlacementHorizontal $widget $context \
                  "${placementLeft}" "${placementRight}"

            $this.updateChildrenPlacementVertical $widget $context \
                  "${placementUp}" "${placementDown}"
        fi

        if @is $widget ContainerWidget; then
            $widget.organizeChildrenOnLayout $context $this
        fi

        if @is $widget LayoutChangesListenerWidget; then
            $widget.processLayoutChanges $context $this
        fi
    }

    function WidgetsLayout.updateChildrenPlacementHorizontal()
    {
        local widget="${1}"
        local context="${2}"
        local left="${3}"
        local right="${4}"

        if [[ "${left}" == '0' ]] && [[ "${right}" == '0' ]]; then
            return
        fi

        @let ctxX1 = $context.x1

        if [[ "${left}" == 'auto' ]]; then
            @let widgetWidth = $context.placementWidth
            if (( widgetWidth < 0 )); then
                if ! @is $widget WidgetWithSize; then
                     besharp.runtime.error "Widget $widget ( $( besharp.rtti.objectType $widget ) ) must implement WidgetWithSize interface to be able to use 'auto' placement!"
                fi
                @let widgetWidth = $widget.widgetWidth
            fi

            if [[ "${right}" == 'auto' ]]; then
                 # center
                 @let width = $context.width

                 $context.x1 = $(( ctxX1 + ( ( width - widgetWidth ) / 2 )))
                 $context.width = "${widgetWidth}"
             else
                 # align right
                 @let width = $context.width

                 $context.x1 = $(( ctxX1 + width - widgetWidth - right ))
                 $context.width = $(( right + widgetWidth ))
            fi
        else
            if [[ "${right}" == 'auto' ]]; then
                 # align left

                 @let widgetWidth = $context.placementWidth
                 if (( widgetWidth < 0 )); then
                     if ! @is $widget WidgetWithSize; then
                          besharp.runtime.error "Widget $widget ( $( besharp.rtti.objectType $widget ) ) must implement WidgetWithSize interface to be able to use '*' placement!"
                     fi
                     @let widgetWidth = $widget.widgetWidth
                 fi

                 $context.x1 = $(( ctxX1 + left ))

                 @let width = $context.width
                 $context.width = $(( left + widgetWidth ))
             else
                 # justify / frame
                 @let x1 = $context.x1
                 $context.x1 = $(( x1 + left))

                 @let width = $context.width
                 (( width -= ( left + right ) ))
                 $context.width = "${width}"
            fi
        fi
    }

    function WidgetsLayout.updateChildrenPlacementVertical()
    {
        local widget="${1}"
        local context="${2}"
        local up="${3}"
        local down="${4}"

        if [[ "${up}" == '0' ]] && [[ "${down}" == '0' ]]; then
            return
        fi

        @let ctxY1 = $context.y1

        if [[ "${up}" == 'auto' ]]; then
            @let widgetHeight = $context.placementHeight
            if (( widgetHeight < 0 )); then
                if ! @is $widget WidgetWithSize; then
                     besharp.runtime.error "Widget $widget ( $( besharp.rtti.objectType $widget ) ) must implement WidgetWithSize interface to be able to use '*' placement!"
                fi
                @let widgetHeight = $widget.widgetHeight
            fi

            if [[ "${down}" == 'auto' ]]; then
                 # center
                 @let height = $context.height

                 $context.y1 = $(( ctxY1 + ( ( height - widgetHeight ) / 2 ) ))
                 $context.height = "${widgetHeight}"
             else
                 # align down
                 @let height = $context.height

                 $context.y1 = $(( ctxY1 + height - widgetHeight - down ))
                 $context.height = $(( down + widgetHeight ))
            fi
        else
            if [[ "${down}" == 'auto' ]]; then
                 # align up
                 @let widgetHeight = $context.placementHeight
                 if (( widgetHeight < 0 )); then
                     if ! @is $widget WidgetWithSize; then
                          besharp.runtime.error "Widget $widget ( $( besharp.rtti.objectType $widget ) ) must implement WidgetWithSize interface to be able to use '*' placement!"
                     fi
                     @let widgetHeight = $widget.widgetHeight
                 fi

                 $context.y1 = $(( ctxY1 + up ))

                 @let height = $context.height
                 $context.height = $(( up + widgetHeight ))
             else
                 # justify / frame
                 @let y1 = $context.y1
                 $context.y1 = $(( y1 + up ))

                 @let height = $context.height
                 (( height -= ( up + down ) ))
                 $context.height = "${height}"
            fi
        fi
    }

    function WidgetsLayout.calculateCanvasMinimalSize()
    {
        local canvas="${1}"
        local widget="${2}"

        @let calculator = @new WidgetMinSizeCalculator

        $calculator.calculateMinSize $widget

        @let minWidth = $calculator.width
        @let minHeight = $calculator.height

        $canvas.setupMinimalSize "${minWidth}" "${minHeight}"

        @unset $calculator
    }

    function WidgetsLayout.drawWidget()
    {
        local widget="${1}"
        local canvas="${2}"

        @let monitor = $this.monitor
        if @false $monitor.isWidgetVisible $widget; then
            return
        fi

        @let widget2Context = $this.widget2Context
        @let context = $widget2Context.get $widget

        @let x1 = $context.x1
        @let y1 = $context.y1
        @let width = $context.width
        @let height = $context.height

        if (( width <= 0 )) || (( height <= 0 )) || (( x1 < 0 )) || (( y1 < 0 )); then
            return
        fi

        $widget.draw $context $canvas $this
    }

    function WidgetsLayout.widgetContext()
    {
        local widget="${1}"

        @let widget2Context = $this.widget2Context

        @returning @of $widget2Context.get $widget
    }

    function WidgetsLayout.widgetId()
    {
        local widget="${1}"

        @let widget2Context = $this.widget2Context
        @let context = $widget2Context.get $widget

        @returning @of $context.widgetId
    }

    function WidgetsLayout.setupContextWindow()
    {
        local widget="${1}"
        shift 1

        @let widget2Context = $this.widget2Context
        @let context = $widget2Context.get $widget

        $context.setupWindow "${@}"
    }

    function WidgetsLayout.setupWidgetFocusable()
    {
        local widget="${1}"
        local orderIndex="${2}"

        if ! @is $widget FocusableWidget; then
            besharp.runtime.error "Widget $widget ( $( besharp.rtti.objectType $widget ) ) is expected to be implementing FocusableWidget interface!"
        fi

        @let widget2FocusIndex = $this.widget2FocusIndex

        if @true $widget2FocusIndex.has "${orderIndex}"; then
            besharp.runtime.error "Widget $widget ( $( besharp.rtti.objectType $widget ) ) is expected to have unique focus order index! '${orderIndex}' is already taken!"
        fi

        $widget2FocusIndex.set $widget "${orderIndex}"
    }

    function WidgetsLayout.setupWidgetPlacement()
    {
        local widget="${1}"
        local placementLeft="${2}"
        local placementUp="${3}"
        local placementRight="${4}"
        local placementDown="${5}"
        local placementWidth="${6}"
        local placementHeight="${7}"


        @let widget2Context = $this.widget2Context
        @let context = $widget2Context.get $widget

        $context.placementLeft = "${placementLeft}"
        $context.placementRight = "${placementRight}"
        $context.placementUp = "${placementUp}"
        $context.placementDown = "${placementDown}"
        $context.placementWidth = "${placementWidth}"
        $context.placementHeight = "${placementHeight}"
    }

    function WidgetsLayout.widgetSortIndex()
    {
        local widget="${1}"
        @let widget2FocusIndex = $this.widget2FocusIndex

        @returning @of $widget2FocusIndex.get $widget
    }

    function WidgetsLayout.callWidgetAction()
    {
        local widget="${1}"
        local action="${2}"
        shift 2

        @let context = $this.widgetContext $widget
        $widget.${action} $context "${@}"
    }

@classdone