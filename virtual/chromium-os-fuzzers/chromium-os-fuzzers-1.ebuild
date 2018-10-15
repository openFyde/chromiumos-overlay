# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

DESCRIPTION="List of packages that should be fuzzed"
HOMEPAGE="http://dev.chromium.org/"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"

RDEPEND="
	chromeos-base/authpolicy[fuzzer]
	chromeos-base/chromeos-ec[fuzzer]
	chromeos-base/crosdns[fuzzer]
	chromeos-base/cryptohome[fuzzer]
	chromeos-base/midis[fuzzer]
	chromeos-base/permission_broker[fuzzer]
	chromeos-base/shill[fuzzer]
	chromeos-base/smbprovider[fuzzer]
	chromeos-base/trunks[fuzzer]
	dev-util/bsdiff[fuzzer]
	dev-util/puffin[fuzzer]
	media-libs/virglrenderer[fuzzer]
"
