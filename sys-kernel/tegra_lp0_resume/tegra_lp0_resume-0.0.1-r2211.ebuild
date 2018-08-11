# Copyright 2014 The Chromium OS Authors.
# Distributed under the terms of the GNU General Public License v2

EAPI=4
CROS_WORKON_COMMIT="1311272f269f1cfb483e4dc1c3a92859430e54c8"
CROS_WORKON_TREE="7dd45f9c9d9305614ef861f13c22f11b577cbdf1"
CROS_WORKON_PROJECT="chromiumos/third_party/coreboot"

DESCRIPTION="lp0 resume blob for Tegra"
HOMEPAGE="http://www.coreboot.org"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="arm"
IUSE=""

RDEPEND=""
DEPEND=""

CROS_WORKON_LOCALNAME="coreboot"

inherit cros-workon

src_compile() {
	emake -C src/soc/nvidia/tegra124/lp0 \
		GCC_PREFIX="${CHOST}-" || \
		die "tegra_lp0_resume build failed"
}

src_install() {
	insinto /lib/firmware/tegra12x/
	doins src/soc/nvidia/tegra124/lp0/tegra_lp0_resume.fw
}
