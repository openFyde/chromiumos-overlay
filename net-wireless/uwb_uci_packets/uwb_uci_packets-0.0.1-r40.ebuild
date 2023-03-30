# Copyright 2022 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

CROS_WORKON_COMMIT=("bd2629fbb7bf834b17107a4948cfd2e44db419da" "5c628a87362417648f91434b6df3b1a5a2a94d75")
CROS_WORKON_TREE=("cb3c7f9cf20a010b6e2fbc7823db0cded60ae2b7" "c84ca27a3816d02c2cca955da73cfbce2ef4c1d5")
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
