# Copyright 2022 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="37e12818999f398725a2f4006c9c1e576bcdc43e"
CROS_WORKON_TREE=("684de7632fb3bf23e07149db10c51780f7a80c39" "484f1e2c34eac4f5bfd4daed8051252ce371f2a7" "db75597a3a702c90030f8f50dee1f1f79046be1a" "beb7d9804a319357e0d4fb473aea5df3ddb78978" "af74f23a84a4807c710ec41a602cf4daa3e64804" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
CROS_WORKON_USE_VCSID="1"
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_INCREMENTAL_BUILD=1
# TODO(crbug.com/809389): Avoid directly including headers from other packages.
CROS_WORKON_SUBTREE="common-mk libhwsec-foundation metrics trunks u2fd .gn"

PLATFORM_SUBDIR="u2fd/client"

inherit cros-workon platform

DESCRIPTION="U2FHID library used by the internal corp U2F library"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/u2fd/client/"

LICENSE="BSD-Google"
KEYWORDS="*"
IUSE="fuzzer cr50_onboard ti50_onboard"

COMMON_DEPEND="
	fuzzer? (
		chromeos-base/trunks:=
	)
	cr50_onboard? (
		chromeos-base/trunks:=
	)
	ti50_onboard? (
		chromeos-base/trunks:=
	)
	chromeos-base/session_manager-client:=
"

RDEPEND="${COMMON_DEPEND}"

DEPEND="${COMMON_DEPEND}
	>=chromeos-base/protofiles-0.0.43:=
	chromeos-base/system_api:=
"
