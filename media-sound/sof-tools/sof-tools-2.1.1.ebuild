# Copyright 2022 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

EAPI=7

inherit cmake

DESCRIPTION="Tools for Sound Open Firmware"
HOMEPAGE="https://github.com/thesofproject/sof"
SRC_URI="https://github.com/thesofproject/sof/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="*"

S="${WORKDIR}/sof-${PV}/tools"

src_compile() {
	cmake_build sof-logger
}

src_install() {
	dobin "${BUILD_DIR}/logger/sof-logger"
}
