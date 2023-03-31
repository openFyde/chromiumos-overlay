# Copyright 2020 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="92cb30684a155822a46578f0ffc384a40c8d3636"
CROS_WORKON_TREE=("952d2f368a90cdfa98da94394d2a56079cef3597" "96613ada44c948f1363cbf6dbf7ea28240e4fcc5" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_DESTDIR="${S}/platform2"
CROS_WORKON_SUBTREE="common-mk lorgnette .gn"

PLATFORM_SUBDIR="lorgnette"

inherit cros-workon platform

DESCRIPTION="Command line interface to scanning service for Chromium OS"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/lorgnette"

LICENSE="BSD-Google"
KEYWORDS="*"
SLOT="0/0"

RDEPEND="
	chromeos-base/lorgnette
"

src_install() {
	# platform_src_install omitted, to avoid conflicts with
	# chromeos-base/lorgnette.

	dobin "${OUT}"/lorgnette_cli
}
