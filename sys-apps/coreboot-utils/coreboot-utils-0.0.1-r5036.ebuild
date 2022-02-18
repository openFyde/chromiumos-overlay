# Copyright 2012 The Chromium OS Authors
# Distributed under the terms of the GNU General Public License v2
# $Header:

EAPI=7
CROS_WORKON_COMMIT=("a533ac7f7997efdc15e57926d461e01752f0f73c" "e35fb64df248c030d4aea1768a7aec68766b3e0c")
CROS_WORKON_TREE=("a53d8d2cda169a7b70f3ead920a6d032fc034400" "46900a72390fc533b7f0141f383bafebef4432a8" "b43fb634c3c9e0e97394837b2b76e0506173a4c1" "7970bef34ce4d0b3023def52ff72e1c4cd2eca85" "0de467a25a3ac1d59c6d3d849ade5536a8d375e1" "59d4004a1a7159d2b81fadd69f6b1996b56dc84e" "8c4bf470fbe310797cf9b09016efcbe8153e8124" "664c26175ad2098e1e83670ab5c33fa35c545f90" "e03866d9ecdf3529248f3d4bd0b63499a092f2c3" "974edbc79de4f730edf8c9d01bc9186f97417f1d" "bfef75f3a17da232f402e1799b42c25c2b1c5176" "4f0dee4145abfb6062f4c33db95e950c3e076ae3" "e63744015b9f12e18123d71c80d37fb7d6b9da0f" "077c1104f821017100ad872dbe1b5887ed2b91c7" "d791abf7a7e729076261ca393e797be426f3f65f" "19fb689a3522ee96c4f0532ea46674a66dbad9fc")
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
CROS_WORKON_EGIT_BRANCH=(
	"chromeos-2016.05"
	"main"
)

# coreboot:src/arch/x85/include/arch: used by inteltool, x86 only
# coreboot:src/commonlib: used by cbfstool
# coreboot:src/vendorcode/intel: used by cbfstool
# coreboot:util/*: tools built by this ebuild
# vboot: minimum set of files and directories to build vboot_lib for cbfstool
CROS_WORKON_SUBTREE=(
	"src/arch/x86/include/arch src/commonlib src/vendorcode/intel util/archive util/cbmem util/cbfstool util/ifdtool util/inteltool util/mma util/nvramtool util/superiotool"
	"Makefile cgpt host firmware futility"
)

inherit cros-workon toolchain-funcs

DESCRIPTION="Utilities for modifying coreboot firmware images"
HOMEPAGE="http://coreboot.org"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="*"
IUSE="cros_host mma +pci static"

LIB_DEPEND="
	sys-apps/pciutils[static-libs(+)]
	sys-apps/flashrom
"
RDEPEND="!static? ( ${LIB_DEPEND//\[static-libs(+)]} )"
DEPEND="${RDEPEND}
	static? ( ${LIB_DEPEND} )
"

_emake() {
	emake \
		TOOLLDFLAGS="${LDFLAGS}" \
		CC="${CC}" \
		STRIP="true" \
		"$@"
}

src_configure() {
	use static && append-ldflags -static
	tc-export CC PKG_CONFIG
}

is_x86() {
	use x86 || use amd64
}

src_compile() {
	_emake -C util/cbfstool obj="${PWD}/util/cbfstool"
	if use cros_host; then
		_emake -C util/archive HOSTCC="${CC}"
	else
		_emake -C util/cbmem
	fi
	if is_x86; then
		if use cros_host; then
			_emake -C util/ifdtool
		else
			_emake -C util/superiotool \
				CONFIG_PCI=$(usex pci)
			_emake -C util/inteltool
			_emake -C util/nvramtool
		fi
	fi
}

src_install() {
	dobin util/cbfstool/cbfstool
	dobin util/cbfstool/elogtool
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
