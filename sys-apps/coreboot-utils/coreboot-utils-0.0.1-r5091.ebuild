# Copyright 2012 The Chromium OS Authors
# Distributed under the terms of the GNU General Public License v2
# $Header:

EAPI=7
CROS_WORKON_COMMIT=("5a0dd0be8c656d24f238c577913ec862d6d5f142" "d2072ef664acf5486a664a8652e6d6f3dd9bf6fe")
CROS_WORKON_TREE=("428c5357354ddf1514dd7b46da3edd4f92aeb86f" "f7bf28e900b3bb18a1e830b20aed07a427530a54" "06b3f5b5095a35bf3243b46bbba5a377562efc90" "7970bef34ce4d0b3023def52ff72e1c4cd2eca85" "0c986b73d37f2445d8da22b36d806464e83ab756" "4f8fc92aae4ce21cd4a8dac4fe3528a0d74eda3f" "45de8426c079972ea36c886fd298076a412a1500" "664c26175ad2098e1e83670ab5c33fa35c545f90" "e03866d9ecdf3529248f3d4bd0b63499a092f2c3" "f3c22316f6e3e35126771d48960a48f474be6748" "4fdac046899ad0163ad701dbf5ce8f3e3c38269b" "beaffafa824a743d09519401b35673f6818d19ec" "27d651612d6d6c19f9c9e64852bd998fbd847677" "a81c7986124e929d610bb5622fb1e2b570415335" "f3ffd869209f1a79458bcf14b3eae48e9a1f3fb1" "e270d67179cf3cb47b071d30f0d23364d7098190")
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
