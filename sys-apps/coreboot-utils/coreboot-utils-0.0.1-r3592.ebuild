# Copyright 2012 The Chromium OS Authors
# Distributed under the terms of the GNU General Public License v2
# $Header:

EAPI="4"
CROS_WORKON_COMMIT=("e4d3d2d078d0a8f705afe2b6c741118727614bf0" "aad0cfff9dea75a405a2ebff48c87b03cce43051")
CROS_WORKON_TREE=("348b7280a3e09f43ac10e64d6ef53355c09c8f27" "53a4a4a919e28b3afdb6313d1e561e2ef300171c")
CROS_WORKON_PROJECT=(
	"chromiumos/third_party/coreboot"
	"chromiumos/platform/vboot_reference"
)
CROS_WORKON_LOCALNAME=(
	"coreboot"
	"../platform/vboot_reference"
)
CROS_WORKON_DESTDIR=(
	"${S}"
	"${S}/3rdparty/vboot"
)

inherit cros-workon toolchain-funcs

DESCRIPTION="Utilities for modifying coreboot firmware images"
HOMEPAGE="http://coreboot.org"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="*"
IUSE="cros_host mma +pci static"

LIB_DEPEND="sys-apps/pciutils[static-libs(+)]"
RDEPEND="!static? ( ${LIB_DEPEND//\[static-libs(+)]} )"
DEPEND="${RDEPEND}
	static? ( ${LIB_DEPEND} )
"

_emake() {
	emake TOOLLDFLAGS="${LDFLAGS}" "$@"
}

src_configure() {
	use static && append-ldflags -static
	cros-workon_src_configure
}

is_x86() {
	use x86 || use amd64
}

src_compile() {
	tc-export CC
	_emake -C util/cbfstool obj="${PWD}/util/cbfstool"
	if use cros_host; then
		_emake -C util/archive CC="${CC}"
	else
		_emake -C util/cbmem CC="${CC}"
	fi
	if is_x86; then
		if use cros_host; then
			_emake -C util/ifdtool
		else
			_emake -C util/superiotool CC="${CC}" \
				CONFIG_PCI=$(usex pci)
			_emake -C util/inteltool CC="${CC}"
			_emake -C util/nvramtool CC="${CC}"
		fi
	fi
}

src_install() {
	dobin util/cbfstool/cbfstool
	if use cros_host; then
		dobin util/cbfstool/fmaptool
		dobin util/cbfstool/cbfs-compression-tool
		dobin util/archive/archive
	else
		dobin util/cbmem/cbmem
	fi
	if is_x86; then
		if use cros_host; then
			dobin util/ifdtool/ifdtool
		else
			dobin util/superiotool/superiotool
			dobin util/inteltool/inteltool
			dobin util/nvramtool/nvramtool
		fi
		if use mma; then
			dobin util/mma/mma_setup_test.sh
			dobin util/mma/mma_get_result.sh
			dobin util/mma/mma_automated_test.sh
			insinto /etc/init
			doins util/mma/mma.conf
		fi
	fi
}
