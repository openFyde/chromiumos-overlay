# Copyright 2019 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="bb17160d646259f7d9d4d30a14e6003499815fc0"
CROS_WORKON_TREE="c13ae6b3ce89a1f0e2a7cd126d3790d38ac4f91f"
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
