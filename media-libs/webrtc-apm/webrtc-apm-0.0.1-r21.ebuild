# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

EAPI=5

CROS_WORKON_COMMIT="e2b05126bcc9b79d5ccd897bfae3b240dfb2bccd"
CROS_WORKON_TREE="34023248b6711f2740fe442037bfcbede09f2ba3"
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

DEPEND="dev-libs/iniparser:=
	dev-libs/libevent:=
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
