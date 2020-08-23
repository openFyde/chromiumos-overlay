# Copyright (c) 2011 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="2d44b62719ae4f14c493aaba461a9dab3e9875dd"
CROS_WORKON_TREE="65e5be70ec29da335401741c3db6e3af9e523c52"
CROS_WORKON_PROJECT="chromiumos/third_party/hdctools"
PYTHON_COMPAT=( python2_7 )

inherit cros-workon distutils-r1 toolchain-funcs udev

DESCRIPTION="Software to communicate with servo/miniservo debug boards"
HOMEPAGE="https://www.chromium.org/chromium-os/servo"

LICENSE="BSD-Google"
KEYWORDS="*"
IUSE="cros_host test"

COMMON_DEPEND=">=dev-embedded/libftdi-0.18:=
	dev-python/numpy:=
	>=dev-python/pexpect-3.0:=
	dev-python/pyserial:=
	>=dev-python/pyusb-1.0.2:=
	sys-power/uhubctl
	virtual/libusb:1
	chromeos-base/ec-devutils:=
	dev-python/retry-decorator:=
"

RDEPEND="${COMMON_DEPEND}
"

DEPEND="${COMMON_DEPEND}
	app-text/htmltidy:=
	test? ( dev-python/pytest:= )
"

src_test() {
	python_test() {
		py.test -v build/ || die
	}
	python_foreach_impl python_test
}

src_compile() {
	tc-export CC PKG_CONFIG
	local makeargs=( $(usex cros_host '' EXTRA_DIRS=chromeos) )
	emake "${makeargs[@]}"
	distutils-r1_src_compile
}

src_install() {
	local makeargs=(
		$(usex cros_host '' EXTRA_DIRS=chromeos)
		DESTDIR="${D}"
		LIBDIR=/usr/$(get_libdir)
		UDEV_DEST="${D}$(get_udevdir)/rules.d"
		install
	)
	emake "${makeargs[@]}"
	distutils-r1_src_install
}
