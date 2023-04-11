# Copyright 2022 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="9e6b424caa95299b286811d4b6c1f3783edc77bd"
CROS_WORKON_TREE=("e44d7e66ab4ccaab888a42ade972724af9621706" "7f9d4fc453e0dd5069032f56afac73fb8e903602" "c054c10084a92bffb39a6eb8e53d25cf69f675f1" "63011a57f0808f474403dbaa6d5c0c093b53f1ce" "70212877aaf6587f9ee6015b92f0bcd6b8fb7ce9" "8411333e52d81e18bd1b093358123171eac53c34" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
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
	chromeos-base/chromeos-ec-headers:=
	>=chromeos-base/protofiles-0.0.43:=
	chromeos-base/system_api:=
"
