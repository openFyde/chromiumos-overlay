# Copyright (c) 2011 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="cc1d8ccde6295dbc2a519307383dc72da01875d4"
CROS_WORKON_TREE=("ad301a4b345fce6b7da1833dbc8976b38360b43f" "f1a3a02a7d814963817ddfc289d86c25c19a4c87" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_SUBTREE="common-mk smogcheck .gn"
CROS_WORKON_INCREMENTAL_BUILD="1"
CROS_WORKON_OUTOFTREE_BUILD="1"

inherit cros-common.mk cros-sanitizers cros-workon cros-debug multilib

DESCRIPTION="TPM SmogCheck library"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/master/smogcheck/"

LICENSE="BSD-Google"
KEYWORDS="*"
IUSE="-asan"

src_unpack() {
	cros-workon_src_unpack
	S+="/smogcheck"
}

src_prepare() {
	cros-workon_src_prepare
	cros-common.mk_src_prepare
}

src_configure() {
	sanitizers-setup-env
	cros-workon_src_configure
}

src_install() {
	emake DESTDIR="${D}" LIBDIR="$(get_libdir)" install
}
