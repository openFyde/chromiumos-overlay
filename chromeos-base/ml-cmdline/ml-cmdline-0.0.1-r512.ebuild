# Copyright 2020 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="136c3e114b65f2c6c5f026376c2e75c73c2478a3"
CROS_WORKON_TREE=("eb1fe3bef742a865c350a9d742e224d4077efbd5" "02598ed62ece836533eaa58a0af6ff27157bd2e9" "4fdf0aaf1e9414b3fad0baa6de0dc31a35f5b5bf" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_DESTDIR="${S}/platform2"
CROS_WORKON_SUBTREE="common-mk ml ml_benchmark .gn"

PLATFORM_SUBDIR="ml"

inherit cros-workon platform

DESCRIPTION="Command line interface to machine learning service for Chromium OS"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/main/ml"

LICENSE="BSD-Google"
KEYWORDS="*"
SLOT="0/0"
IUSE="internal"

RDEPEND="
	chromeos-base/chrome-icu:=
	>=chromeos-base/metrics-0.0.1-r3152:=
	chromeos-base/ml:=
	sci-libs/tensorflow:=
"

DEPEND="
	${RDEPEND}
"

platform_pkg_test() {
	platform test_all
}
