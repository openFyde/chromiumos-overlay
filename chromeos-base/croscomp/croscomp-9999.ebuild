# Copyright 2021 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_PROJECT="chromiumos/platform/croscomp"
CROS_WORKON_LOCALNAME="platform/croscomp"
CROS_WORKON_INCREMENTAL_BUILD=1

inherit meson cros-rust cros-workon

DESCRIPTION="ChromeOS System Compositor"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform/croscomp/"

LICENSE="MIT BSD-Google"
SLOT="0/0"
KEYWORDS="~*"
IUSE=""

COMMON_DEPEND="
	>=x11-libs/libdrm-2.4.94:=
	dev-libs/expat:=
	dev-libs/libevdev:=
	dev-libs/libinput:=
	dev-libs/wayland:=
	media-libs/lcms:=
	media-libs/libpng:=
	sys-libs/mtdev:=
	x11-libs/cairo:=
	x11-libs/libxkbcommon:=
	x11-libs/pango:=
	x11-libs/pixman:=
"

RDEPEND="${COMMON_DEPEND}
	virtual/opengles
	|| ( media-libs/mesa[gbm] media-libs/minigbm )
"

# Deps for third party crates
dlib_DEPEND="
	=dev-rust/libloading-0.7*
"

wayland_scanner_DEPEND=""

wayland_commons_DEPEND="
	=dev-rust/nix-0.23*
	>=dev-rust/once_cell-1.1.0 <dev-rust/once_cell-2.0.0_alpha
	=dev-rust/smallvec-1*
"

wayland_sys_DEPEND="${dlib_DEPEND}"

wayland_server_DEPEND="
	=dev-rust/nix-0.23*
	=dev-rust/parking_lot-0.11*
"

DEPEND="${COMMON_DEPEND}
	dev-rust/third-party-crates-src:=
	${wayland_scanner_DEPEND}
	${wayland_commons_DEPEND}
	${wayland_sys_DEPEND}
	${wayland_server_DEPEND}

	dev-libs/wayland-protocols:=
	>=dev-rust/env_logger-0.8.3 <dev-rust/env_logger-0.9.0_alpha
	>=dev-rust/nix-0.23.0 <dev-rust/nix-0.24.0_alpha
	>=dev-rust/structopt-0.3.20 <dev-rust/structopt-0.4.0_alpha
	dev-rust/cbindgen
	x11-drivers/opengles-headers:=
	~dev-rust/cfg-if-1.0.0
	=dev-rust/tokio-1*
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
	cros_optimize_package_for_speed
	cros-rust_src_prepare
	default
}

src_configure() {
	sanitizers-setup-env || die
	export MESON_BUILD_DIR="${WORKDIR}/${P}-build"
	EMESON_SOURCE=${S}/weston
	meson_src_configure
	cros-rust_src_configure
}

src_compile() {
	export MESON_BUILD_DIR="${WORKDIR}/${P}-build"
	meson_src_compile
	ecargo_build -v \
		-p croscomp \
		|| die "cargo build failed"
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
