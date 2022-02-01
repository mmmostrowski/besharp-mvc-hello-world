#!/usr/bin/env bash

@class KeyboardKeys

    @var Map codeToKeys

    @var Map keys2commands

    function KeyboardKeys()
    {
        @let $this.codeToKeys = @maps.make \
            $'\x1b' "esc" \
            $'\x1b\x1b' "esc" \
            $'\x1b\x1b\x1b' "esc" \
            $'\x1b\x5b\x41' "up_arrow" \
            $'\x1b\x5b\x42' "down_arrow" \
            $'\x1b\x5b\x43' "right_arrow" \
            $'\x1b\x5b\x44' "left_arrow" \
            $'\x20' "space" \
            $'\x0a' "enter" \
            $'\x09' "tab" \
            $'\x1b\x5b\x5a' "shift_tab" \
            $'\x1b\x4f\x50' "f1" \
        ;

        @let $this.keys2commands = @maps.make \
            "esc" "escape" \
            "up_arrow" "up" \
            "down_arrow" "down" \
            "right_arrow" "right" \
            "left_arrow" "left" \
            "space" "action" \
            "enter" "action" \
            "tab" "next" \
            "shift_tab" "prev" \
            "f1" "help" \
        ;
    }

    function KeyboardKeys.keyFromInput()
    {
        local code="${1}"

        if [[ "${code}" =~ '`' ]] || [[ "${code}" =~ '"' ]]; then
            @returning "${code}"
            return
        fi

        @let codeToKeys = $this.codeToKeys
        if @false $codeToKeys.hasKey "${code}"; then
            @returning "${code}"
            return
        fi

        @returning @of $codeToKeys.get "${code}"
    }

    function KeyboardKeys.commandFromKey()
    {
        local key="${1}"

        @let keys2commands = $this.keys2commands
        if @true $keys2commands.hasKey "${key}"; then
            @returning @of $keys2commands.get "${key}"
        else
            @returning ''
        fi
    }

@classdone