# Copyright 2022 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="e22aa5d733f9873ea013c6dd68c7258f747eb3b5"
CROS_WORKON_TREE=("bb46f20bc6d2f9e7fb1aa1178d1e47384440de9a" "b711f0ead1c16aedd63dc8e2788674541ad57431" "51259f50ee011d75518baa1232863345ebb6d631" "beb7d9804a319357e0d4fb473aea5df3ddb78978" "78e2afb8dbfa561ddaa5ef95759112bcff96873f" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
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
