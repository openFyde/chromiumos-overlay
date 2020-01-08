# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5
CROS_WORKON_COMMIT="827d2be31321cf1b30590c6ff37cf18707f49430"
CROS_WORKON_TREE="2331e15e2de62595b9a3ce1c83e7a739802f998d"
CROS_WORKON_PROJECT="chromiumos/third_party/autotest"
CROS_WORKON_LOCALNAME="third_party/autotest/files"

inherit cros-workon

DESCRIPTION="Compilation and runtime tests for toolchain"
HOMEPAGE="http://www.chromium.org/"

LICENSE="BSD-Google"
SLOT=0
KEYWORDS="*"

src_unpack() {
	cros-workon_src_unpack
	S+="/client/site_tests/platform_ToolchainTests/src"
}

# cros-run-unit_tests checks the existence of src_test.
# Spell it explictly so that it will be tested.
# Temporarily disable this test while we are in the trasition of 
# upgrade glibc. Re-enable this after glibc upgrade finishes.
src_test() {
	if has_version '>=sys-libs/glibc-2.24'; then
		default
	else
		return
	fi
}
