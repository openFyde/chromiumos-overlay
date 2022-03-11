# Copyright 2022 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="db0a4367257fa5062164915df32afc1731517562"
CROS_WORKON_TREE=("89a39c5545810acb006c22dd6b467934202c22b5" "657879d7112bd65f190dbbf687daca14399681d0")
CROS_WORKON_LOCALNAME="../platform/crosvm"
CROS_WORKON_PROJECT="chromiumos/platform/crosvm"
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_RUST_SUBDIR="common/sys_util_core"
CROS_WORKON_SUBTREE="${CROS_RUST_SUBDIR} .cargo"
CROS_WORKON_SUBDIRS_TO_COPY=(${CROS_WORKON_SUTREE})

inherit cros-workon cros-rust

DESCRIPTION="Internal dependency of dev-rust/sys_util. Do not use directly"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform/crosvm/+/HEAD/common/sys_util_core"

LICENSE="BSD-Google"
KEYWORDS="*"
IUSE="test"

DEPEND="
	>=dev-rust/libc-0.2.93:= <dev-rust/libc-0.3.0
	=dev-rust/remain-0.2*:=
	=dev-rust/serde-1*:=
	>=dev-rust/thiserror-1.0.20:= <dev-rust/thiserror-2.0
"

# (crbug.com/1182669): build-time only deps need to be in RDEPEND so they are pulled in when
# installing binpkgs since the full source tree is required to use the crate.
# Also, do not allow to be installed with older versions of sys_util to prevent file collisions.
RDEPEND="
	${DEPEND}
	!<dev-rust/sys_util-0.1.0-r197
"
src_install() {
	(
		cd poll_token_derive || die
		cros-rust_publish poll_token_derive "$(cros-rust_get_crate_version .)"
	)

	cros-rust_src_install
}

pkg_preinst() {
	cros-rust_pkg_preinst poll_token_derive
	cros-rust_pkg_preinst
}

pkg_postinst() {
	cros-rust_pkg_postinst poll_token_derive
	cros-rust_pkg_postinst
}

pkg_prerm() {
	cros-rust_pkg_prerm poll_token_derive
	cros-rust_pkg_prerm
}

pkg_postrm() {
	cros-rust_pkg_postrm poll_token_derive
	cros-rust_pkg_postrm
}
