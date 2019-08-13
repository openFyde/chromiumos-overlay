# Copyright (c) 2011 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

CROS_WORKON_COMMIT="98fd3540b8d4c57607eb0e2f3af0af071af9db49"
CROS_WORKON_TREE=("fdb2f6bdb65a4fc63e472dfd681acee205c29457" "0fe09665ccf98d579aacc0ae02842ef4f39560b9" "dc1506ef7c8cfd2c5ffd1809dac05596ec18773c")
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_SUBTREE="common-mk smogcheck .gn"
CROS_WORKON_INCREMENTAL_BUILD="1"
CROS_WORKON_OUTOFTREE_BUILD="1"

inherit cros-sanitizers cros-workon cros-debug multilib

DESCRIPTION="TPM SmogCheck library"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/master/smogcheck/"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
IUSE="-asan"

src_unpack() {
	cros-workon_src_unpack
	S+="/smogcheck"
}

src_prepare() {
	cros-workon_src_prepare
}

src_configure() {
	sanitizers-setup-env
	cros-workon_src_configure
}

src_install() {
	emake DESTDIR="${D}" LIBDIR="$(get_libdir)" install
}
