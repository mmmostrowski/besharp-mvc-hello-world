#!/usr/bin/env bash

@class BallsWidget @implements Widget AnimatedWidget StoppableAnimationWidget

    @var @inject CanvasPrinter canvasPrinter

    @var @inject Canvas canvas

    @var ballsNum = 2
    @var ArrayVector balls

    function BallsWidget()
    {
        $this.ballsNum = "${1:-2}"

        @let $this.balls = @new ArrayVector
    }

    function BallsWidget.initialize()
    {
      :
    }

    function BallsWidget.calculateMinSize()
    {
        local calculator="${1}"

        $calculator.setupSize 1 1
    }

    function BallsWidget.initializeAnimation()
    {
        local context="${1}"
        local layout="${2}"

        @let w = $context.width
        @let h = $context.height

        @let ballsNum = $this.ballsNum
        @let balls = $this.balls
        while (( ballsNum-- )); do
            @let ball = @new Ball
            $ball.place "${w}" "${h}"
            $balls.add $ball
        done
    }

    function BallsWidget.addBall()
    {
        local context="${1}"

        @let w = $context.width
        @let h = $context.height

        @let balls = $this.balls
        @let ball = @new Ball
        $ball.place "${w}" "${h}"
        $balls.add $ball

        @let $this.ballsNum = $balls.size
    }

    function BallsWidget.removeBall()
    {
        @let balls = $this.balls

        if @true $balls.isEmpty; then
            return
        fi

        $balls.removeIndex 0

        @let $this.ballsNum = $balls.size
    }

    function BallsWidget.removeAllBalls()
    {
        @let balls = $this.balls

        if @true $balls.isEmpty; then
            return
        fi

        $balls.removeAll
        $this.ballsNum = 0
    }

    function BallsWidget.processAnimationFrame()
    {
        local context="${1}"
        local layout="${2}"

        @let w = $context.width
        @let h = $context.height
        @let balls = $this.balls
        @let ballsNum = $this.ballsNum

        (( w-= 2)) || true
        (( h-= 2)) || true

        while (( ballsNum-- )); do
            @let ball = $balls.get $ballsNum
            $ball.move "${w}" "${h}"
        done

        @returning 1
    }

    function BallsWidget.draw()
    {
        local context="${1}"

        @let offsetX = $context.x1
        @let offsetY = $context.y1
        @let width = $context.width
        @let height = $context.height

        @let canvasPrinter = $this.canvasPrinter
        @let canvas = $this.canvas
        @let balls = $this.balls
        @let ballsNum = $this.ballsNum

        if (( width == 1 )) || (( height == 1 )); then
            $canvasPrinter.printFrame $canvas ${offsetX} ${offsetY} ${width} ${height}
            return
        fi

        if (( width <= 0 )) || (( height <= 0 )); then
            return
        fi

        local ballChar='*'
        while (( ballsNum-- )); do
            @let ball = $balls.get $ballsNum

            eval "
                local x=\"\$(( ${ball}_x + offsetX + 1 ))\"
                local y=\"\$(( ${ball}_y + offsetY + 1 ))\"
            "

            $canvas.putPixel "${x}" "${y}" "${ballChar}" "\e[32m"
        done

        $canvasPrinter.printFrame $canvas ${offsetX} ${offsetY} ${width} ${height}
    }

@classdone



