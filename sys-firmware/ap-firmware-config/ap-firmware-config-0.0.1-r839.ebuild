# Copyright 2021 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="86d8e7c8d442ba963d52b0b7e280435de6e7883a"
CROS_WORKON_TREE=("0daf058e32922befc0fb634e7dba7abb19f6bd26" "c1778e01cc2571e4a257c150748c6fd65bcc0a34" "fec3b80c21c1b1a1540c8c768759b7dccfe0ac3c" "b42fabca26d96614e89b7cf058a9911c3aa580ea")
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
