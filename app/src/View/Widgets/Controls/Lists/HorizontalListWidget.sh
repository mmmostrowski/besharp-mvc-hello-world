#!/usr/bin/env bash

@class HorizontalListWidget @extends BaseListWidget

    @var Stack slideChunks

    function HorizontalListWidget()
    {
        @parent "left" "right"
    }

    function HorizontalListWidget.initialize()
    {
        @parent

        @let $this.slideChunks = @collections.makeStack
    }

    function HorizontalListWidget.calculateMinSize()
    {
        local calculator="${1}"

        $calculator.setupSize 0 3
    }

    function HorizontalListWidget.processLayoutChanges()
    {
        local context="${1}"
        local layout="${2}"

        @let x1 = $context.x1
        @let width = $context.width

        (( width -= 8 )) || true # dots and padding


        @let slideChunks = $this.slideChunks
        $slideChunks.removeAll

        local totalSlide=0
        while @iterate @of $this.itemsList @in item; do
            local itemSize="$(( "${#item}" + 10 ))"

            $slideChunks.add "${itemSize}"

            (( totalSlide += itemSize ))
        done

        while @false $slideChunks.isEmpty; do
            @let itemSize = $slideChunks.current
            (( width -= itemSize )) || true
            if (( width < 0 )); then
                break
            fi
            $slideChunks.pull
        done

        local maxSlide=0
        while @false $slideChunks.isEmpty; do
            @let itemSize = $slideChunks.pull
            (( maxSlide += itemSize ))
        done

        $this.maxSlide = "${maxSlide}"

        @let currentSlide = $this.currentSlide
        if (( currentSlide > maxSlide )); then
            $this.slideAnimationTo "${maxSlide}"
        fi
    }

    function HorizontalListWidget.draw()
    {
        local context="${1}"
        local canvas="${2}"
        local widgetsLayout="${3}"

        @let canvasPrinter = $this.canvasPrinter

        @let x1 = $context.x1
        @let width = $context.width
        @let y0 = $context.y1
        local y1="$(( y0 + 1 ))"

        @let buttonStyle = @pixel_modes.bgDGray
        @let selButtonStyle = @pixel_modes.bgLGray
        @let color1 = @pixel_modes.lYellow
        @let color2 = @pixel_modes.dGray

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
        (( width -= 4 )) # padding


        local toSlideRight=0
        local toSlide=0
        local x="$(( x1 + 4  ))"
        local idx=-1
        local showDots=false
        @let itemsList = $this.itemsList
        @let itemsListSize = $itemsList.size
        local itemsListIdx=0
        while (( itemsListIdx < itemsListSize )) ; do
            @let item = $itemsList.get "$(( itemsListIdx++ ))"
            local itemSize="$(( "${#item}" + 10 ))"

            if (( ++idx == currentItemIdx )); then
                local isCurrentItem=true
            else
                local isCurrentItem=false
            fi


            # when item is being after the visible space
            if (( x - slide + itemSize > x1 + width )); then
                showDots=true
                if $isCurrentItem && (( slideAnimationFrame == 0 )); then
                    $this.slideAnimationTo "${toSlide}"
                    $widgetsLayout.needsRedraw = true
                fi

                (( x+= itemSize ))
                continue
            fi

            # when item is being before visible space
            if (( x - slide < x1 )); then
                if $isCurrentItem && (( slideAnimationFrame == 0 )); then
                    $this.slideAnimationTo "${toSlide}"
                    $widgetsLayout.needsRedraw = true
                fi
            else
                # when item is being at visible space

                if $isCurrentItem; then
                    if $isFocused; then
                        $canvasPrinter.printText $canvas "$(( x - slide - 1 ))" "${y1}" " -${item}- " "${selectedStyle}"
                    else
                        $canvasPrinter.printText $canvas "$(( x - slide - 1 ))" "${y1}" "  ${item}  " "${selectedStyle}"
                    fi
                else
                    $canvasPrinter.printText $canvas "$(( x - slide + 1 - 2 ))" "${y1}" "  ${item}  " "${style}"
            fi

                moreIndicatorPlacement="$(( x - slide + 1 + itemSize ))"
            fi

            (( toSlide += itemSize ))
            (( x+= itemSize ))
        done

        if $showDots; then
            $canvasPrinter.printText $canvas "${moreIndicatorPlacement}" "${y1}" "... "
        fi
    }

@classdone



