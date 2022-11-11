# Copyright 2022 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="bbfc01ba074fbc54aef8e4f3fd9831e7503f5b78"
CROS_WORKON_TREE="f4656655dde4f4fcbce72ae968d2b58ce909bb0c"
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
	dev-rust/chromeos-dbus-bindings:=
	=dev-rust/dbus-0.9*
	=dev-rust/dbus-crossroads-0.5*
	dev-rust/libchromeos:=
	=dev-rust/openssl-0.10*
	=dev-rust/protobuf-2*
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
