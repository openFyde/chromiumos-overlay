# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

CROS_WORKON_COMMIT="12495d83b22c0a08af3f779e428e6d21eb40fa37"
CROS_WORKON_TREE=("6e7a51056a0752e4fe787085dbdfbedf6510aba8" "962f86e1ead2d604e6c1d5485d9ab6d2fe849d24" "dc1506ef7c8cfd2c5ffd1809dac05596ec18773c")
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="common-mk chromeos-common-script .gn"

PLATFORM_SUBDIR="chromeos-common-script"

inherit cros-workon platform

DESCRIPTION="Chrome OS storage info tools"
HOMEPAGE="http://www.chromium.org/"
SRC_URI=""

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
IUSE="direncryption"

DEPEND=""

RDEPEND="!<chromeos-base/chromeos-installer-0.0.3"

src_install() {
	insinto /usr/share/misc
	doins share/chromeos-common.sh
	if use direncryption; then
		sed -i '/local direncryption_enabled=/s/false/true/' \
			"${D}/usr/share/misc/chromeos-common.sh" ||
			die "Can not set directory encryption in common library"
	fi
}
