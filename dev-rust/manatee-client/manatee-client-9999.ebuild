# Copyright 2020 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_RUST_SUBDIR="sirenia/manatee-client"

CROS_WORKON_LOCALNAME="../platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_SUBTREE="${CROS_RUST_SUBDIR} sirenia/dbus_bindings"

inherit cros-workon cros-rust

DESCRIPTION="Rust D-Bus bindings for ManaTEE."
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/sirenia/manatee-client"

LICENSE="BSD-Google"
SLOT="0/${PVR}"
KEYWORDS="~*"

RDEPEND=""

DEPEND="${RDEPEND}
	>chromeos-base/chromeos-dbus-bindings-rust-0.24.52-r16:=
	=dev-rust/dbus-0.8*:=
"
