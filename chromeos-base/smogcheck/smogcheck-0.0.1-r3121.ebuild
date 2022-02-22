# Copyright (c) 2011 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="6616ec8883ca6d764f5c519293a3eb87166d95e9"
CROS_WORKON_TREE=("66620b9095b5bf39fa51c8e546595edadafdadaa" "25b90cd13b01122d778a1d55d814c5b001b88d22" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_SUBTREE="common-mk smogcheck .gn"
CROS_WORKON_INCREMENTAL_BUILD="1"
CROS_WORKON_OUTOFTREE_BUILD="1"

inherit cros-common.mk cros-sanitizers cros-workon cros-debug

DESCRIPTION="TPM SmogCheck library"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/master/smogcheck/"

LICENSE="BSD-Google"
KEYWORDS="*"
IUSE="-asan"

src_unpack() {
	cros-workon_src_unpack
	S+="/smogcheck"
}

src_configure() {
	sanitizers-setup-env
	cros-common.mk_src_configure
}

src_install() {
	emake DESTDIR="${D}" LIBDIR="$(get_libdir)" install
}
