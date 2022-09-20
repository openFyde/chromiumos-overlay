# Copyright 2021 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="66306017f79b546e4b4c0dc339fb951328e60015"
CROS_WORKON_TREE=("f0f04dcc4a3bd932119b7b50e4e78a2a5f4f40ff" "111f71cbb9fa5cb3abc512655b54f5ac7ca1bbf1" "8551558836f5f20c0f306f1cad84ee04db5a11ab" "06444335376f8165c3d7765ae1040d099eef806c")
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
