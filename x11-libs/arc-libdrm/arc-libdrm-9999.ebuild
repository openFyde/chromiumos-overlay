# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="7"
EGIT_REPO_URI="https://gitlab.freedesktop.org/mesa/drm.git"
if [[ ${PV} != *9999* ]]; then
	CROS_WORKON_COMMIT="b9ca37b3134861048986b75896c0915cbf2e97f9"
	CROS_WORKON_TREE="6c515810bee8549d81e68c548a26a63909f8e716"
fi
CROS_WORKON_PROJECT="chromiumos/third_party/libdrm"
CROS_WORKON_LOCALNAME="libdrm"
CROS_WORKON_EGIT_BRANCH="chromeos-2.4.112"
CROS_WORKON_MANUAL_UPREV="1"

P=${P#"arc-"}
PN=${PN#"arc-"}
S="${WORKDIR}/${P}"

inherit cros-workon arc-build flag-o-matic meson multilib-minimal

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
VIDEO_CARDS="amdgpu freedreno nouveau omap radeon vc4 vmware"
for card in ${VIDEO_CARDS}; do
	IUSE_VIDEO_CARDS+=" video_cards_${card}"
done

IUSE="${IUSE_VIDEO_CARDS} manpages +udev"
RESTRICT="test" # see bug #236845

RDEPEND=""
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}/Add-header-for-Rockchip-DRM-userspace.patch"
	"${FILESDIR}/Add-header-for-Mediatek-DRM-userspace.patch"
	"${FILESDIR}/Add-Evdi-module-userspace-api-file.patch"
	"${FILESDIR}/Add-Rockchip-AFBC-modifier.patch"
	"${FILESDIR}/Add-back-VENDOR_NV-name.patch"
	"${FILESDIR}/CHROMIUM-add-resource-info-header.patch"
)

src_configure() {
	# FIXME(tfiga): Could inherit arc-build invoke this implicitly?
	arc-build-select-clang
	# append-lfs-flags noop for Android/bionic b/260698283, hence not added.
	multilib-minimal_src_configure
}

multilib_src_configure() {
	arc-build-create-cross-file

	local emesonargs=(
		-Dinstall-test-programs=false
		$(meson_feature video_cards_amdgpu amdgpu)
		$(meson_feature video_cards_freedreno freedreno)
		$(meson_feature video_cards_nouveau nouveau)
		$(meson_feature video_cards_omap omap)
		$(meson_feature video_cards_radeon radeon)
		$(meson_feature video_cards_vc4 vc4)
		$(meson_feature video_cards_vmware vmwgfx)
		$(meson_feature manpages man-pages)
		$(meson_use udev)
		-Dcairo-tests=disabled
		-Dintel=disabled
		--prefix="${ARC_PREFIX}/vendor"
		--datadir="${ARC_PREFIX}/vendor/usr/share"
		--cross-file="${ARC_CROSS_FILE}"
	)
	meson_src_configure
}

multilib_src_compile() {
	meson_src_compile
}

multilib_src_install() {
	meson_src_install
}
