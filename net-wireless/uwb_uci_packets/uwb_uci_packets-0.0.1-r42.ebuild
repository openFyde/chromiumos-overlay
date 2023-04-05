# Copyright 2022 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

CROS_WORKON_COMMIT=("0ffec963f8a354ead857db72221cd56ab16742ba" "30434955ff7fc67df078de4ba01cf2aeccafbd4c")
CROS_WORKON_TREE=("c84ca27a3816d02c2cca955da73cfbce2ef4c1d5" "fdc124527756f07cd71460657ccecfa5aedd9b0e")
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
CROS_WORKON_SUBTREE=("src/rust/uwb_uci_packets" "src/rust/uwb_uci_packets")
CROS_WORKON_EGIT_BRANCH=("main" "upstream/master")
CROS_WORKON_OPTIONAL_CHECKOUT=(
	"use !uwb_upstream"
	"use uwb_upstream"
)
CROS_RUST_SUBDIR="src/rust/uwb_uci_packets"

inherit cros-workon cros-rust

DESCRIPTION="The UWB UCI packets library"
HOMEPAGE="https://chromium.googlesource.com/aosp/platform/external/uwb/"

LICENSE="BSD-Google"
SLOT="0/0"
KEYWORDS="*"
IUSE="uwb_upstream"

BDEPEND="
	net-wireless/floss_tools
"
DEPEND="
	dev-rust/third-party-crates-src:=
"
RDEPEND="${DEPEND}"
