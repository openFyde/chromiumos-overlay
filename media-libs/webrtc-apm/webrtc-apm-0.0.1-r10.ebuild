# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

EAPI=5

CROS_WORKON_COMMIT="b7da1a8bdb731999d5d7d59cf30fe3cd1b3c656c"
CROS_WORKON_TREE="5142688c28e6ee456fa835f6002b401c981c6e7f"
CROS_WORKON_PROJECT="chromiumos/third_party/webrtc-apm"
CROS_WORKON_LOCALNAME="webrtc-apm"

inherit cros-workon multilib

DESCRIPTION="Standalone WebRTC APM library"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/third_party/webrtc-apm"
SRC_URI=""

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
IUSE="cpu_flags_x86_sse2 neon"

DEPEND="dev-libs/libevent:=
	dev-libs/protobuf:="
RDEPEND="${DEPEND}"

src_configure() {
	export USE_NEON=$(usex neon 1 0)
	export USE_SSE2=$(usex cpu_flags_x86_sse2 1 0)
}

src_install() {
	local INCLUDE_DIR="/usr/include/webrtc-apm"
	local LIB_DIR="/usr/$(get_libdir)"

	dolib libwebrtc_apm.so

	insinto "${INCLUDE_DIR}"
	doins webrtc_apm.h

	sed -e "s|@INCLUDE_DIR@|${INCLUDE_DIR}|" -e "s|@LIB_DIR@|${LIB_DIR}|" \
		libwebrtc_apm.pc.template > libwebrtc_apm.pc
	insinto "${LIB_DIR}/pkgconfig"
	doins libwebrtc_apm.pc
}
