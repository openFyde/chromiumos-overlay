# Copyright 2021 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="da3a7bc1d0bc06a3bfc02e7f21e3a9f5e10d58bf"
CROS_WORKON_TREE=("0c4b88db0ba1152616515efb0c6660853232e8d0" "66103fa54350371c16815b131ef3625b207e0eb9" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6" "9da4303fca3d31774ff2a0ed56ad7e4beb63abc7")
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_SUBTREE="common-mk hps .gn metrics"

PLATFORM_SUBDIR="hps/util"

inherit cros-workon platform

DESCRIPTION="HPS utilities and tool"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/main/hps"

LICENSE="BSD-Google"
SLOT="0/0"
KEYWORDS="*"

COMMON_DEPEND="
	chromeos-base/metrics:=
	virtual/libusb:1
	"

RDEPEND="${COMMON_DEPEND}"

DEPEND="${COMMON_DEPEND}"

src_install() {
	platform_src_install

	dobin "${OUT}"/hps
}
