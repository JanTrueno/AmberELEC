#!/bin/bash

# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2020-present Shanti Gilbert (https://github.com/shantigilbert)

# Source predefined functions and variables
. /etc/profile

# The rk817 codec comes up with 'Playback Path' OFF and stays silent until an
# output is selected. Jack state is only exposed through the rk-headset extcon
# device in sysfs (it sends no input switch events), so it is polled.
EXTCON=$(dirname $(grep -lx rk-headset /sys/class/extcon/*/name))

jack_state() {
  grep -q -E '(HEADPHONE|MICROPHONE)=1' ${EXTCON}/state && echo headphone || echo speakers
}

apply() {
  set_ee_setting "audio.device" "${1}"
  /usr/bin/odroidgoa_utils.sh setaudio "${1}"
}

CURRENT=$(jack_state)
apply ${CURRENT}

while sleep 1; do
  NEW=$(jack_state)
  if [ "${NEW}" != "${CURRENT}" ]; then
    CURRENT=${NEW}
    apply ${CURRENT}
  fi
done
