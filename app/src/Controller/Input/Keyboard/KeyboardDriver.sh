#!/usr/bin/env bash

@class KeyboardDriver

    function KeyboardDriver.waitForKeys()
    {
        local finalInput=

        read -s -r -N1 finalInput || true

        if [[ "${finalInput}" == $'\x1b' ]]; then
            local input2
            read -s -r -d '' -t 0.00005 -N2 input2 || true

            finalInput+="${input2}"

            # when captured mouse event
            if [[ "${input2}" == $'\x5b\x4d' ]]; then
                local input3
                read -s -r -d '' -t 0.00005 -N3 input3 || true

                finalInput+="${input3}"
            fi
        fi

        @returning "${finalInput}"
    }

    function KeyboardDriver.scanKeys()
    {
        local finalInput=

        local input=
        while true; do
            read -s -r -d '' -t 0.00005 -N1 input || true
            if [[ "${input}" == $'\x1b' ]]; then
                local input2
                read -s -r -d '' -t 0.00005 -N2 input2 || true
                input+="${input2}"

                # when captured mouse event
                if [[ "${input2}" == $'\x5b\x4d' ]]; then
                    local input3
                    read -s -r -d '' -t 0.00005 -N3 input3 || true

                    input+="${input3}"
                fi
            fi

            if [[ -n "${input}" ]]; then
                finalInput="${input}"
            else
                break
            fi
        done

        @returning "${finalInput}"
    }

@classdone