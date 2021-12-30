# Copyright 2021 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="1b85f1f00a6b60023b250c8ec83a11de9e72eaa8"
CROS_WORKON_TREE="c0c32f86c982a5e9ba24083659211862342462cc"
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
	chromeos-base/libsirenia:=
	=dev-rust/anyhow-1*:=
	=dev-rust/getopts-0.2*:=
	dev-rust/libchromeos:=
	>=dev-rust/openssl-0.10.25 <dev-rust/openssl-0.11.0_alpha:=
	>=dev-rust/protobuf-2.16.2 <dev-rust/protobuf-3.0.0_alpha:=
	>=dev-rust/protoc-rust-2.16.2 <dev-rust/protoc-rust-3.0.0_alpha:=
	>=dev-rust/serde-1.0.114 <dev-rust/serde-2.0.0_alpha:=
	>=dev-rust/serde_derive-1.0.114 <dev-rust/serde_derive-2.0.0_alpha:=
	dev-rust/sys_util:=
	>=dev-rust/thiserror-1.0.20 <dev-rust/thiserror-2.0_alpha:=
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
