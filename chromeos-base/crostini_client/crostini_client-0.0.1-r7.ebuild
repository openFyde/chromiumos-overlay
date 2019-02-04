# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=6
CROS_WORKON_COMMIT="bb4024b34bbc74774b3e1ca660c9dd73a47d6f28"
CROS_WORKON_TREE="03ee09b329342487aeb1c295d2d4a88cab7eb9ad"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_SUBTREE="vm_tools/crostini_client"
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_OUTOFTREE_BUILD=1

CRATES="
bitflags-1.0.4
cfg-if-0.1.6
dbus-0.6.3
fuchsia-zircon-0.3.3
fuchsia-zircon-sys-0.3.3
getopts-0.2.18
libc-0.2.44
libdbus-sys-0.1.4
log-0.4.6
pkg-config-0.3.14
protobuf-2.1.4
protobuf-codegen-2.1.4
protoc-2.1.4
protoc-rust-2.1.4
rand-0.4.3
remove_dir_all-0.5.1
tempdir-0.3.7
unicode-width-0.1.5
winapi-0.3.6
winapi-i686-pc-windows-gnu-0.4.0
winapi-x86_64-pc-windows-gnu-0.4.0
"

inherit cargo cros-workon

DESCRIPTION="Command-line client for controlling crostini"

SRC_URI="$(cargo_crate_uris ${CRATES})"

LICENSE="BSD-Google BSD-2 Apache-2.0 MIT"
SLOT="0"
KEYWORDS="*"

DEPEND="chromeos-base/system_api"

src_unpack() {
	cargo_src_unpack
	cros-workon_src_unpack
	# The compilation happens in the crostini_client subdirectory.
	S+="/vm_tools/crostini_client"
}

src_compile() {
	export PKG_CONFIG_ALLOW_CROSS=1
	cargo_src_compile
}

src_test() {
	export CARGO_HOME="${ECARGO_HOME}"
	export CARGO_TARGET_DIR="${WORKDIR}"
	if ! use x86 && ! use amd64 ; then
		elog "Skipping unit tests on non-x86 platform"
	else
		RUST_BACKTRACE=1 cargo test || die "crostini_client test failed"
	fi
}

src_install() {
	cargo_src_install

	dosym "crostini_client" "/usr/bin/vmc"
}