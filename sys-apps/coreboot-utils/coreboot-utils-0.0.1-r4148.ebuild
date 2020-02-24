# Copyright 2012 The Chromium OS Authors
# Distributed under the terms of the GNU General Public License v2
# $Header:

EAPI="4"
CROS_WORKON_COMMIT=("99abbbdbe7e61338024021f031359c7581c726c2" "024d9c1879dcb808e3e819f485367e0249a18081")
CROS_WORKON_TREE=("62fa4f7a06b0df352464dc1f2d7010255e0f24f3" "423e215864208be70a563f167e95a5a362d1ec86")
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
