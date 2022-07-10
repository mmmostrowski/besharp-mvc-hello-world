#!/usr/bin/env bash

@class CanvasPrinter

    function CanvasPrinter.printText()
    {
        local canvas="${1}"
        local x="${2}"
        local y="${3}"
        local text="${4}"
        shift 4

        @let bgBlack = @pixel_modes.bgBlack

        local i
        for (( i=0; i < ${#text}; i++ )); do
            $canvas.putPixel "$(( x++ ))" "${y}" "${text:$i:1}" "${bgBlack}" "${@}"
        done
    }

    function CanvasPrinter.printSparseText()
    {
        local canvas="${1}"
        local x="${2}"
        local y="${3}"
        local text="${4}"
        shift 4

        @let bgBlack = @pixel_modes.bgBlack

        local i
        local c=
        for (( i=0; i < ${#text}; i++ )); do
            c="${text:$i:1}"
            if [[ "${c}" == ' ' ]]; then
                (( x++ ))
                continue
            fi
            $canvas.putPixel "$(( x++ ))" "${y}" "${c}" "${bgBlack}" "${@}"
        done
    }

    function CanvasPrinter.printFrame()
    {
        local canvas="${1}"
        local x1="${2}"
        local y1="${3}"
        local width="${4}"
        local height="${5}"
        shift 5

        @let color = @pixel_modes.dGray

        $canvas.putPixelsHoriz "$(( x1 + 1 ))" "${y1}" "$(( width - 2 ))" "-" "${@}" "${color}"
        $canvas.putPixelsHoriz "$(( x1 + 1 ))" $(( y1 + height - 1)) "$(( width - 2 ))" "-" "${@}" "${color}"

        $canvas.putPixelsVert "${x1}" "$(( y1 + 1 ))" "$(( height - 2 ))" "|" "${@}" "${color}"
        $canvas.putPixelsVert $(( x1 + width - 1 )) "$(( y1 + 1 ))" "$(( height - 2 ))" "|" "${@}" "${color}"
    }

    function CanvasPrinter.printHighlightFrame()
    {
        local canvas="${1}"
        local x1="${2}"
        local y1="${3}"
        local width="${4}"
        local height="${5}"
        shift 5

        @let color = @pixel_modes.white

        $canvas.putPixelsHoriz "$(( x1 + 1 ))" "${y1}" "$(( width - 2 ))" "=" "${@}" "${color}"
        $canvas.putPixelsHoriz "$(( x1 + 1 ))" $(( y1 + height - 1)) "$(( width - 2 ))" "=" "${@}" "${color}"

        $canvas.putPixelsVert "${x1}" "$(( y1 + 1 ))" "$(( height - 2 ))" "[" "${@}" "${color}"
        $canvas.putPixelsVert $(( x1 + width - 1 )) "$(( y1 + 1 ))" "$(( height - 2 ))" "]" "${@}" "${color}"
    }

@classdone

