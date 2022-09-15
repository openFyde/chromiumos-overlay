# Copyright 2019 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit cros-rust

DESCRIPTION="A macro which makes error types pleasant to write."
HOMEPAGE="http://github.com/tailhook/quick-error"
SRC_URI="https://crates.io/api/v1/crates/${PN}/${PV}/download -> ${P}.crate"

LICENSE="|| ( MIT Apache-2.0 )"
SLOT="${PV}/${PR}"
KEYWORDS="*"
