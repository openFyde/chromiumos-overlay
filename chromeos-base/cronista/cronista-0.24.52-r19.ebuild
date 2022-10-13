# Copyright 2021 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="9b1cd748fd03639646116633c22eb49304d6c281"
CROS_WORKON_TREE="350f4eb91cb8defa74f86974decd78a1e693cfb0"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_SUBTREE="cronista"

inherit user cros-workon cros-rust

DESCRIPTION="Authenticated storage daemon."
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/cronista/"

LICENSE="BSD-Google"
KEYWORDS="*"
IUSE="manatee"

RDEPEND="sys-apps/dbus"

DEPEND="
	dev-rust/third-party-crates-src:=
	chromeos-base/crosvm-base:=
	chromeos-base/libsirenia:=
	=dev-rust/anyhow-1*
	=dev-rust/getopts-0.2*
	dev-rust/libchromeos:=
	=dev-rust/openssl-0.10*
	=dev-rust/protobuf-2*
	=dev-rust/protoc-rust-2*
"

pkg_setup() {
	enewuser cronista
	enewgroup cronista
	cros-rust_pkg_setup
}

src_install() {
	local build_dir="$(cros-rust_get_build_dir)"
	dobin "${build_dir}/cronista"

	local daemon_store="/etc/daemon-store/cronista"
	dodir "${daemon_store}"
	fperms 0700 "${daemon_store}"
	fowners cronista:cronista "${daemon_store}"

	if use manatee ;  then
		insinto /etc/init
		doins upstart/cronista.conf
	fi
}
