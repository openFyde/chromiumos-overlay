# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="6c82e585ce10a08da11151238246dede5837585f"
CROS_WORKON_TREE="a483c52109fd1e46979aa5ba352f91743b56604e"
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

DEPEND="=dev-rust/which-4*:="
RDEPEND="!chromeos-base/chromeos-dbus-bindings-rust
	${DEPEND}"

BDEPEND=">=dev-rust/dbus-codegen-0.10.0"
