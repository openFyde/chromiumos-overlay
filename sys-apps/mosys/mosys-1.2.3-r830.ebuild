# Copyright (c) 2012 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

CROS_WORKON_COMMIT="70b8fae91316e742cc928c3d1f60b075bdeb7d39"
CROS_WORKON_TREE="91f57b6aa7d3470355a6826024b6e28e2fc83484"
CROS_WORKON_PROJECT="chromiumos/platform/mosys"
CROS_WORKON_LOCALNAME="../platform/mosys"
CROS_WORKON_INCREMENTAL_BUILD=1

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

inherit cargo flag-o-matic meson toolchain-funcs cros-unibuild cros-workon

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
	sys-apps/util-linux
	>=sys-apps/flashmap-0.3-r4
	chromeos-base/minijail"
DEPEND="${RDEPEND}"

src_unpack() {
	cargo_src_unpack
	cros-workon_src_unpack
}

src_configure() {
	if use unibuild; then
		cp "${SYSROOT}${UNIBOARD_DTB_INSTALL_PATH}" \
			lib/cros_config/config.dtb
		cp "${SYSROOT}${UNIBOARD_C_CONFIG}" \
			lib/cros_config/cros_config_data.c
	fi

	local emesonargs=(
		$(meson_use unibuild use_cros_config)
		-Darch=$(tc-arch)
	)
	meson_src_configure
}

src_compile() {
	meson_src_compile
	MESON_BUILD_ROOT="${BUILD_DIR}" cargo_src_compile
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
