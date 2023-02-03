# Copyright 2021 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="a2527f8933c9fc50df32c95cffe080d14e634f7a"
CROS_WORKON_TREE=("0211021f57a5df4cc329e598202dc47d424eb1c6" "2d31603031a4273d74b9019b71a6893a585badee" "f8b094f1554c29c67311767faa4de2dc47ce967a" "06444335376f8165c3d7765ae1040d099eef806c")
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
