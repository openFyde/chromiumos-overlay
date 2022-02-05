# Copyright 2022 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="3076d813c2333c867034e448ec86013750905950"
CROS_WORKON_TREE="e6e638284933bbc1a4d011036e9cfaa09b4813eb"
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_SUBTREE="hiberman"

inherit cros-workon cros-rust user

DESCRIPTION="The hibernate service manager."
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/hiberman/"

LICENSE="BSD-Google"
KEYWORDS="*"
IUSE=""

DEPEND="
	dev-libs/openssl:=
	=dev-rust/anyhow-1*:=
	dev-rust/chromeos-dbus-bindings:=
	=dev-rust/dbus-0.9*:=
	=dev-rust/dbus-crossroads-0.5*:=
	=dev-rust/getopts-0.2*
	>=dev-rust/libc-0.2.94 <dev-rust/libc-0.3.0_alpha:=
	=dev-rust/log-0.4*:=
	=dev-rust/once_cell-1*:=
	dev-rust/syslog:=
	=dev-rust/openssl-0.10*:=
	=dev-rust/protobuf-2*:=
	=dev-rust/serde-1*:=
	dev-rust/serde_derive:=
	=dev-rust/serde_json-1*:=
	dev-rust/sync:=
	dev-rust/sys_util:=
	dev-rust/system_api:=
	>=dev-rust/thiserror-1.0.20 <dev-rust/thiserror-2.0.0_alpha:=
	>=dev-rust/zeroize-1.5.1 <dev-rust/zeroize-2.0.0_alpha:=
"
RDEPEND="${DEPEND}
	sys-apps/dbus
"

src_install() {
	local build_dir="$(cros-rust_get_build_dir)"
	dosbin "${build_dir}/hiberman"

	insinto /etc/dbus-1/system.d
	doins dbus/org.chromium.Hibernate.conf
}

pkg_setup() {
	enewuser hiberman
	enewgroup hiberman
	cros-rust_pkg_setup
}
