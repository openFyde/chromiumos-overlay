# Copyright 2020 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="200d966b5647a49ca460c18763fad1bceb447366"
CROS_WORKON_TREE=("d4469c62dab4018d72e6355d285651f2780df211" "3b4d7f82f5d68f35d2412d679e794ec15a3a45e0" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="common-mk foomatic_shell .gn"

PLATFORM_SUBDIR="foomatic_shell"

inherit cros-workon platform

DESCRIPTION="Mini shell used by foomatic-rip to execute scripts in PPD files."
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/foomatic_shell/"

LICENSE="BSD-Google"
KEYWORDS="*"

src_install() {
	dobin "${OUT}/foomatic_shell"

	# Install fuzzer
	local fuzzer_component_id="167231"
	platform_fuzzer_install "${S}"/OWNERS "${OUT}"/foomatic_shell_fuzzer \
		--comp "${fuzzer_component_id}"
}

platform_pkg_test() {
	platform_test "run" "${OUT}/foomatic_shell_test"
}
