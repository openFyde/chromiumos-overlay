# Copyright 2022 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

CROS_WORKON_COMMIT=("04fc011635bb61eee33f1e700575ee836e887f22" "7beb89d5f131447131dee44895f1c4e3aa17bfa1")
CROS_WORKON_TREE=("babe2ba3848181e9454e4de09e5789311ff661aa" "b6e126a110609dd2a95f4d837a81055eda703ab7")
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
