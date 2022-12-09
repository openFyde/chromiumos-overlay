# Copyright 2022 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="86ce845e172a01b2aba5450f4b5a36d4add91ac5"
CROS_WORKON_TREE="0c229ee8f1fb1397a9928d98a00eb0cbacad50ee"
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
# We don't use CROS_WORKON_OUTOFTREE_BUILD here since project's Cargo.toml is
# using "provided by ebuild" macro which supported by cros-rust.
CROS_WORKON_SUBTREE="shadercached"

inherit cros-workon cros-rust user

DESCRIPTION="Shader cache management daemon"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/shadercached/"

LICENSE="BSD-Google"
SLOT="0/${PVR}"
KEYWORDS="*"

DEPEND="
	dev-rust/third-party-crates-src:=
	dev-rust/system_api:=
	dev-rust/libchromeos:=
	sys-apps/dbus:=
"
RDEPEND="sys-apps/dbus:="

src_install() {
	dobin "$(cros-rust_get_build_dir)/shadercached"

	# D-Bus configuration.
	insinto /etc/dbus-1/system.d
	doins dbus/org.chromium.ShaderCache.conf

	# Init configuration
	insinto /etc/init
	doins init/shadercached.conf
}

pkg_preinst() {
	enewuser shadercached
	enewgroup shadercached

	cros-rust_pkg_preinst
}
