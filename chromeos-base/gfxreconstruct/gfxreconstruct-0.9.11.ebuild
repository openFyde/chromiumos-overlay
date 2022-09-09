# Copyright 2022 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-utils flag-o-matic unpacker

DESCRIPTION="Vulkan API Capture and Replay Tools"
HOMEPAGE="https://github.com/LunarG/gfxreconstruct"
GIT_HASH="761837794a1e57f918a85af7000b12e531b178ae"
SRC_URI="https://github.com/LunarG/gfxreconstruct/archive/${GIT_HASH}.tar.gz -> gfxreconstruct-${GIT_HASH}.tar.gz"

LICENSE="MIT"
KEYWORDS="*"
IUSE=""
SLOT="0"

S="${WORKDIR}/gfxreconstruct-${GIT_HASH}"

DEPEND="x11-libs/libxcb
	sys-libs/zlib
	app-arch/zstd"
RDEPEND="${DEPEND}"
BDEPEND="
	x11-libs/xcb-util-keysyms
	dev-util/vulkan-headers"

PATCHES=(
	# Look for Vulkan headers in the right place during build.
	"${FILESDIR}/gfxreconstruct-0.9.11-0000-headers.patch"
	# Update generated code for ChromeOS.
	"${FILESDIR}/gfxreconstruct-0.9.11-0001-generated.patch"
	# Fix library path in layer manifest.
	"${FILESDIR}/gfxreconstruct-0.9.11-0002-layer_config.patch"
)

src_prepare() {
	cmake-utils_src_prepare
}

src_configure() {
	cros_enable_cxx_exceptions
	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile
}

src_install() {
	local OUTDIR="${WORKDIR}/gfxreconstruct-0.9.11_build"
	local TOOLSDIR="${OUTDIR}/tools"

	dobin "${TOOLSDIR}/replay/gfxrecon-replay"
	dobin "${TOOLSDIR}/compress/gfxrecon-compress"
	dobin "${TOOLSDIR}/optimize/gfxrecon-optimize"
	dobin "${TOOLSDIR}/replay/gfxrecon-replay"
	dobin "${TOOLSDIR}/capture/gfxrecon-capture.py"
	dobin "${TOOLSDIR}/toascii/gfxrecon-toascii"
	dobin "${TOOLSDIR}/extract/gfxrecon-extract"
	dobin "${TOOLSDIR}/info/gfxrecon-info"

	dolib.so "${OUTDIR}/layer/libVkLayer_gfxreconstruct.so"
	insinto /usr/share/vulkan/explicit_layer.d
	doins "${OUTDIR}/layer/VkLayer_gfxreconstruct.json"
}
