# Copyright 2012 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2
# $Header:

EAPI=7
CROS_WORKON_COMMIT=("c4e051828d7ea0752eb0745cde1e2730f7618797" "1a1cb5c9a38030a5868e2aaad295c68432c680fd")
CROS_WORKON_TREE=("a65b4a3ac4f4e5b059a64fa28ada57452ef96286" "e6e7f98e0f1f165524857f74120fab7c280250d0" "c0a1d1e484e4a25741fdd2ce2d06b4f12a3c21dc" "3c4c2d1f78d70547ae755c56c69f969581b0b975" "ae7da96d4343e5f8199f604780a7da40257898a8" "f0f4a71ce17b6f8ae1e9f4349e7cf0e03082f46a" "0bb755712e7ba4591db8a6138a06792462a22ef4" "c2edc331b66801833a5f9cccea985cc837ad8301" "e03866d9ecdf3529248f3d4bd0b63499a092f2c3" "052584a30fcbe73624a942716f00e76fc4724675" "dbfe90ed7e6f0449bda3f72e8cb9b4cf733b03bb" "56f321efe3984186bddf7be090a2e8adeb7f137b" "0f58909f25c794b875ce0f25305d810f23c2fa75" "dd623a4fd802313ae3e9f4c93d85f5b9fe5fdee2" "ce490a4fd334d021619dc887c2e267ef09b9a3c7" "03753629e39e296a91d180437c8638425e43c7fd" "8353ee8b3e9c3907f6f08afcfba439461d276bba")
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
