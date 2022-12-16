# Copyright 2022 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

CROS_WORKON_COMMIT=("1225c917c304ca51301e67b755f98be615707cd2" "8dfe43c29022cf990ad21ed6bc742a08b1ba0efc")
CROS_WORKON_TREE=("21ea0ac4ca9c244b766e85ede9a81c55c5519df5" "8da61ef3427fbaa8fc3d5e50cc8095324521614a")
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
