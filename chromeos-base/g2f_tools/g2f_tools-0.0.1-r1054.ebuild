# Copyright 2018 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="a1fccdb4b17108cfdb0b01c1e95882a328e19b1b"
CROS_WORKON_TREE=("f834e7e40228b458c4100226f262117a9d85cdb3" "fb37c3a82e422403a52e4e8e59e56447a539b378" "c1195005f152ed453ed87250e60e2dfa9502a6c4" "6df1cbd56008025f75967252b37c51cf894558cb" "b8eb60e70e22ddc2598464eb4aa327b1bde66ca6" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_INCREMENTAL_BUILD=1
# TODO(crbug.com/809389): Avoid directly including headers from other packages.
CROS_WORKON_SUBTREE="common-mk libhwsec libhwsec-foundation metrics u2fd .gn"

PLATFORM_SUBDIR="u2fd/g2f_tools"

inherit cros-workon platform

DESCRIPTION="G2F gnubby (U2F+GCSE) development and testing tools"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/u2fd"

LICENSE="BSD-Google"
SLOT="0/0"
KEYWORDS="*"

COMMON_DEPEND="
	chromeos-base/u2fd:=
	dev-libs/hidapi:=
"

RDEPEND="${COMMON_DEPEND}"

DEPEND="
	${COMMON_DEPEND}
	chromeos-base/chromeos-ec-headers:=
	chromeos-base/protofiles:=
	chromeos-base/system_api:=
"

platform_pkg_test() {
	platform test_all
}
