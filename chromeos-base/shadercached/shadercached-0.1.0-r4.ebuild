# Copyright 2022 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="4c163671fd54f47f9e2484561ad38f6d94d8feaa"
CROS_WORKON_TREE="30320ee0277e6ce4511a9afd386df4b515ffa761"
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
	=dev-rust/anyhow-1*:=
	=dev-rust/dbus-0.9*:=
	=dev-rust/dbus-crossroads-0.5*:=
	=dev-rust/dbus-tokio-0.7*:=
	=dev-rust/tokio-1.19*:=
	dev-rust/system_api:=
	dev-rust/libchromeos:=
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
