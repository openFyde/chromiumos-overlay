# Copyright 2022 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

CROS_WORKON_COMMIT=("68bb55b06ca1301083ddd012e1d8aae790ac746a" "c210e680acff28b644b6e02a4a117fd2dd42ec75")
CROS_WORKON_TREE=("ef2d860945c2bedad6c3ee79f425eb958638a952" "b578200e2e1c108ae09ef610dcd4c15265f5f4b1")
CROS_WORKON_PROJECT=(
	"aosp/platform/external/uwb"
	"aosp/platform/external/uwb"
)
CROS_WORKON_LOCALNAME=(
	"../aosp/external/uwb/public/local"
	"../aosp/external/uwb/public/upstream"
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
