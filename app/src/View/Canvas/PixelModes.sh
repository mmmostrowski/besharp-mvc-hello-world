#!/usr/bin/env bash

@static { @pixel_modes }
@class PixelModes

  function PixelModes()
  {
      @let bgReset = $this.bgBlack

      @let reset = $this.reset
      $this.reset = "${reset}${bgReset}"
  }

  @var reset = "\e[0m"

  @var bold = "\e[1m"
  @var dim = "\e[2m"
  @var underline = "\e[4m"
  @var blink = "\e[5m"
  @var inverted = "\e[6m"
  @var hidden = "\e[8m"

  @var boldReset = "\e[21m"
  @var dimReset="\e[22m"
  @var underlineReset = "\e[24m"
  @var blinkReset = "\e[25m"
  @var invertedReset = "\e[26m"
  @var hiddenReset = "\e[28m"

  @var black = "\e[38;5;232m"
  @var lGray = "\e[37m"
  @var dGray = "\e[90m"
  @var white = "\e[38;5;254m"

  @var red = "\e[38;5;88m"
  @var green = "\e[38;5;28m"
  @var yellow = "\e[38;5;101m"
  @var blue = "\e[38;5;18m"
  @var magenta = "\e[38;5;93m"
  @var cyan = "\e[38;5;26m"

  @var lRed = "\e[38;5;196m"
  @var lGreen = "\e[38;5;119m"
  @var lYellow = "\e[38;5;226m"
  @var lBlue = "\e[38;5;25m"
  @var lMagenta = "\e[38;5;201m"
  @var lCyan = "\e[38;5;111m"


  @var bgBlack = "\e[48;5;232m"
  @var bgLGray = "\e[48;5;248m"
  @var bgDGray = "\e[48;5;238m"
  @var bgWhite = "\e[48;5;254m"

  @var bgRed = "\e[41m"
  @var bgGreen = "\e[42m"
  @var bgYellow = "\e[43m"
  @var bgBlue = "\e[44m"
  @var bgMagenta = "\e[45m"
  @var bgCyan = "\e[46m"

  @var bgLRed = "\e[101m"
  @var bgLGreen = "\e[102m"
  @var bgLYellow = "\e[103m"
  @var bgLBlue = "\e[104m"
  @var bgLMagenta = "\e[105m"
  @var bgLCyan = "\e[106m"

  function PixelModes.randomColor()
  {
      case $(( RANDOM % 14 )) in
          0) @returning @of $this.red
            ;;
          1) @returning @of $this.green
            ;;
          2) @returning @of $this.blue
            ;;
          3) @returning @of $this.yellow
            ;;
          4) @returning @of $this.magenta
            ;;
          5) @returning @of $this.cyan
            ;;
          6) @returning @of $this.lRed
            ;;
          7) @returning @of $this.lGreen
            ;;
          8) @returning @of $this.lBlue
            ;;
          9) @returning @of $this.lYellow
            ;;
          10) @returning @of $this.lMagenta
            ;;
          11) @returning @of $this.lCyan
            ;;
          12) @returning @of $this.lGray
            ;;
          13) @returning @of $this.dGray
            ;;
      esac
  }

@classdone