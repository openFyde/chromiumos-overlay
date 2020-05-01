# Copyright 2020 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

CROS_WORKON_COMMIT="b83cb14aafc86e797dedd6eb3d16c2175ca47dd0"
CROS_WORKON_TREE="d784939f82de36a687957fac3edafbe0af77e6d2"
CROS_WORKON_PROJECT="chromiumos/platform/tast-tests"
CROS_WORKON_LOCALNAME="platform/tast-tests"
CROS_WORKON_SUBTREE="android"

inherit cros-workon

DESCRIPTION="Compiled apks used by local Tast tests in the cros bundle"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform/tast-tests/+/master/android"

LICENSE="BSD-Google GPL-3"
SLOT="0"
KEYWORDS="*"

BDEPEND="
	chromeos-base/android-sdk
	dev-util/gn
"

DEPEND="${RDEPEND}"
OUT=$(cros-workon_get_build_dir)

src_compile() {
	gn gen "${OUT}" --root="${S}"/android || die "gn failed"
	ninja -C "${OUT}" || die "build failed"
}

src_install() {
	if [ ! -d "${OUT}/apks" ]; then
		ewarn "There is no apk."
		ewarn "If you want to add a helper APK, add it under tast-tests/android"
		ewarn "and modify BUILD.gn."
		return
	fi
	insinto /usr/libexec/tast/apks/local/cros
	doins "${OUT}"/apks/*
}

