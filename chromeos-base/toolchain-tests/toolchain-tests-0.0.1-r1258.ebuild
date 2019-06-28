# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5
CROS_WORKON_COMMIT="12b9baf85c33d4991f270b7fc566e0a8052dc313"
CROS_WORKON_TREE="701ef4c990d7f0c25643b51c0cff8ffad72fde88"
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
