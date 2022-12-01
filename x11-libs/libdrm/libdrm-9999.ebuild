# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="7"
EGIT_REPO_URI="https://gitlab.freedesktop.org/mesa/drm.git"
if [[ ${PV} != *9999* ]]; then
	CROS_WORKON_COMMIT="b9ca37b3134861048986b75896c0915cbf2e97f9"
	CROS_WORKON_TREE="6c515810bee8549d81e68c548a26a63909f8e716"
fi
CROS_WORKON_PROJECT="chromiumos/third_party/libdrm"
CROS_WORKON_EGIT_BRANCH="upstream/master"
CROS_WORKON_MANUAL_UPREV="1"

inherit cros-workon flag-o-matic meson

DESCRIPTION="X.Org libdrm library"
HOMEPAGE="http://dri.freedesktop.org/"
SRC_URI=""

# This package uses the MIT license inherited from Xorg but fails to provide
# any license file in its source, so we add X as a license, which lists all
# the Xorg copyright holders and allows license generation to pick them up.
LICENSE="|| ( MIT X )"
SLOT="0"
if [[ ${PV} = *9999* ]]; then
	KEYWORDS="~*"
else
	KEYWORDS="*"
fi
VIDEO_CARDS="amdgpu freedreno intel nouveau omap radeon vc4 vmware"
for card in ${VIDEO_CARDS}; do
	IUSE_VIDEO_CARDS+=" video_cards_${card}"
done

IUSE="${IUSE_VIDEO_CARDS} manpages +udev"
RESTRICT="test" # see bug #236845

RDEPEND="dev-libs/libpthread-stubs
	udev? ( virtual/udev )
	video_cards_amdgpu? ( dev-util/cunit )
	video_cards_intel? ( >=x11-libs/libpciaccess-0.10 )
	!<x11-libs/libdrm-tests-2.4.58-r3
"

DEPEND="${RDEPEND}"

src_prepare() {
	eapply "${FILESDIR}"/Add-header-for-Rockchip-DRM-userspace.patch
	eapply "${FILESDIR}"/Add-header-for-Mediatek-DRM-userspace.patch
	eapply "${FILESDIR}"/Add-Evdi-module-userspace-api-file.patch
	eapply "${FILESDIR}"/Add-Rockchip-AFBC-modifier.patch
	eapply "${FILESDIR}"/Add-back-VENDOR_NV-name.patch
	eapply "${FILESDIR}"/CHROMIUM-add-resource-info-header.patch

	eapply_user
}

src_configure() {
	append-lfs-flags
	cros_optimize_package_for_speed

	local emesonargs=(
		-Dinstall-test-programs=true
		$(meson_feature video_cards_amdgpu amdgpu)
		$(meson_feature video_cards_freedreno freedreno)
		$(meson_feature video_cards_intel intel)
		$(meson_feature video_cards_nouveau nouveau)
		$(meson_feature video_cards_omap omap)
		$(meson_feature video_cards_radeon radeon)
		$(meson_feature video_cards_vc4 vc4)
		$(meson_feature video_cards_vmware vmwgfx)
		$(meson_feature manpages man-pages)
		$(meson_use udev)
		-Dcairo-tests=disabled
	)
	meson_src_configure
}
