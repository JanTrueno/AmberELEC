#!/bin/sh
# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2024-present AmberELEC (https://github.com/AmberELEC)

. /etc/profile

DEVICE=$(tr -d '\0' < /sys/firmware/devicetree/base/model)

if [ "$DEVICE" == "Anbernic RG351P" ]; then
  magick /usr/config/splash/splash-480.png bgra:/dev/fb0
elif [ "$DEVICE" == "Anbernic RG552" ]; then
  ply-image /usr/config/splash/splash-1920.png
elif [ "${DEVICE#MINILOONG}" != "$DEVICE" ]; then
  # DEVICE here is the devicetree model string, not the AmberELEC DEVICE build
  # variable - the board is still named MINILOONG in the kernel fork.
  # 'magick ... bgra:/dev/fb0' blits raw pixels with no scaling, so the image
  # must match the framebuffer exactly or every row is offset and the screen
  # shows diagonal stripes. This panel scans portrait at 720x960 while the
  # device is held landscape, so the asset is pre-rotated to match fbcon=rotate:3.
  magick /usr/config/splash/splash-720x960.png bgra:/dev/fb0
else
  magick /usr/config/splash/splash-640.png bgra:/dev/fb0
fi
