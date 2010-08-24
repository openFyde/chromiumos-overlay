# Copyright (c) 2009 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=2

# stable commit ID
CROS_WORKON_COMMIT="910def6e2b8b0afde49d9852de4ca1efd5ef6e64"

if [[ -n "${ST1Q_SOURCES_QUALCOMM}" ]] ; then
	CROS_WORKON_REPO="git://git-1.quicinc.com"
	CROS_WORKON_PROJECT="graphics/xf86-video-msm"
	CROS_WORKON_LOCALNAME="qcom/opensource/graphics/xf86-video-msm"
	EGIT_BRANCH=chromium
else
	EGIT_BRANCH=master
fi

inherit cros-workon toolchain-funcs autotools

DESCRIPTION="X.Org driver for MSM SOC"
LICENSE=""
SLOT="0"
KEYWORDS="arm"
IUSE="dri"

RDEPEND=">=x11-base/xorg-server-1.4
	chromeos-base/kernel-headers
	"
DEPEND="${RDEPEND}
	x11-proto/fontsproto
	x11-proto/renderproto
	x11-proto/xproto
	"

src_prepare() {
	eautoreconf || die
}

src_configure() {
	econf --enable-maintainer-mode || die
}

src_install() {
	insinto /usr/lib/xorg/modules/drivers
	doins "${S}"/src/.libs/msm_drv.so
}
