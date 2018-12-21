# Copyright 2016 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

CROS_WORKON_PROJECT="aosp/platform/external/libmojo"
CROS_WORKON_COMMIT="02d8c056c1f7396f54b5871f2d09e89be6244bb4"
CROS_WORKON_LOCALNAME="aosp/external/libmojo"
CROS_WORKON_BLACKLIST="1"

inherit cros-debug cros-fuzzer cros-sanitizers cros-workon libchrome multilib toolchain-funcs

DESCRIPTION="Mojo IPC library"
HOMEPAGE="https://android.googlesource.com/platform/external/libmojo/"
SRC_URI=""

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
IUSE=""

DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_prepare() {
	epatch "${FILESDIR}/${P}-Makefile.patch"
}

src_configure() {
	if [[ "${PV}" != "${LIBCHROME_VERS}" ]]; then
		die "Version mismatch"
	fi
	sanitizers-setup-env
	tc-export CC CXX AR RANLIB LD NM PKG_CONFIG
	cros-debug-add-NDEBUG
}

src_compile() {
	emake templates
	emake BASE_VER="${LIBCHROME_VERS}" LIB="$(get_libdir)"
}

src_install() {
	default

	local d header_dirs=(
		build
		ipc
		mojo/common
		mojo/edk/embedder
		mojo/edk/js
		mojo/edk/system
		mojo/public/c/system
		mojo/public/cpp/bindings
		mojo/public/cpp/bindings/lib
		mojo/public/cpp/system
		mojo/public/interfaces/bindings
		mojo/public/js
	)
	for d in "${header_dirs[@]}" ; do
		insinto "/usr/include/libmojo-${PV}/${d}"
		doins "${d}"/*.h
	done

	insinto "/usr/$(get_libdir)/pkgconfig"
	doins "libmojo-${PV}.pc"
}
