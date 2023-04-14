# Copyright 2019 The ChromiumOS Authors
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

EAPI=7

CROS_WORKON_COMMIT=("f5905cb27d9b5dbf6bf6e338cf012ba9267a0523" "75ea265acbe1c5ca770e3fe3601881e9d126e2b6")
CROS_WORKON_TREE=("4d05be6aacce39f0ffed0cb00fc7d88926121b65" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6" "fd6a602b87115622d0a0bf17fe13e53711ab0de8")
CROS_WORKON_PROJECT=("chromiumos/platform2" "chromiumos/platform/tast-tests")
CROS_WORKON_LOCALNAME=("platform2" "platform/tast-tests")
CROS_WORKON_DESTDIR=("${S}/platform2" "${S}/platform2/tast-tests")
CROS_WORKON_SUBTREE=("common-mk .gn" "helpers")

PLATFORM_SUBDIR="tast-tests/helpers/local"

inherit cros-workon cros-rust platform

DESCRIPTION="Compiled executables used by local Tast tests in the cros bundle"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform/tast-tests/+/master/helpers"

LICENSE="BSD-Google GPL-3"
SLOT="0/0"
KEYWORDS="*"

COMMON_DEPEND="
	dev-cpp/gtest:=
	media-libs/minigbm:=
	x11-libs/libdrm:=
"
RDEPEND="
	${COMMON_DEPEND}
	chromeos-base/featured
	chromeos-base/goldctl
	media-video/ffmpeg
"
DEPEND="${RDEPEND}
	dev-rust/libchromeos:=
"

src_unpack() {
	platform_src_unpack
	cros-rust_src_unpack
}

src_configure() {
	platform_src_configure
	cros-rust_src_configure
}

src_compile() {
	platform_src_compile
	cros-rust_src_compile
}

src_test() {
	platform_src_test
	cros-rust_src_test
}


src_install() {
	platform_src_install

	# Executable files' names take the form <category>.<TestName>.<bin_name>.
	exeinto /usr/libexec/tast/helpers/local/cros
	doexe "${OUT}"/*.[A-Z]*.*

	local build_dir="$(cros-rust_get_build_dir)"
	newexe "${build_dir}/crash_rust_panic" crash.Rust.panic

	# Install symbol list file to the location required by minidump_stackwalk.
	# See https://www.chromium.org/developers/decoding-crash-dumps for details.
	local crasher_exec="${OUT}/platform.UserCrash.crasher"
	local id=$(head -n1 "${crasher_exec}.sym" | cut -d' ' -f 4)
	insinto "/usr/libexec/tast/helpers/local/cros/symbols/${crasher_exec##*/}/${id}"
	doins "${crasher_exec}.sym"
}
