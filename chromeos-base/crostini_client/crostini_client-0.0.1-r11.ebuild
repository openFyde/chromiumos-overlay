# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=6
CROS_WORKON_COMMIT="a38a15438ecb2c187bad765afa58c05853fc800e"
CROS_WORKON_TREE="c76aeefb40dc3d3aa2a0db72fb311843da597be7"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_SUBTREE="vm_tools/crostini_client"
CROS_WORKON_INCREMENTAL_BUILD=1

inherit cros-workon cros-rust

DESCRIPTION="Command-line client for controlling crostini"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"

DEPEND="chromeos-base/system_api
	=dev-rust/dbus-0.6*:=
	=dev-rust/getopts-0.2*:=
	>=dev-rust/libc-0.2.44:=
	!>=dev-rust/libc-0.3
	>=dev-rust/protobuf-2.3:=
	!>=dev-rust/protobuf-3
	>=dev-rust/protoc-rust-2.3:=
	!>=dev-rust/protoc-rust-3
"

src_unpack() {
	cros-workon_src_unpack
	# The compilation happens in the crostini_client subdirectory.
	S+="/vm_tools/crostini_client"
	cros-rust_src_unpack
}

src_compile() {
	ecargo_build
	use test && ecargo_test --no-run
}

src_test() {
	if ! use x86 && ! use amd64 ; then
		elog "Skipping unit tests on non-x86 platform"
	else
		ecargo_test --all
	fi
}

src_install() {
	local build_dir="$(cros-rust_get_build_dir)"
	dobin "${build_dir}/crostini_client"
	dosym "crostini_client" "/usr/bin/vmc"
}