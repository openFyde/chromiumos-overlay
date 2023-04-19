# Copyright 2022 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="3a8bad7d5ae3082031e6a20859cd37085d907336"
CROS_WORKON_TREE=("6350979dbc8b7aa70c83ad8a03dded778848025d" "c0264ace18f901db759964a1f346331f593daaf7" "52bfb45e6da37ea7e51cce6652af46bcb31d659c" "a2002e5b021a481c966a494642397c400fe65c93" "b65b4cd8fb8321f61ba6e31a6120a3b9c208946a" "323e117b9a8a1da3748701fd2965c8ad6c8e1b52" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
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
