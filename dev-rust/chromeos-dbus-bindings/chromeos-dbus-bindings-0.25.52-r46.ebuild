# Copyright 2019 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="ba1bd150f0dcd3e89e44e7b9a464f5fa2ebb14b7"
CROS_WORKON_TREE="4d10030910e9d68f7c19c327419309ab8f213eed"
CROS_RUST_SUBDIR="chromeos-dbus-bindings"

CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_LOCALNAME="../platform2"
CROS_WORKON_SUBTREE="${CROS_RUST_SUBDIR}"

inherit cros-workon cros-rust

DESCRIPTION="Chrome OS D-Bus bindings generator for Rust."
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/chromeos-dbus-bindings/"

LICENSE="BSD-Google"
SLOT="0/${PVR}"
KEYWORDS="*"

DEPEND="dev-rust/third-party-crates-src:="
RDEPEND="!chromeos-base/chromeos-dbus-bindings-rust
	${DEPEND}"

BDEPEND=">=dev-rust/dbus-codegen-0.10.0"
