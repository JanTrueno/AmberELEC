# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2016-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="edid-decode"
PKG_VERSION="15df4aebf06da579241c58949493b866139d0e2b"
PKG_LICENSE="None"
PKG_SITE="https://git.linuxtv.org/edid-decode.git/"
# cgit snapshots are disabled on git.linuxtv.org: every /snapshot/ request returns
# HTTP 400 with the repo index page, current HEAD included. Clone and check out
# the pinned commit instead. Git packages carry no PKG_SHA256; the commit SHA in
# PKG_VERSION is the integrity check.
PKG_URL="https://git.linuxtv.org/edid-decode.git"
PKG_DEPENDS_TARGET="toolchain"
PKG_LONGDESC="Decode EDID data in human-readable format"

make_target() {
  ${CC} ${CFLAGS} -Wall ${LDFLAGS} -o edid-decode edid-decode.c -lm
}

makeinstall_target() {
  mkdir -p ${INSTALL}/usr/bin
    cp edid-decode ${INSTALL}/usr/bin
}
