#!/usr/bin/env bash

@static { @args  }
@class NamedArgs

    @var Map currentArgs

    function NamedArgs()
    {
        @let $this.currentArgs = @maps.make
    }

    function NamedArgs.make()
    {
        @let args = @vectors.make "${@}"

        @let markerIndex = $args.findIndex "@from"
        if (( markerIndex < 0 )); then
            besharp.runtime.error "Missing '@from' item!"
        fi

        $this.reset

        @let currentArgs = $this.currentArgs

        # register
        local i
        for (( i = 0; i < markerIndex; ++i )); do
            @let name = $args.get "${i}"
            $currentArgs.set "${name}" ""
        done

        # parse
        @let argsCount = $args.size
        for (( i = markerIndex + 1; i < argsCount; ++i )); do
            @let item = $args.get "${i}"
            if [[ "${item%:}" != "${item}" ]] && $currentArgs.hasKey "${item%:}"; then
                  @let currentVector = @vectors.make
                  $currentArgs.set "${item%:}" $currentVector
                  continue
            fi

            $currentVector.add "${item}"
        done

        @unset $args
    }

    function NamedArgs.requireVector()
    {
        local name="${1}"

        @let currentArgs = $this.currentArgs
        @let vector = $currentArgs.get "${name}"
        if [[ -z "${vector}" ]]; then
            besharp.runtime.error "Named argument '${name}:' is required!"
        fi

        @returning $vector
    }

    function NamedArgs.optionalVector()
    {
        local name="${1}"

        @let currentArgs = $this.currentArgs

        @let vector = $currentArgs.get "${name}"
        if [[ -z "${vector}" ]]; then
            @returning ''
            return
        fi

        @returning @of $currentArgs.get "${name}"
    }

    function NamedArgs.optionalInt()
    {
        local name="${1}"
        local default="${2}"

        @let currentArgs = $this.currentArgs

        @let vector = $currentArgs.get "${name}"
        if [[ -z "${vector}" ]] || @true $vector.isEmpty; then
            @returning "${default}"
            return
        fi

        @let vectorSize = $vector.size
        if (( vectorSize > 1 )); then
            besharp.runtime.error "'${name}' argument is expected to be a single number!"
        fi

        @let value = $vector.get 0
        if ! [[ "${value}" =~ ^[0-9]+$ ]]; then
            besharp.runtime.error "'${name}' argument is expected to be a number!"
        fi
        @returning "${value}"
    }

    function NamedArgs.optionalText()
    {
        local name="${1}"
        local default="${2}"

        @let currentArgs = $this.currentArgs

        @let vector = $currentArgs.get "${name}"
        if [[ -z "${vector}" ]] || @true $vector.isEmpty; then
            @returning "${default}"
            return
        fi

        @let vectorSize = $vector.size
        if (( vectorSize > 1 )); then
            besharp.runtime.error "'${name}' argument is expected to be a single item!"
        fi

        @returning @of $vector.get 0
    }

    function NamedArgs.reset()
    {
        @let currentArgs = $this.currentArgs

        while @iterate $currentArgs @in vector; do
            if [[ -z "${vector}" ]]; then
                continue
            fi
            @unset $vector
        done
        $currentArgs.removeAll
    }

@classdone