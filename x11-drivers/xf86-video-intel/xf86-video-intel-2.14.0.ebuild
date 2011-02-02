# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-drivers/xf86-video-intel/xf86-video-intel-2.14.0.ebuild,v 1.2 2011/01/09 23:10:56 chithanh Exp $

EAPI=3

inherit linux-info xorg-2

DESCRIPTION="X.Org driver for Intel cards"

KEYWORDS="~amd64 ~ia64 x86 ~x86-fbsd"
IUSE="dri"

RDEPEND=">=x11-base/xorg-server-1.6
	>=x11-libs/libdrm-2.4.23
	x11-libs/libpciaccess
	x11-libs/libXext
	x11-libs/libXfixes
	x11-libs/libXvMC
	>=x11-libs/libxcb-1.5"
DEPEND="${RDEPEND}
	sys-fs/udev
	>=x11-proto/dri2proto-1.99.3
	x11-proto/fontsproto
	x11-proto/randrproto
	x11-proto/renderproto
	x11-proto/xextproto
	x11-proto/xproto
	dri? ( x11-proto/xf86driproto
	       x11-proto/glproto )"

PATCHES=(
	# Copy the initial framebuffer contents when starting X so we can get
	# seamless transitions.
	"${FILESDIR}/${PV}-copy-fb.patch"
	"${FILESDIR}/${PV}-no-pageflip.patch"
)

pkg_setup() {
	# Stuff required to cross compile the package
	if tc-is-cross-compiler ; then
		AT_M4DIR="${SYSROOT}/usr/share/aclocal"
		local temp="${SYSROOT//\//_}"
		local ac_sysroot="${temp//-/_}"
		local ac_include_prefix="ac_cv_file_${ac_sysroot}_usr_include"
		eval export ${ac_include_prefix}_xorg_dri_h=yes
		eval export ${ac_include_prefix}_xorg_sarea_h=yes
		eval export ${ac_include_prefix}_xorg_dristruct_h=yes
	fi

	CONFIGURE_OPTIONS="$(use_enable dri)"
}

pkg_postinst() {
	if linux_config_exists \
		&& ! linux_chkconfig_present DRM_I915_KMS; then
		echo
		ewarn "This driver requires KMS support in your kernel"
		ewarn "  Device Drivers --->"
		ewarn "    Graphics support --->"
		ewarn "      Direct Rendering Manager (XFree86 4.1.0 and higher DRI support)  --->"
		ewarn "      <*>   Intel 830M, 845G, 852GM, 855GM, 865G (i915 driver)  --->"
		ewarn "              i915 driver"
		ewarn "      [*]       Enable modesetting on intel by default"
		echo
	fi
}
