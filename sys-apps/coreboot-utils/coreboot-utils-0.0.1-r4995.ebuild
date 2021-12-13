# Copyright 2012 The Chromium OS Authors
# Distributed under the terms of the GNU General Public License v2
# $Header:

EAPI=7
CROS_WORKON_COMMIT=("cf9f3d12905475523e3b8da9af26f6b4e2063b8d" "8028cac33c9c408f90de9ceffc714a1a0ca9d583")
CROS_WORKON_TREE=("0d61dd66aff60d39125b86e170519ac9f7d2490f" "639c622686885b6674c0dee8affa05b12685e12b" "1bd63c7bda07d86d39984da316607ecf375edb0d" "7970bef34ce4d0b3023def52ff72e1c4cd2eca85" "ee74b14f29ed3a20dd01e1c7d93d1813a65e47d4" "ce703ddd0d013e021ed575a1168289b46b3d0c0c" "dbb87505ca10af01906390f2c6438a6498a5b659" "9b9ec9e0a2a285cd257ffbe55b5f524915be7906" "e03866d9ecdf3529248f3d4bd0b63499a092f2c3" "974edbc79de4f730edf8c9d01bc9186f97417f1d" "bfef75f3a17da232f402e1799b42c25c2b1c5176" "97e469cc4f8188a48d03ef4a70b5efcff11b29c1" "20540235deec2fd668c673d3410390c6017aba39" "e34281f0a78b627973a188179a5dca57617c415b" "e6361325170987f0141035b187f1342ea7097b7d" "5226a0d94598a26f74192aab6aad0abdae2bb9cd")
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

LIB_DEPEND="sys-apps/pciutils[static-libs(+)]"
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
