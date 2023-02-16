# Copyright 2022 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

CROS_WORKON_COMMIT=("91aef4fc08dd99b0dd16bcdb56a4a140babdfa8e" "73d63c7eb0135853a1f4f2609ebf91fe5635fd64")
CROS_WORKON_TREE=("9b9eaff7043d9916631af10ec81c899f32fedbd5" "57836a599f0982ea65eea489e7bd721c5adf4228")
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
