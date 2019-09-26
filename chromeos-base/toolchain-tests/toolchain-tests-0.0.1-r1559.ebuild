# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5
CROS_WORKON_COMMIT="dbe7246e0886afeb66e7ff22745d3018431487db"
CROS_WORKON_TREE="c4b237aefa843e2c3e87eae3bc8ad37a649e3027"
CROS_WORKON_PROJECT="chromiumos/third_party/autotest"
CROS_WORKON_LOCALNAME=../third_party/autotest/files

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
