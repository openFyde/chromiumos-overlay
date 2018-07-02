# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5
CROS_WORKON_COMMIT="41dbe2309a9b0066dba70215bde0d9265e0b6cea"
CROS_WORKON_TREE="6c7c8e7198b627ab842cebe8be35b914ed0a484f"
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
src_test() {
	default
}
