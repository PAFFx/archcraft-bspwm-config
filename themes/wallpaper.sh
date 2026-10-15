#!/usr/bin/env bash

## Copyright (C) 2020-2026 Aditya Shakya <adi1090x@gmail.com>
##
## Apply wallpaper on bspwm startup

WALLPAPER='/home/paff/.config/bspwm/themes/adaptive/wallpaper'

## For single monitor
#hsetroot -root -cover "$WALLPAPER"

## For all monitors
hsetroot -cover "$WALLPAPER"
