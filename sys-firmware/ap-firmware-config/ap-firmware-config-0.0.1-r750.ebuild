# Copyright 2021 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="6be662927f5222fc52b7a6d15d03a9b163f5f900"
CROS_WORKON_TREE=("01a189d9c95e5b787bb96db4c6d4abfbb2005140" "c1778e01cc2571e4a257c150748c6fd65bcc0a34" "d0c446408b721b4096400b150cc93080c3c5614d" "9856c7544aa8508c329258abd97a93f52571cd9c")
PYTHON_COMPAT=( python3_{6..9} )

CROS_WORKON_LOCALNAME="../../chromite"
CROS_WORKON_PROJECT="chromiumos/chromite"
CROS_WORKON_DESTDIR="${S}/chromite"
CROS_WORKON_SUBTREE="lib bin scripts PRESUBMIT.cfg"

inherit cros-workon python-any-r1

DESCRIPTION="Exports JSON config from chromite/lib/firmware/ap_firmware_config"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/chromite/+/refs/heads/main/lib/firmware/README.md"
LICENSE="BSD-Google"
KEYWORDS="*"
IUSE=""

python_check_deps() {
	has_version -b "chromeos-base/chromite-sdk[${PYTHON_USEDEP}]"
}

src_compile() {
	"${S}/chromite/bin/cros" ap dump-config -o "${T}/fw-config.json" \
		|| die "cros ap dump-config failed"
}

src_install() {
	insinto "/usr/share/ap_firmware_config/"
	doins "${T}/fw-config.json"
}
