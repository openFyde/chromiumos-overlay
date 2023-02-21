# Copyright 2011 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="db50fe0ee6a2e2756fd40d261155c240548ad26b"
CROS_WORKON_TREE=("92a7718bfe5a15c594fcc6b0855e68b0981cd9a0" "7ab4beb7a9d267fc2e5047a2035fa550f082051f" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_SUBTREE="common-mk smogcheck .gn"
CROS_WORKON_INCREMENTAL_BUILD="1"
CROS_WORKON_OUTOFTREE_BUILD="1"

inherit cros-common.mk cros-sanitizers cros-workon cros-debug

DESCRIPTION="TPM SmogCheck library"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/smogcheck/"

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
