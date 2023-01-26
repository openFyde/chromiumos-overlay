# Copyright 2022 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

CROS_WORKON_COMMIT=("7723cbad3b599dce7be683d49377fcfa08fac799" "e4b9ce627de07de219a58084a350c5a663c9199c")
CROS_WORKON_TREE=("ebb4882754a6db91b1dc80d950fdec5921586473" "1db2aecb828af7b64e1cf24b3b707d6c7cd0bc07")
CROS_WORKON_PROJECT=(
	"aosp/platform/external/uwb"
	"aosp/platform/external/uwb"
)
CROS_WORKON_LOCALNAME=(
	"../aosp/external/uwb/local"
	"../aosp/external/uwb/upstream"
)
CROS_WORKON_DESTDIR=(
	"${S}"
	"${S}"
)
CROS_WORKON_SUBTREE=("src/rust/uwb_core" "src/rust/uwb_core")
CROS_WORKON_EGIT_BRANCH=("main" "upstream/master")
CROS_WORKON_OPTIONAL_CHECKOUT=(
	"use !uwb_upstream"
	"use uwb_upstream"
)
CROS_RUST_SUBDIR="src/rust/uwb_core"

inherit cros-workon cros-rust

DESCRIPTION="The UWB Core library"
HOMEPAGE="https://chromium.googlesource.com/aosp/platform/external/uwb/"

LICENSE="BSD-Google"
SLOT="0/0"
KEYWORDS="*"
IUSE="uwb_upstream"

DEPEND="
	dev-rust/third-party-crates-src:=
	net-wireless/uwb_uci_packets:=
"
RDEPEND="${DEPEND}"
