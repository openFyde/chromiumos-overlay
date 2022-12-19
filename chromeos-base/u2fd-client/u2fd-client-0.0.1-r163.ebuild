# Copyright 2022 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="ec7b41ee34a1af1d7dbd5f7ce02bca7b4210901c"
CROS_WORKON_TREE=("0c3a30cd50ce72094fbd880f2d16d449139646a2" "34a351a81cfca5a4c7376390643a1ea778c2dab0" "df143cde88af1b7e2427d71c8519156768a0ef36" "fd6923d33e6c347f8d488bc087ddcbd0d53d4fea" "6de49d0bc794fced41130308586470b1f89d76ab" "f874db96c12b1f01104bf43cac53d49ac8ab8335" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
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
