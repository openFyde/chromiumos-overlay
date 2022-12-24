# Copyright 2012 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2
# $Header:

EAPI=7
CROS_WORKON_COMMIT=("31cf2ef4b1012ee960445b4bdabd2870b80aced4" "c4102fe4eef8c0539c03d60c7256fd4bc599bf4a")
CROS_WORKON_TREE=("a65b4a3ac4f4e5b059a64fa28ada57452ef96286" "6619f8ce0bd77545c24221d756bacd363165254d" "2aa87a43a574054294f28e481d22a10482fd430c" "3c4c2d1f78d70547ae755c56c69f969581b0b975" "2c5a74064c2467e570c5975109ef1ee9440c0ef1" "f0f4a71ce17b6f8ae1e9f4349e7cf0e03082f46a" "8aba685cbfbc96068fcf770b30780eee8246faae" "1e1d60e2da6f20cd9bef95d0667113fdb74f1e48" "e03866d9ecdf3529248f3d4bd0b63499a092f2c3" "052584a30fcbe73624a942716f00e76fc4724675" "dbfe90ed7e6f0449bda3f72e8cb9b4cf733b03bb" "06476ece66ad56d2e3d24d15b672c875f25bba2e" "295b680fb030671cd74d1b655ac64ad0d4453c48" "dd623a4fd802313ae3e9f4c93d85f5b9fe5fdee2" "7a6ff55240ce56c142574600854c67c885e212a4" "60173f048e95b3b61845e465a3d7fd95bb2995f3" "3ccc864d04c1a49b0736efbbc9d01b670aa10562")
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
	"src/arch/x86/include/arch src/commonlib src/vendorcode/intel util/archive util/cbmem util/cbfstool util/ifdtool util/inteltool util/mma util/nvramtool util/superiotool util/amdfwtool"
	"Makefile cgpt host firmware futility"
)

inherit cros-workon toolchain-funcs cros-sanitizers

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
	sanitizers-setup-env
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
		_emake -C util/ifdtool
		if use cros_host; then
			_emake -C util/amdfwtool
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
		dobin util/ifdtool/ifdtool
		if use cros_host; then
			dobin util/amdfwtool/amdfwread
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
