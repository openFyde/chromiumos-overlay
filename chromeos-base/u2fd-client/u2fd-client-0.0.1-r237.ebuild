# Copyright 2022 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="3b3011e040493f527b2bb959412dc7f876ffaab1"
CROS_WORKON_TREE=("3f8a9a04e17758df936e248583cfb92fc484e24c" "70184f9a70acdc66ffdd6f250b76ad7dc403868e" "f5c3316fa9c442f0cf46c4027c7293561c360567" "e1f223c8511c80222f764c8768942936a8de01e4" "4009d6eb6c6d27c7d2a35604226089fd0190d345" "136cf6afec83d9ac0e97448e0d8bae32c47e6f3f" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
CROS_WORKON_USE_VCSID="1"
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_INCREMENTAL_BUILD=1
# TODO(crbug.com/809389): Avoid directly including headers from other packages.
CROS_WORKON_SUBTREE="common-mk libhwsec libhwsec-foundation metrics trunks u2fd .gn"

PLATFORM_SUBDIR="u2fd/client"

inherit cros-workon platform

DESCRIPTION="U2FHID library used by the internal corp U2F library"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/u2fd/client/"

LICENSE="BSD-Google"
KEYWORDS="*"
IUSE="fuzzer cr50_onboard ti50_onboard"

COMMON_DEPEND="
	chromeos-base/libhwsec:=
	chromeos-base/session_manager-client:=
"

RDEPEND="${COMMON_DEPEND}"

DEPEND="${COMMON_DEPEND}
	>=chromeos-base/protofiles-0.0.43:=
	chromeos-base/system_api:=
"
