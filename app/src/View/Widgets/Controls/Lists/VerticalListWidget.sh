#!/usr/bin/env bash

@class VerticalListWidget @extends BaseListWidget

    function VerticalListWidget()
    {
        @parent "up" "down"
    }

    function VerticalListWidget.calculateMinSize()
    {
        local calculator="${1}"

        $calculator.setupSize 22 13
    }

    function VerticalListWidget.processLayoutChanges()
    {
        local context="${1}"
        local layout="${2}"

        local itemSize="3"
        @let y1 = $context.y1
        @let height = $context.height

        (( height -= 4 )) || true

        @let itemsList = $this.itemsList
        @let itemsListSize = $itemsList.size

        local totalSlide="$(( itemsListSize * itemSize ))"
        local maxSlide="$(( totalSlide - height - 1 ))"

        if (( maxSlide < 0 )); then
            $this.maxSlide = 0
            return
        fi

        (( maxSlide /= itemSize )) || true
        (( maxSlide *= itemSize )) || true

        $this.maxSlide = "${maxSlide}"

        @let currentSlide = $this.currentSlide
        if (( currentSlide > maxSlide )); then
            $this.slideAnimationTo "${maxSlide}"
        fi
    }

    function VerticalListWidget.draw()
    {
        local context="${1}"
        local canvas="${2}"
        local widgetsLayout="${3}"

        @let canvasPrinter = $this.canvasPrinter

        @let height = $context.height
        @let x1 = $context.x1
        @let y1 = $context.y1

        @let buttonStyle = @pixel_modes.bgDGray
        @let selButtonStyle = @pixel_modes.bgLGray
        @let color1 = @pixel_modes.lYellow
        @let color2 = @pixel_modes.dGray
        @let dotsColor = @pixel_modes.dGray

        local style="${buttonStyle}${color1}"
        local selectedStyle="${selButtonStyle}${color2}"

        @let currentItemIdx = $this.currentItemIdx
        @let isFocused = $context.focusedFlag
        @let slideAnimationFrame = $this.slideAnimationFrame
        @let slideAnimationData = $this.slideAnimationData
        @let slide = $slideAnimationData.get "${slideAnimationFrame}"
        $this.currentSlide = "${slide}"

        # ' ...'
        local moreIndicatorPlacement="0"
        local y="${y1}"

        (( height -= 3 )) # padding and dots

        local toSlideDown=0
        local toSlide=0
        local idx=-1
        local showDots=false
        local itemSize="3"

        @let itemsList = $this.itemsList
        @let itemsListSize = $itemsList.size
        local itemsListIdx=0
        while (( itemsListIdx < itemsListSize )) ; do
            @let item = $itemsList.get "$(( itemsListIdx++ ))"

            if (( ++idx == currentItemIdx )); then
                local isCurrentItem=true
            else
                local isCurrentItem=false
            fi


            # when item is being after the visible space
            if (( y - slide > y1 + height )); then
                showDots=true
                if $isCurrentItem && (( slideAnimationFrame == 0 )); then
                    $this.slideAnimationTo "${toSlide}"
                    $widgetsLayout.needsRedraw = true
                fi

                (( y+= itemSize ))
                continue
            fi

            # when item is being before visible space
            if (( y - slide < y1 )); then
                if $isCurrentItem && (( slideAnimationFrame == 0 )); then
                    $this.slideAnimationTo "${toSlide}"
                    $widgetsLayout.needsRedraw = true
                fi
            else
                # when item is being at visible space

                if $isCurrentItem; then
                    if $isFocused; then
                        $canvasPrinter.printText $canvas "${x1}" "$(( y - slide ))" " -${item}- " "${selectedStyle}"
                    else
                        $canvasPrinter.printText $canvas "${x1}" "$(( y - slide ))" "  ${item}  " "${selectedStyle}"
                    fi
                else
                    $canvasPrinter.printText $canvas "${x1}" "$(( y - slide ))" "  ${item}  " "${style}"
            fi

                moreIndicatorPlacement="$(( y - slide + 2 ))"
            fi

            (( toSlide += itemSize ))
            (( y+= itemSize ))
        done

        if $showDots; then
            $canvasPrinter.printText $canvas "${x1}" "${moreIndicatorPlacement}" "..." "${dotsColor}"
        fi
    }

@classdone



