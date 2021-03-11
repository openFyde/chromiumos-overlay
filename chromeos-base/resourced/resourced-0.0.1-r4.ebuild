# Copyright 2021 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="53933c4e9defba1fe45526c98bc911573aa2f1dd"
CROS_WORKON_TREE="a40386441ef71dd4232de72573a252e81f9257e5"
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
# We don't use CROS_WORKON_OUTOFTREE_BUILD here since project's Cargo.toml is
# using "provided by ebuild" macro which supported by cros-rust.
CROS_WORKON_SUBTREE="resourced"

inherit cros-workon cros-rust user

DESCRIPTION="ChromeOS Resource Management Daemon"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/resourced/"

LICENSE="BSD-Google"
SLOT="0/${PVR}"
KEYWORDS="*"

DEPEND="
	=dev-rust/anyhow-1*:=
	=dev-rust/dbus-0.8*:=
	=dev-rust/lazy_static-1*:=
"

src_install() {
	dobin "$(cros-rust_get_build_dir)/resourced"
}

pkg_preinst() {
	enewuser "resourced"
	enewgroup "resourced"
}
