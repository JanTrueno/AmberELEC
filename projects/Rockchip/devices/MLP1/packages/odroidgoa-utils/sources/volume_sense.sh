#!/bin/bash

# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2021-present Fewtarius
#               2021-present pkegg

### Summary
#   Listens to the MLP1's volume rocker and adjusts volume.
###

# type 1 (EV_KEY), code 114 (KEY_VOLUMEDOWN), value 1
# type 1 (EV_KEY), code 115 (KEY_VOLUMEUP), value 1
VOLUME_DEVICE='/dev/input/by-path/platform-gpio-keys-vol-event'

VOL_EVENT='*(KEY_VOLUME*, value *'
VOL_UP='*UP), value *'
RELEASE='*value 0'
REPEAT_PRESS='*value 2'

# One step is ~3dB on this DAC (0.37dB per raw step), the smallest change that
# is clearly audible. Holding the key acts on every 4th auto-repeat event.
VOLUME_STEP=3
VOLUME_REPEAT_MOD=4

until [ -e "${VOLUME_DEVICE}" ]; do
  sleep 1
done

evtest "${VOLUME_DEVICE}" | while read line; do
  case $line in
    (${VOL_EVENT})
      if [[ "$line" == ${RELEASE} ]]; then
        REPEAT_NUM=0
        continue
      fi
      REPEAT_NUM=$(( REPEAT_NUM + 1 ))
      if [[ "$line" == ${REPEAT_PRESS} && $(( REPEAT_NUM % VOLUME_REPEAT_MOD )) != "0" ]]; then
        continue
      fi
      if [[ "$line" == ${VOL_UP} ]]; then
        /usr/bin/odroidgoa_utils.sh vol + ${VOLUME_STEP} > /dev/null
      else
        /usr/bin/odroidgoa_utils.sh vol - ${VOLUME_STEP} > /dev/null
      fi
      ;;
  esac
done
