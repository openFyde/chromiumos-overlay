# Copyright 2022 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="0b67d44bb381764cb6ada77a61e03ea4c2369b19"
CROS_WORKON_TREE=("6836462cc3ac7e9ff3ce4e355c68c389eb402bff" "ea5c411d4a2019bbb12c2a3b4d4ced77098fa013" "1e1e4efab776c8e52de56c8d5089faf429051fdb" "b0e3863eb7f2ff9a3c1f75589366d018c639f9b5" "46adf0fc10246268b92c2a13bee550bc5e2bfeae" "ce0cfe6f440daa87fe073bacc681e1e3e6005056" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
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
