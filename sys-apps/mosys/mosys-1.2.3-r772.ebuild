# Copyright (c) 2012 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

CROS_WORKON_COMMIT="e10fd1cbd025d5f7a64c4ee9c8a80b9c1904468a"
CROS_WORKON_TREE="68a4ecf7b8418f05ab35e5fed0091f84edf81315"
CROS_WORKON_PROJECT="chromiumos/platform/mosys"
CROS_WORKON_LOCALNAME="../platform/mosys"

MESON_AUTO_DEPEND=no

inherit flag-o-matic meson toolchain-funcs cros-unibuild cros-workon

DESCRIPTION="Utility for obtaining various bits of low-level system info"
HOMEPAGE="http://mosys.googlecode.com/"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
IUSE="unibuild"

# We need util-linux for libuuid.
RDEPEND="unibuild? (
		chromeos-base/chromeos-config
		sys-apps/dtc
	)
	sys-apps/util-linux
	>=sys-apps/flashmap-0.3-r4"
DEPEND="${RDEPEND}"

src_configure() {
	if use unibuild; then
		cp "${SYSROOT}${UNIBOARD_DTB_INSTALL_PATH}" \
			lib/cros_config/config.dtb
		cp "${SYSROOT}${UNIBOARD_C_CONFIG}" \
			lib/cros_config/cros_config_data.c
	fi

	local emesonargs=(
		$(meson_use unibuild use_cros_config)
		-Darch=$(tc-arch)
	)
	meson_src_configure
}

src_install() {
	meson_src_install
	dodoc README TODO
}
