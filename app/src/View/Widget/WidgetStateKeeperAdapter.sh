#!/usr/bin/env bash

@class WidgetStateKeeperAdapter @implements WidgetStateKeeper

    @var Map widget2Bindings

    function WidgetStateKeeperAdapter()
    {
        @let $this.widget2Bindings = @maps.make
    }

    function WidgetStateKeeperAdapter.setupWidgetBindings()
    {
        local widget="${1}"
        local bindingMap="${2}"

        @let widget2Bindings = $this.widget2Bindings
        $widget2Bindings.set $widget $bindingMap

        if ! @is $widget StatefulWidget; then
            besharp.runtime.error "$widget ( $( besharp.rtti.objectType $widget ) ) is expected to implement StatefulWidget interface!"
        fi

        $widget.bindWidgetState $this
    }

    function WidgetStateKeeperAdapter.writeWidgetState()
    {
        local widget="${1}"
        local key="${2}"
        local value="${3}"

        @let widget2Bindings = $this.widget2Bindings
        @let bindingMap = $widget2Bindings.get $widget
        @let field = $bindingMap.get "${key}"

        ${field} = "${value}"
    }

    function WidgetStateKeeperAdapter.requestWidgetEvent()
    {
        local widget="${1}"
        local key="${2}"
        local payload="${3:-}"

        @let widget2Bindings = $this.widget2Bindings
        @let bindingMap = $widget2Bindings.get $widget
        @let callback = $bindingMap.get "${key}"

        ${callback} "${payload}"
    }

    function WidgetStateKeeperAdapter.readWidgetState()
    {
        local widget="${1}"
        local key="${2}"
        local default="${3}"

        @let widget2Bindings = $this.widget2Bindings
        @let bindingMap = $widget2Bindings.get $widget
        if @false $bindingMap.hasKey "${key}"; then
              @returning "${default}"
              return
        fi

        @let field = $bindingMap.get "${key}"

        @returning @of ${field}
    }


@classdone