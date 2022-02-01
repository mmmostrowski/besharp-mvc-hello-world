#!/usr/bin/env bash

@class WidgetsFactory @implements Factory

    @var @inject WidgetsTree widgetsTree

    function WidgetsFactory.create()
    {
        local widgetClassName="${1}"
        shift 1

        @let widgetsTree = $this.widgetsTree

        @let newWidget = @new "${widgetClassName}" "${@}"
        $widgetsTree.addWidget $newWidget false

        @returning $newWidget
    }

@classdone
