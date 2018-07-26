# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5

CROS_WORKON_COMMIT="3ab445de7665f1f72c2598294849fa8bdf5c2527"
CROS_WORKON_TREE=("e769c228a4a5722d79584716af46fbc53eb8504b" "3823ca902f771ec8aebe10e6c9836c2e2bb1db36")
CROS_WORKON_INCREMENTAL_BUILD="1"
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="common-mk arc/apk-cache"

PLATFORM_NATIVE_TEST="yes"
PLATFORM_SUBDIR="arc/apk-cache"
PLATFORM_GYP_FILE="apk-cache.gyp"

inherit cros-workon platform

DESCRIPTION="Maintains APK cache in ARC."
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/master/arc/apk-cache"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
IUSE="+seccomp"

RDEPEND="
	chromeos-base/libbrillo
	chromeos-base/minijail"

DEPEND="${RDEPEND}"

src_install() {
	insinto /etc/init
	doins init/apk-cache-cleaner.conf

	# Install seccomp policy file.
	insinto /usr/share/policy
	use seccomp && newins \
		"seccomp/apk-cache-cleaner-seccomp-${ARCH}.policy" \
		apk-cache-cleaner-seccomp.policy

	dosbin "${OUT}/apk-cache-cleaner"
	dosbin apk-cache-cleaner-jailed
}

platform_pkg_test() {
	platform_test "run" "${OUT}/apk-cache-cleaner_testrunner"
}
