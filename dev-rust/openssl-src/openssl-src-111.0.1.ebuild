# Copyright 2019 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

CROS_RUST_EMPTY_CRATE=1

inherit cros-rust

DESCRIPTION="Empty ${PN} crate that pulls in the openssl headers."
HOMEPAGE=""

LICENSE="metapackage"
SLOT="${PV}/${PR}"
KEYWORDS="*"

DEPEND="dev-libs/openssl:0="
