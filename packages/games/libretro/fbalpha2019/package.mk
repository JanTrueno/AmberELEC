# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2012 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2022-present AmberELEC (https://github.com/AmberELEC)

PKG_NAME="fbalpha2019"
PKG_VERSION="0581797db6fdffd826086b053ced4b6b29bb6678"
# Upstream renamed libretro/fbalpha to libretro/beetle-finalarcade2019. GitHub
# still redirects the old URL, but its generated tarballs embed the repo name as
# the archive's top-level directory, so the bytes - and thus the sha256 - changed
# even though PKG_VERSION still pins the same commit. Verified: the tarball's
# 2035 files are byte-identical to commit 0581797d in the renamed repo.
PKG_SHA256="8309b4af12c532e4454f07e46632a6c9bcd42ec54417e724948bfe2a5e83cf00"
PKG_LICENSE="Non-commercial"
PKG_SITE="https://github.com/libretro/beetle-finalarcade2019"
PKG_URL="${PKG_SITE}/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_LONGDESC="Currently, FB Alpha supports games on Capcom CPS-1 and CPS-2 hardware, SNK Neo-Geo hardware, Toaplan hardware, Cave hardware, and various games on miscellaneous hardware."
PKG_TOOLCHAIN="make"

make_target() {
  sed -i 's/"FB Alpha"/"FB Alpha 2019"/g' src/burner/libretro/libretro.cpp
  make -f makefile.libretro
}

makeinstall_target() {
  mkdir -p ${INSTALL}/usr/lib/libretro
  cp ${PKG_DIR}/fbalpha2019_libretro.info ${INSTALL}/usr/lib/libretro/
  cp fbalpha_libretro.so ${INSTALL}/usr/lib/libretro/fbalpha2019_libretro.so
}
