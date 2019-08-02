# Copyright (c) 2012 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

CROS_WORKON_COMMIT=("5b1765248ae9b966f40e36ee33f7e926c8028f9d" "bc18210520dc043aa634fe8be2f374741a466cb2")
CROS_WORKON_TREE=("8e516de8961c22228293b5d8bc6c23905f116abd" "9b800a65cc6f50ab66815ae92ceaf63cd920212c")
CROS_WORKON_PROJECT=(
	"chromiumos/platform2"
	"chromiumos/platform/mosys"
)
CROS_WORKON_LOCALNAME=(
	"../platform2"
	"../platform/mosys"
)
CROS_WORKON_DESTDIR=(
	"${S}/platform2"
	"${S}/platform/mosys"
)
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_SUBTREE=(
	"common-mk"
	""
)

MESON_AUTO_DEPEND=no

CRATES="
aho-corasick-0.6.3
ansi_term-0.9.0
atty-0.2.3
bindgen-0.31.3
bitflags-0.9.1
cexpr-0.2.2
cfg-if-0.1.2
clang-sys-0.21.1
clap-2.27.1
env_logger-0.4.3
getopts-0.2.15
glob-0.2.11
kernel32-sys-0.2.2
lazy_static-0.2.11
lazy_static-1.0.0
libc-0.2.33
libloading-0.4.2
log-0.3.8
memchr-1.0.2
nom-3.2.1
peeking_take_while-0.1.2
quote-0.3.15
redox_syscall-0.1.31
redox_termios-0.1.1
regex-0.2.2
regex-syntax-0.4.1
strsim-0.6.0
termion-1.5.1
textwrap-0.9.0
thread_local-0.3.4
unicode-width-0.1.4
unreachable-1.0.0
utf8-ranges-1.0.0
vec_map-0.8.0
void-1.0.2
which-1.0.3
winapi-0.2.8
winapi-build-0.1.1
"

inherit cargo flag-o-matic meson toolchain-funcs cros-unibuild cros-workon platform

DESCRIPTION="Utility for obtaining various bits of low-level system info"
HOMEPAGE="http://mosys.googlecode.com/"

SRC_URI="$(cargo_crate_uris ${CRATES})"

LICENSE="BSD-Google BSD Apache-2.0 MIT ISC Unlicense"
SLOT="0"
KEYWORDS="*"
IUSE="unibuild"

# We need util-linux for libuuid.
RDEPEND="unibuild? (
		chromeos-base/chromeos-config
		sys-apps/dtc
	)
	dev-util/cmocka
	sys-apps/util-linux
	>=sys-apps/flashmap-0.3-r4
	chromeos-base/minijail"
DEPEND="${RDEPEND}"

src_unpack() {
	cargo_src_unpack
	cros-workon_src_unpack
	PLATFORM_TOOLDIR="${S}/platform2/common-mk"
	S+="/platform/mosys"
}

src_configure() {
	local emesonargs=(
		$(meson_use unibuild use_cros_config)
		-Darch=$(tc-arch)
	)

	if use unibuild; then
		emesonargs+=(
			"-Dcros_config_data_src=${SYSROOT}${UNIBOARD_C_CONFIG}"
		)
	fi

	meson_src_configure
}

src_compile() {
	meson_src_compile
	cd ${S}/platform/mosys
	MESON_BUILD_ROOT="${BUILD_DIR}" cargo_src_compile
}

platform_pkg_test() {
	local tests=(
		file_unittest
		io_unittest
		math_unittest
	)
	local test_bin
	for test_bin in "${tests[@]}"; do
		platform_test "run" \
			"${BUILD_DIR}/unittests/${test_bin}"
	done
}

src_install() {
	# cargo doesn't know how to install cross-compiled binaries. Manually
	# install mosys instead.
	local build_dir="${WORKDIR}/${CHOST}/$(usex debug debug release)"
	dosbin "${build_dir}/mosys"

	insinto /usr/share/policy
	newins "seccomp/mosys-seccomp-${ARCH}.policy" mosys-seccomp.policy
	dodoc README TODO
}
