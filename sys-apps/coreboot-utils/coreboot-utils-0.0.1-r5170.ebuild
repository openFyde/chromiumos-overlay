# Copyright 2012 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2
# $Header:

EAPI=7
CROS_WORKON_COMMIT=("1a1d88371ab8f3b1aa5cf9489add583687ce6e8f" "9f2e9804b492f8fccc060e013b12de9679cca246")
CROS_WORKON_TREE=("426b2d8a66b9ccafa56fb8c880acd476fa6387e3" "b1b986f3ef93d4badd4547c975f80eabea8410c1" "2b70eb504ee3fbf21a36a69815634015c40eebb7" "7970bef34ce4d0b3023def52ff72e1c4cd2eca85" "0c986b73d37f2445d8da22b36d806464e83ab756" "a86b8ff2cf661d5116ce652e60ff6f334bdb2d14" "6d66611ca07b7767233ac20fbcd1faf00eadf744" "e0beed145404b5826408b12c07d14e8efc5e7aa9" "e03866d9ecdf3529248f3d4bd0b63499a092f2c3" "052584a30fcbe73624a942716f00e76fc4724675" "4fdac046899ad0163ad701dbf5ce8f3e3c38269b" "4ed8981d8c6c6299c4241247bfb3849189ea7404" "5e239dd9f94cd819b03e4b0413398c0b299818d3" "27d651612d6d6c19f9c9e64852bd998fbd847677" "fe7470f5576e33abc47bff7e2ab529231caff837" "e6ce0f3719e387db2d9147613f23bb7607a3157c" "508f728905770fe9699007600eecbda3826d5219")
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
		if use cros_host; then
			_emake -C util/ifdtool
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
		if use cros_host; then
			dobin util/ifdtool/ifdtool
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
