# Copyright 2022 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

CROS_WORKON_COMMIT=("55fc31229bffc16349057b7f52b593d5f2bdeeb8" "6a2bfa7f9cd6a1cc44c894056b65d98483160554")
CROS_WORKON_TREE=("eb9605c7eb81d71681727b83f85d886d482a8e3c" "9b9eaff7043d9916631af10ec81c899f32fedbd5")
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
