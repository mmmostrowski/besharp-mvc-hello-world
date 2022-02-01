#!/usr/bin/env bash

@abstract @class AbstractCanvas @implements Canvas

    @var @inject Cursor cursor

    @var ArrayVector pixelBuffer
    @var ArrayVector pixelBufferClean

    @var width=0
    @var height=0
    @var minWidth=0
    @var minHeight=0
    @var w2=0

    function AbstractCanvas()
    {
        @let $this.pixelBuffer = @new ArrayVector
        @let $this.pixelBufferClean = @new ArrayVector
    }

    @abstract function AbstractCanvas.render

    function AbstractCanvas.setupMinimalSize()
    {
        $this.minWidth = "${1}"
        $this.minHeight = "${2}"
    }

    function AbstractCanvas.initialize()
    {
        besharp.addShutdownCallback 'canvas_restore_terminal' $this.restoreTerminal

        $this.clearTerminal
    }

    function AbstractCanvas.clearTerminal()
    {
        local cursorMode="${1:-cursor-hide}"

        @let cursor = $this.cursor
        $cursor.clearAndMoveTo0x0

        if [[ "${cursorMode}" == "cursor-hide" ]]; then
            $cursor.hide
        else
            $cursor.show
        fi
    }

    function AbstractCanvas.restoreTerminal()
    {
        @let cursor = $this.cursor
        $cursor.show
    }

    function AbstractCanvas.beginFrame()
    {
        $this.clearBuffer
    }

    function AbstractCanvas.setupClearBuffer()
    {
        local width="${1}"
        local height="${2}"

        @let pixelBufferClean = $this.pixelBufferClean
        @let modeReset = @pixel_modes.reset

        $pixelBufferClean.removeAll
        local total=$(( width * height))
        local cell=0
        while (( total-- )); do
            eval "$pixelBufferClean[$cell]=\"\${modeReset}\""
            (( ++cell ))
            eval "$pixelBufferClean[$cell]=' '"
            (( ++cell ))
        done
    }

    function AbstractCanvas.clearBuffer()
    {
        @let pixelBufferClean = $this.pixelBufferClean
        @let pixelBuffer = $this.pixelBuffer

        eval "$pixelBuffer=( \"\${$pixelBufferClean[@]}\" )"
    }

    function AbstractCanvas.putPixel()
    {
        local x="${1}"
        local y="${2}"
        local char="${3}"
        shift 3

        eval "
            local modes=\"\${*:-\e[0m}\"
            local pixelBuffer=\"\${${this}_pixelBuffer}\"
            local cell=\$(( ( y * ${this}_width + x ) * 2 ))
        "

        eval "$pixelBuffer[\${cell}]=\"\${modes// /}\""
        eval "$pixelBuffer[\${cell} + 1]=\"\${char}\""
    }

    function AbstractCanvas.putPixelModes()
    {
        local x="${1}"
        local y="${2}"
        shift 2

        eval "
            local modes=\"\${*:-\e[0m}\"
            local pixelBuffer=\"\${${this}_pixelBuffer}\"
        "
        eval "$pixelBuffer[\$(( ( y * ${this}_width + x ) * 2 ))]=\"\${modes// /}\""
    }

    function AbstractCanvas.putPixelChar()
    {
        local x="${1}"
        local y="${2}"
        local char="${3}"

        eval "
            local pixelBuffer=\"\${${this}_pixelBuffer}\"
        "

        eval "$pixelBuffer[\$(( ( y * ${this}_width + x ) * 2 + 1 ))]=\"\${char}\""
    }

    function AbstractCanvas.putPixelsHoriz()
    {
        local x="${1}"
        local y="${2}"
        local num="${3}"
        local char="${4}"
        shift 4

        eval "
            local modes=\"\${*:-\e[0m}\"
            local pixelBuffer=\"\${${this}_pixelBuffer}\"
        "

        eval "
            local cell=\$(( ( y * ${this}_width + x ) * 2 ))
            while (( num-- > 0 )); do
                $pixelBuffer[cell]=\"\${modes// /}\"
                $pixelBuffer[cell + 1]=\"\${char}\"
                (( cell += 2))
            done
        "
    }

    function AbstractCanvas.putPixelsHorizChar()
    {
        local x="${1}"
        local y="${2}"
        local num="${3}"
        local char="${4}"

        eval "
            local modes=\"\${*:-\e[0m}\"
            local pixelBuffer=\"\${${this}_pixelBuffer}\"
        "

        eval "
            local cell=\$(( ( y * ${this}_width + x ) * 2 ))
            while (( num-- > 0 )); do
                $pixelBuffer[cell + 1]=\"\${char}\"
                (( cell += 2))
            done
        "
    }

    function AbstractCanvas.putPixelsHorizModes()
    {
        local x="${1}"
        local y="${2}"
        local num="${3}"
        shift 3

        eval "
            local modes=\"\${*:-\e[0m}\"
            local pixelBuffer=\"\${${this}_pixelBuffer}\"
        "

        eval "
            local cell=\$(( ( y * ${this}_width + x ) * 2 ))
            while (( num-- > 0 )); do
                $pixelBuffer[cell]=\"\${modes// /}\"
                (( cell += 2))
            done
        "
    }

    function AbstractCanvas.putPixelsVert()
    {
        local x="${1}"
        local y="${2}"
        local num="${3}"
        local char="${4}"
        shift 4

        eval "
            local modes=\"\${*:-\e[0m}\"
            local pixelBuffer=\"\${${this}_pixelBuffer}\"
        "
        eval "
            local cell=\$(( ( y * ${this}_width + x ) * 2 ))
            while (( num-- > 0 )); do
                $pixelBuffer[ cell ]=\"\${modes// /}\"
                $pixelBuffer[ cell + 1 ]=\"\${char}\"
                (( cell += ( ${this}_w2 ) ))
            done
        "
    }

    function AbstractCanvas.putPixelsVertChar()
    {
        local x="${1}"
        local y="${2}"
        local num="${3}"
        local char="${4}"

        eval "
            local pixelBuffer=\"\${${this}_pixelBuffer}\"
        "
        eval "
            local cell=\$(( ( y * ${this}_width + x ) * 2 ))
            while (( num-- > 0 )); do
                $pixelBuffer[ cell + 1 ]=\"\${char}\"
                (( cell += ( ${this}_w2 ) ))
            done
        "
    }

    function AbstractCanvas.putPixelsVertModes()
    {
        local x="${1}"
        local y="${2}"
        local num="${3}"
        shift 3

        eval "
            local modes=\"\${*:-\e[0m}\"
            local pixelBuffer=\"\${${this}_pixelBuffer}\"
        "
        eval "
            local cell=\$(( ( y * ${this}_width + x ) * 2 ))
            while (( num-- > 0 )); do
                $pixelBuffer[ cell ]=\"\${modes// /}\"
                (( cell += ( ${this}_w2 ) ))
            done
        "
    }

    function AbstractCanvas.putPixelsBox()
    {
        local x="${1}"
        local y="${2}"
        local width="${3}"
        local height="${4}"
        local char="${5}"
        shift 5

        eval "
            local modes=\"\${*:-\e[0m}\"
            modes=\"\${modes// /}\"
            local pixelBuffer=\"\${${this}_pixelBuffer}\"
        "

        local rest=$(( width % 8 ))
        width=$(( width / 8 ))
        local line=$height

        eval "
            local cell=\$(( ( y * ${this}_width + x ) * 2 ))
            while (( line-- )); do
                local i=\${width}
                local c=\${cell}
                while (( i-- )); do
                   $pixelBuffer[ c + 0 ]=\"\${modes}\"
                   $pixelBuffer[ c + 2 ]=\"\${modes}\"
                   $pixelBuffer[ c + 4 ]=\"\${modes}\"
                   $pixelBuffer[ c + 6 ]=\"\${modes}\"
                   $pixelBuffer[ c + 8 ]=\"\${modes}\"
                   $pixelBuffer[ c + 10 ]=\"\${modes}\"
                   $pixelBuffer[ c + 12 ]=\"\${modes}\"
                   $pixelBuffer[ c + 14 ]=\"\${modes}\"
                   $pixelBuffer[ c + 1 ]=\"\${char}\"
                   $pixelBuffer[ c + 3 ]=\"\${char}\"
                   $pixelBuffer[ c + 5 ]=\"\${char}\"
                   $pixelBuffer[ c + 7 ]=\"\${char}\"
                   $pixelBuffer[ c + 9 ]=\"\${char}\"
                   $pixelBuffer[ c + 11 ]=\"\${char}\"
                   $pixelBuffer[ c + 13 ]=\"\${char}\"
                   $pixelBuffer[ c + 15 ]=\"\${char}\"
                   (( c += 16 ))
                done
                (( cell += ${this}_w2 ))
            done
        "

        if (( rest == 0 )); then
            return
        fi

        (( x += ( width * 8 ) ))
        width=$rest

        eval "
            local cell=\$(( ( y * ${this}_width + x ) * 2 ))
            while (( height-- )); do
                local i=\${width}
                local c=\${cell}
                while (( i-- )); do
                   $pixelBuffer[ c + 0 ]=\"\${modes// /}\"
                   $pixelBuffer[ c + 1 ]=\"\${char}\"
                   (( c += 2 ))
                done
                (( cell += ${this}_w2 ))
            done
        "
    }

    function AbstractCanvas.putPixelsBoxChar()
    {
        local x="${1}"
        local y="${2}"
        local width="${3}"
        local height="${4}"
        local char="${5}"

        eval "
            local pixelBuffer=\"\${${this}_pixelBuffer}\"
        "

        local rest=$(( width % 8 ))
        width=$(( width / 8 ))
        local line=$height

        eval "
            local cell=\$(( ( y * ${this}_width + x ) * 2 + 1 ))
            while (( line-- )); do
                local i=\${width}
                local c=\${cell}
                while (( i-- )); do
                   $pixelBuffer[ c ]=\"\${char}\"
                   $pixelBuffer[ c + 2 ]=\"\${char}\"
                   $pixelBuffer[ c + 4 ]=\"\${char}\"
                   $pixelBuffer[ c + 6 ]=\"\${char}\"
                   $pixelBuffer[ c + 8 ]=\"\${char}\"
                   $pixelBuffer[ c + 10 ]=\"\${char}\"
                   $pixelBuffer[ c + 12 ]=\"\${char}\"
                   $pixelBuffer[ c + 14 ]=\"\${char}\"
                   (( c += 16 ))
                done
                (( cell += ${this}_w2 ))
            done
        "

        if (( rest == 0 )); then
            return
        fi

        (( x += ( width * 8 ) ))
        width=$rest

        eval "
            local cell=\$(( ( y * ${this}_width + x ) * 2 + 1 ))
            while (( height-- )); do
                local i=\${width}
                local c=\${cell}
                while (( i-- )); do
                   $pixelBuffer[ c ]=\"\${char}\"
                   (( c += 2 ))
                done
                (( cell += ${this}_w2 ))
            done
        "
    }

    function AbstractCanvas.putPixelsBoxModes()
    {
        local x="${1}"
        local y="${2}"
        local width="${3}"
        local height="${4}"
        shift 4

        eval "
            local modes=\"\${*:-\e[0m}\"
            modes=\"\${modes// /}\"
            local pixelBuffer=\"\${${this}_pixelBuffer}\"
        "

        local rest=$(( width % 8 ))
        width=$(( width / 8 ))
        local line=$height

        eval "
            local cell=\$(( ( y * ${this}_width + x ) * 2 ))
            while (( line-- )); do
                local i=\${width}
                local c=\${cell}
                while (( i-- )); do
                   $pixelBuffer[ c + 0 ]=\"\${modes}\"
                   $pixelBuffer[ c + 2 ]=\"\${modes}\"
                   $pixelBuffer[ c + 4 ]=\"\${modes}\"
                   $pixelBuffer[ c + 6 ]=\"\${modes}\"
                   $pixelBuffer[ c + 8 ]=\"\${modes}\"
                   $pixelBuffer[ c + 10 ]=\"\${modes}\"
                   $pixelBuffer[ c + 12 ]=\"\${modes}\"
                   $pixelBuffer[ c + 14 ]=\"\${modes}\"
                   (( c += 16 ))
                done
                (( cell += ${this}_w2 ))
            done
        "

        if (( rest == 0 )); then
            return
        fi

        (( x += ( width * 8 ) ))
        width=$rest

        eval "
            local cell=\$(( ( y * ${this}_width + x ) * 2 ))
            while (( height-- )); do
                local i=\${width}
                local c=\${cell}
                while (( i-- )); do
                   $pixelBuffer[ c + 0 ]=\"\${modes// /}\"
                   (( c += 2 ))
                done
                (( cell += ${this}_w2 ))
            done
        "
    }

@classdone

