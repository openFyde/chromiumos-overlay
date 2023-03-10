# Copyright 2022 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="00d79698c065a684f6ec65813263692e1972d74a"
CROS_WORKON_TREE="39de8fa4b8096d56b74fc36ef6ff93443ed58de4"
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
	dev-rust/libchromeos:=
	dev-rust/sync:=
	dev-rust/system_api:=
	dev-rust/update_engine_dbus:=
	dev-libs/openssl:0=
	sys-apps/dbus:=
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
