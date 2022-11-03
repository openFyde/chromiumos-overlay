# Copyright 2021 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="666db4fd2dedc2bf2e70cb0f9bb93e26715489d6"
CROS_WORKON_TREE="f4ab08db744c1b22c0a72c8a8b672348f3df02d4"
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_SUBTREE="os_install_service"

inherit cros-workon cros-rust tmpfiles

LICENSE="BSD-Google"
SLOT="0/${PVR}"
KEYWORDS="*"
IUSE="test"

DEPEND="
	dev-rust/third-party-crates-src:=
	chromeos-base/system_api:=
	=dev-rust/anyhow-1.0*
	=dev-rust/chrono-0.4*
	=dev-rust/dbus-0.8*
	dev-rust/libchromeos:=
	=dev-rust/serde_json-1.0*
	dev-rust/sys_util:=
"

RDEPEND="
	chromeos-base/chromeos-installer
	sys-apps/util-linux
	sys-block/parted
"

src_install() {
	insinto /etc/dbus-1/system.d
	doins conf/org.chromium.OsInstallService.conf

	insinto /usr/share/policy
	newins "conf/os_install_service-seccomp-${ARCH}.policy" os_install_service-seccomp.policy

	insinto /etc/init
	doins conf/os_install_service.conf

	newtmpfiles conf/tmpfiles.conf os_install_service.conf

	dosbin "$(cros-rust_get_build_dir)/is_running_from_installer"
	dosbin "$(cros-rust_get_build_dir)/os_install_service"
}
