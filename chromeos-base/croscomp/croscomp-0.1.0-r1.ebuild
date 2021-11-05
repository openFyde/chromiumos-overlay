# Copyright 2021 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="576b6d5086ffbff6b626dc94ade8aa7569410834"
CROS_WORKON_TREE="3c35606684904519b09978c97a46c9fcc4f1af35"
CROS_WORKON_PROJECT="chromiumos/platform/croscomp"
CROS_WORKON_LOCALNAME="platform/croscomp"
CROS_WORKON_INCREMENTAL_BUILD=1

inherit meson cros-rust cros-workon

DESCRIPTION="ChromeOS System Compositor"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform/croscomp/"

LICENSE="MIT BSD-Google"
SLOT="0/0"
KEYWORDS="*"
IUSE=""

COMMON_DEPEND="
	x11-libs/cairo:=
	sys-libs/mtdev:=
	x11-libs/libxkbcommon:=
	x11-libs/pixman:=
	x11-libs/pango:=
	dev-libs/wayland:=
	dev-libs/expat:=
	dev-libs/libevdev:=
	dev-libs/libinput:=
	media-libs/lcms:=
	>=x11-libs/libdrm-2.4.94:=
"

RDEPEND="${COMMON_DEPEND}
"

DEPEND="${COMMON_DEPEND}
	dev-libs/wayland-protocols:=
	virtual/bindgen:=
	>=dev-rust/libc-0.2.44 <dev-rust/libc-0.3.0:=
	=dev-rust/cfg-if-1.0.0:=
	>=dev-rust/structopt-0.3.20:=
	>=dev-rust/parking_lot-0.7.1:=
	>=dev-rust/scoped-tls-0.1.0:=
	>=dev-rust/env_logger-0.8.3:=
"

BDEPEND="
	virtual/pkgconfig
"

src_unpack() {
	# Unpack both the project and dependency source code
	cros-workon_src_unpack
	cros-rust_src_unpack
}

src_prepare() {
	cros-rust_src_prepare
	default
}

src_configure() {
	export MESON_BUILD_DIR="${WORKDIR}/${P}-build"
	EMESON_SOURCE=${S}/weston
	meson_src_configure
	cros-rust_src_configure
}

src_compile() {
	export MESON_BUILD_DIR="${WORKDIR}/${P}-build"
	meson_src_compile
	ecargo_build -v -p croscomp
}

src_install() {
	# cargo doesn't know how to install cross-compiled binaries.  It will
	# always install native binaries for the host system.  Manually install
	# crosvm instead.
	local build_dir="$(cros-rust_get_build_dir)"
	dobin "${build_dir}/croscomp"

	insinto /etc/init
	doins croscomp.conf
	dobin croscomp-terminal

	meson_src_install
}
