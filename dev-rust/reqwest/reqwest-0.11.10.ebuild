# Copyright 2018 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

CROS_RUST_EMPTY_CRATE=1
CROS_RUST_EMPTY_CRATE_FEATURES=( blocking json default-tls rustls-tls )

inherit cros-rust

DESCRIPTION="Empty ${PN} crate"
HOMEPAGE=""

LICENSE="metapackage"
SLOT="${PV}/${PR}"
KEYWORDS="*"
