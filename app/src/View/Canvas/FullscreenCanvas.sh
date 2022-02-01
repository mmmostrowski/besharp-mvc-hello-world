#!/usr/bin/env bash

@class FullscreenCanvas @extends AbstractCanvas

    @var resizeOnNextFrame = true

    function FullscreenCanvas()
    {
        @parent

        trap $this.onWindowsSizeUpdate WINCH 
    }

    function FullscreenCanvas.setupMinimalSize()
    {
        @parent "${@}"

        $this.setupTerminalWindow
    }

    function FullscreenCanvas.initialize()
    {
        @parent
        $this.setupTerminalWindow
    }

    function FullscreenCanvas.onWindowsSizeUpdate()
    {
        $this.clearTerminal
        $this.resizeOnNextFrame = true
    }

    function FullscreenCanvas.beginFrame()
    {
        if @true $this.resizeOnNextFrame; then
            $this.resizeOnNextFrame = false
            $this.clearTerminal
            $this.setupTerminalWindow
        fi
        @parent
    }

    function FullscreenCanvas.setupTerminalWindow()
    {
        local terminalWidth=$( tput cols 2> /dev/null || true)
        local terminalHeight=$( tput lines 2> /dev/null || true )

        terminalWidth="${terminalWidth:-80}"
        terminalHeight="${terminalHeight:-25}"

        @let minWidth = $this.minWidth
        @let minHeight = $this.minHeight

        local width="${terminalWidth}"
        if (( terminalWidth < minWidth )); then
            width="${minWidth}"
        fi

        local height="${terminalHeight}"
        if (( terminalHeight < minHeight )); then
            height="${minHeight}"
        fi

        $this.width = "${width}"
        $this.w2 = "$(( width * 2 ))"
        $this.height = "${height}"

        $this.setupClearBuffer "${width}" "${height}"

        @let pixelBuffer = $this.pixelBuffer

        local y=0
        local body=
        local cell=0
        local cellStep=$(( ( width - terminalWidth ) * 2 ))
        while (( ++y <= terminalHeight )); do
            local x=-1

            local linePrinter=''
            while (( ++x < terminalWidth )); do
                # mode
                linePrinter+="\${$pixelBuffer[${cell}]}"
                (( ++cell ))
                # pixel
                linePrinter+="\${$pixelBuffer[${cell}]}"
                (( ++cell ))
            done

            (( cell += cellStep ))

            body+="echo -en \"\033[${y};1H${linePrinter}\";"
        done

        eval "function FullscreenCanvas.renderQuick() { ${body} }"
    }

    function FullscreenCanvas.render()
    {
        # performance trick: body of below function is being changed on every terminal size change
        FullscreenCanvas.renderQuick
    }

@classdone

