# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

CROS_RUST_REMOVE_DEV_DEPS=1

inherit cros-rust

DESCRIPTION="An abstraction over platform-specific TLS implementations."
HOMEPAGE="https://github.com/sfackler/rust-native-tls"
SRC_URI="https://crates.io/api/v1/crates/${PN}/${PV}/download -> ${P}.crate"

LICENSE="|| ( MIT Apache-2.0 )"
SLOT="${PV}/${PR}"
KEYWORDS="*"

DEPEND="
	>=dev-rust/lazy_static-1.0:=
	>=dev-rust/libc-0.2:=
	>=dev-rust/log-0.4.5:=
	>=dev-rust/openssl-0.10.15:=
	>=dev-rust/openssl-probe-0.1:=
	>=dev-rust/openssl-sys-0.9.30:=
	>=dev-rust/schannel-0.1.13:=
	>=dev-rust/security-framework-0.3.1:=
	>=dev-rust/security-framework-sys-0.3.1:=
	>=dev-rust/tempfile-3.0:=
"
