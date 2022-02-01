#!/usr/bin/env bash

@class InputDriver

    @var @inject KeyboardDriver keyboard
    @var @inject KeyboardKeys keyboardKeys

    @var @inject MouseDriver mouse

    @var requestedCommand
    @var keyboardPressedKey
    @var mouseX
    @var mouseY
    @var mouseButtonLeft = false
    @var mouseButtonRight = false

    function InputDriver.enableMouseCapture()
    {
        @let mouse = $this.mouse
#        $mouse.enableMouseButtonsCapture
        $mouse.enableMouseMovementCapture
    }


    function InputDriver.waitForInput()
    {
        @let keyboard = $this.keyboard

        @let keyboardInput = $keyboard.waitForKeys

        $this.updateStatus "${keyboardInput}"
    }

    function InputDriver.scanInput()
    {
        @let keyboard = $this.keyboard

        @let keyboardInput = $keyboard.scanKeys

        $this.updateStatus "${keyboardInput}"
    }

    function InputDriver.updateStatus()
    {
        local input="${1}"

        if [[ "${input:0:3}" == $'\x1b\x5b\x4d' ]]; then
            @let mouse = $this.mouse
            $mouse.updateMouseStatus "${input}" "${this}"
        else
            if [[ -z "${input}" ]]; then
                $this.keyboardPressedKey = ""
                $this.requestedCommand = ""
                return
            fi

            @let keyboardKeys = $this.keyboardKeys
            @let keyboardPressedKey = $keyboardKeys.keyFromInput "${input}"
            @let $this.requestedCommand = $keyboardKeys.commandFromKey "${keyboardPressedKey}"

            $this.keyboardPressedKey = "${keyboardPressedKey}"
        fi
    }


    function InputDriver.isKeyboardKeyPressed()
    {
        local key="${1}"

        if @returned @of $this.keyboardPressedKey == "${key}"; then
            @returning true
        else
            @returning false
        fi
    }

    function InputDriver.isAnyKeyboardKeyPressed()
    {
        if @returned @of $this.keyboardPressedKey != ""; then
            @returning true
        else
            @returning false
        fi
    }

@classdone