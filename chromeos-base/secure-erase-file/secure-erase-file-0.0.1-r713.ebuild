# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

CROS_WORKON_COMMIT="881812bab12fe462752b347ced064cc008681b38"
CROS_WORKON_TREE=("68a853bd6ab2d1bd1ad2689975aae9e9da5ce36a" "af3ecc3924359691a89fb2dac19c12e197648f15" "dc1506ef7c8cfd2c5ffd1809dac05596ec18773c")
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="common-mk secure_erase_file .gn"

PLATFORM_SUBDIR="secure_erase_file"

inherit cros-workon platform

DESCRIPTION="Secure file erasure for Chrome OS"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/master/secure_erase_file/"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
IUSE=""

DEPEND="
	chromeos-base/libbrillo
"

RDEPEND="
	${DEPEND}
"

src_install() {
	dobin "${OUT}/secure_erase_file"
	dolib.so "${OUT}/lib/libsecure_erase_file.so"
}
