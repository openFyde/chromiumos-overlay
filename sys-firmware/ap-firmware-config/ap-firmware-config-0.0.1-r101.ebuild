# Copyright 2021 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="886d60a315afd5c862662290a05193ae896f5caa"
CROS_WORKON_TREE=("706fa4a532e5bc9f9deadea1c35c8f774e3f3c9c" "9dc51c42f7c3bc915dba587092317fd6391e1477" "142d92b8aac1b030010e381d939d82675bf7c336" "bb7de3b1d4f960d843d3357bf0eff14cfbd3603d")
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

src_compile() {
	"${S}/chromite/bin/cros" ap dump-config -o "${T}/fw-config.json" \
		|| die "cros ap dump-config failed"
}

src_install() {
	insinto "/usr/share/ap_firmware_config/"
	doins "${T}/fw-config.json"
}
