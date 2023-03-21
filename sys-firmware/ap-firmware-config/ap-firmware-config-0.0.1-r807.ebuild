# Copyright 2021 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="2469ad391bd227fab4a0b837d4f4b0cc2963b8e9"
CROS_WORKON_TREE=("1161f726bb454c06570c14e607f7d62c481817b4" "c1778e01cc2571e4a257c150748c6fd65bcc0a34" "a8feeb2eb3f621aaec491763c773a119bb6a5346" "9856c7544aa8508c329258abd97a93f52571cd9c")
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
