# Copyright 2021 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="5e384e695c5d3cd9031f94273fc44105b7c9c8d1"
CROS_WORKON_TREE="f658d8cf541707561bee16b4e0b89869688f540e"
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
# We don't use CROS_WORKON_OUTOFTREE_BUILD here since project's Cargo.toml is
# using "provided by ebuild" macro which supported by cros-rust.
CROS_WORKON_SUBTREE="resourced"

inherit cros-workon cros-rust udev user

DESCRIPTION="ChromeOS Resource Management Daemon"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/resourced/"

LICENSE="BSD-Google"
SLOT="0/${PVR}"
KEYWORDS="*"
IUSE="+seccomp"

DEPEND="
	dev-rust/third-party-crates-src:=
	=dev-rust/anyhow-1*
	=dev-rust/dbus-0.9*
	=dev-rust/dbus-tree-0.9*
	dev-rust/featured:=
	=dev-rust/glob-0.3*
	dev-rust/libchromeos:=
	=dev-rust/once_cell-1.7*
	=dev-rust/futures-0.3*
	=dev-rust/grpcio-0.9*
	dev-rust/sys_util:=
"

src_install() {
	dobin "$(cros-rust_get_build_dir)/resourced"

	# D-Bus configuration.
	insinto /etc/dbus-1/system.d
	doins dbus/org.chromium.ResourceManager.conf

	# init script.
	insinto /etc/init
	doins init/resourced.conf

	# Install udev rules.
	udev_dorules udev/99-resourced.rules

	if [[ -d tmpfiles.d ]]; then
		insinto /usr/lib/tmpfiles.d
		doins -r tmpfiles.d/*
	fi

	# seccomp policy file.
	insinto /usr/share/policy
	if use seccomp; then
		newins "seccomp/resourced-seccomp-${ARCH}.policy" resourced-seccomp.policy
	fi
}

pkg_preinst() {
	enewuser "resourced"
	enewgroup "resourced"

	cros-rust_pkg_preinst
}
