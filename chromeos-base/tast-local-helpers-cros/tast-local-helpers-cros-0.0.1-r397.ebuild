# Copyright 2019 The ChromiumOS Authors
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

EAPI=7

CROS_WORKON_COMMIT=("1c77f6728f1b4aabd016a79bdccabeba93680f9b" "b99c97c8f01ab1f0a13eaa790e4f0e99cbf4f0e8")
CROS_WORKON_TREE=("3f8a9a04e17758df936e248583cfb92fc484e24c" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6" "94f2375658437d6b04f447c734c50968775622b0")
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
