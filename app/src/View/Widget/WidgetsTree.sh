#!/usr/bin/env bash

@class WidgetsTree

    @var Set widgets

    @var Map parentWidgets

    function WidgetsTree()
    {
        @let $this.widgets = @sets.make
        @let $this.parentWidgets = @maps.make
    }

    function WidgetsTree.addWidget()
    {
        local widget="${1}"
        local active="${2:-true}"

        @let widgets = $this.widgets
        $widgets.add $widget

        if @is $widget ContainerWidget; then
            $this.setupContainerWidget $widget
        fi
    }

    function WidgetsTree.setupContainerWidget()
    {
        local parent="${1}"

        @let parentWidgets = $this.parentWidgets

        while @iterate @of $parent.childrenWidgets @in child; do
            $parentWidgets.set $child $parent
        done
    }

    function WidgetsTree.walkDownTree()
    {
        local widget="${1}"
        local callback="${2}"
        shift 2

        "${callback}" $widget "${@}"

        if @is $widget ContainerWidget; then
            while @iterate @of $widget.childrenWidgets @in child; do
                $this.walkDownTree $child "${callback}" "${@}"
            done
        fi
    }

    function WidgetsTree.walkDownTreeOperatives()
    {
        local widget="${1}"
        local callback="${2}"
        shift 2

        "${callback}" $widget "${@}"

        if @is $widget ContainerWidget; then
            while @iterate @of $widget.operativeChildrenWidget @in child; do
                $this.walkDownTreeOperatives $child "${callback}" "${@}"
            done
        fi
    }

    function WidgetsTree.walkUpTree()
    {
        local widget="${1}"
        local callback="${2}"
        shift 2

        "${callback}" $widget "${@}"
        
        @let parentWidgets = $this.parentWidgets
        if @true $parentWidgets.hasKey $widget; then
            @let parent = $parentWidgets.get $widget
            $this.walkUpTree $parent "${callback}" "${@}"
        fi
    }

    function WidgetsTree.walkUpTreeUntil()
    {
        local widget="${1}"
        local callback="${2}"
        shift 2

        @let continue = "${callback}" $widget "${@}"
        if $continue; then
            @let parentWidgets = $this.parentWidgets
            if @true $parentWidgets.hasKey $widget; then
                @let parent = $parentWidgets.get $widget
                $this.walkUpTree $parent "${callback}" "${@}"
            fi
        fi
    }

@classdone



