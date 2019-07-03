# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

EAPI=6

CROS_WORKON_COMMIT="99ee10a00bc62b49bbf582ec6ae9a4863bd2335f"
CROS_WORKON_TREE=("720f8e62a8429f6f1448b1aab7e27d406bf0b635" "ee08ee7611e081e874d2ea7711a80fd2a8acca8d" "dc1506ef7c8cfd2c5ffd1809dac05596ec18773c")
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="common-mk libhwsec .gn"

PLATFORM_SUBDIR="libhwsec"

inherit cros-workon platform

DESCRIPTION="Crypto and utility functions used in TPM related daemons."
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/master/libhwsec/"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"

RDEPEND="
	chromeos-base/libbrillo:=
"

DEPEND="
	${RDEPEND}
"

src_install() {
	insinto /usr/include/chromeos/libhwsec
	doins *.h

	dolib.so "${OUT}"/lib/libhwsec.so
}


platform_pkg_test() {
	local tests=(
		hwsec_test
	)
	local test_bin
	for test_bin in "${tests[@]}"; do
		platform_test "run" "${OUT}/${test_bin}"
	done
}
