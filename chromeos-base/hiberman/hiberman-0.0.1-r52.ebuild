# Copyright 2022 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="3eb1484248d0ae4079e66d4c2e70a1ed05ee6d98"
CROS_WORKON_TREE="0148b3dcb07845d821427599284922ace39fc050"
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
	dev-rust/third-party-crates-src:=
	dev-libs/openssl:=
	=dev-rust/anyhow-1*
	dev-rust/chromeos-dbus-bindings:=
	=dev-rust/dbus-0.9*
	=dev-rust/dbus-crossroads-0.5*
	dev-rust/libchromeos:=
	=dev-rust/stderrlog-0.5*
	=dev-rust/syslog-6*
	=dev-rust/openssl-0.10*
	=dev-rust/protobuf-2*
	=dev-rust/serde_json-1*
	dev-rust/sync:=
	dev-rust/system_api:=
"
RDEPEND="${DEPEND}
	sys-apps/dbus
"

src_install() {
	local build_dir="$(cros-rust_get_build_dir)"
	dosbin "${build_dir}/hiberman"

	insinto /etc/dbus-1/system.d
	doins dbus/org.chromium.Hibernate.conf

	insinto /usr/share/dbus-1/system-services
	doins dbus/org.chromium.Hibernate.service

	insinto /etc/init
	doins "${FILESDIR}/hiberman.conf"
}

pkg_setup() {
	enewuser hiberman
	enewgroup hiberman
	cros-rust_pkg_setup
}

pkg_preinst() {
	local mnt_dir="${ROOT}/mnt/hibernate"
	[[ -d "{mnt_dir}" ]] || \
		install -d --mode=0700 --owner=hiberman --group=hiberman "${mnt_dir}"
}
