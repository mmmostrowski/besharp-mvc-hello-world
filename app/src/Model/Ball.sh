#!/usr/bin/env bash

@class Ball

    @var x=0
    @var y=0
    @var dx=0
    @var dy=0

    function Ball.place()
    {
        local w="${1}"
        local h="${2}"

        if (( w == 0 )) || (( h == 0 )); then
            return
        fi

        $this.x = $(( RANDOM % w ))
        $this.y = $(( RANDOM % h ))

        if (( RANDOM % 2 )); then
            $this.dx = 1
        else
            $this.dx = -1
        fi

        if (( RANDOM % 2 )); then
            $this.dy = 1
        else
            $this.dy = -1
        fi
    }

    function Ball.move()
    {
        local w="${1}"
        local h="${2}"

        eval "
          local x=\"\${${this}_x}\"
          local y=\"\${${this}_y}\"
          local dx=\"\${${this}_dx}\"
          local dy=\"\${${this}_dy}\"
        "

        (( x += dx )) || true
        (( y += dy )) || true

        if (( x < 0 )); then
            x=0
            dx="-${dx}"
        elif (( x >= w )); then
            x=$(( w - 1 ))
            dx="-${dx}"
        fi

        if (( y < 0 )); then
            y=0
            dy="-${dy}"
        elif (( y >= h )); then
            y=$(( h - 1 ))
            dy="-${dy}"
        fi

        eval "
            ${this}_x=\"\${x}\"
            ${this}_y=\"\${y}\"
            ${this}_dx=\"\${dx}\"
            ${this}_dy=\"\${dy}\"
        "
    }

@classdone