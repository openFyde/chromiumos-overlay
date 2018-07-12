# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=6
CROS_WORKON_COMMIT="cc47dd3002ca560051a8c4786ad18a8cf9ee9dcb"
CROS_WORKON_TREE="5a5a059df3a32505fe37a3124321aa9f09e6aa33"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_SUBTREE="metrics/memd"
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_OUTOFTREE_BUILD=1

CRATES="
atty-0.2.10
backtrace-0.3.7
backtrace-sys-0.1.16
cc-1.0.15
cfg-if-0.1.3
chrono-0.4.2
dbus-0.6.1
env_logger-0.5.10
error-chain-0.11.0
humantime-1.1.1
libc-0.2.40
libdbus-sys-0.1.3
log-0.4.1
num-integer-0.1.38
num-traits-0.2.4
pkg-config-0.3.11
quick-error-1.2.1
redox_syscall-0.1.37
redox_termios-0.1.1
rustc-demangle-0.1.8
syslog-4.0.0
termcolor-0.3.6
termion-1.5.1
time-0.1.40
unix_socket-0.5.0
winapi-0.3.4
winapi-i686-pc-windows-gnu-0.4.0
winapi-x86_64-pc-windows-gnu-0.4.0
wincolor-0.1.6
"

inherit cargo cros-workon toolchain-funcs

DESCRIPTION="Fine-grain memory metrics collector"

SRC_URI="$(cargo_crate_uris ${CRATES})"

LICENSE="BSD-Google BSD-2 Apache-2.0 MIT"
SLOT="0"
KEYWORDS="*"
IUSE="+seccomp"

# If crates are missing, Uncomment the RESTRICT setting below, then run
#     ebuild-<board> $(equery-<board> w memd) manifest
# to download the needed crates into
# /var/lib/portage/distfiles-target/*.crate
# Then these can be uploaded to chromeos-localmirror.
#
# RESTRICT="mirror"

src_unpack() {
	# Unpack both the project and dependency source code.
	# (No idea what this means, I am just copy-pasting.)
	cargo_src_unpack
	cros-workon_src_unpack
	# The compilation happens in the memd subdirectory.
	S+="/metrics/memd"
}

src_compile() {
	export CARGO_HOME="${ECARGO_HOME}"
	export CARGO_TARGET_DIR="${WORKDIR}"
	export PKG_CONFIG_ALLOW_CROSS=1
	cargo build -v --target="${CHOST}" --release || \
		die "cargo build failed"
}

src_test() {
	export CARGO_HOME="${ECARGO_HOME}"
	export CARGO_TARGET_DIR="${WORKDIR}"
	if ! use x86 && ! use amd64 ; then
		elog "Skipping unit tests on non-x86 platform"
	else
		RUST_BACKTRACE=1 cargo test || die "memd test failed"
	fi
}

src_install() {
	# cargo doesn't know how to install cross-compiled binaries.  It will
	# always install native binaries for the host system.  Install manually
	# instead.
	local build_dir="${WORKDIR}/${CHOST}/release"
	dobin "${build_dir}/memd"
	insinto /etc/init
	doins init/memd.conf
	insinto /usr/share/policy
	use seccomp && \
		newins "init/memd-seccomp-${ARCH}.policy" memd-seccomp.policy
}
