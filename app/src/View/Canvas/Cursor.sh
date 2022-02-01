#!/usr/bin/env bash

@class Cursor

  function Cursor.moveTo()
  {
      local x="${1}"
      local y="${2}"

      echo -en "\033[$(( y + 1 ));$((x + 1 ))H"
  }

  function Cursor.clearAndMoveTo0x0()
  {
      echo -e "\033[2J"
      $this.moveTo 0 0
      tput rmam
  }

  function Cursor.hide()
  {
      echo -e "\e[?25l"
      stty -echo > /dev/null 2> /dev/null || true
  }

  function Cursor.show()
  {
      stty echo > /dev/null 2> /dev/null || true
      echo -e "\e[?25h"
      tput smam
  }

@classdone