# Copyright 2022 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6..9} )

inherit cros-constants python-any-r1

DESCRIPTION="Compilers for building HPS firmware"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform/hps-firmware"
LICENSE="|| ( MIT Apache-2.0 ) BSD-1 BSD-2 BSD-4 UoI-NCSA"
KEYWORDS="*"
SLOT="0"

RUST_VERSION="1.58.1"
RUST_BOOTSTRAP_VERSION="1.57.0"
RUST_BOOTSTRAP_HOST_TRIPLE="x86_64-unknown-linux-gnu"

SRC_URI="
	https://static.rust-lang.org/dist/rustc-${RUST_VERSION}-src.tar.gz
	https://static.rust-lang.org/dist/rustc-${RUST_BOOTSTRAP_VERSION}-${RUST_BOOTSTRAP_HOST_TRIPLE}.tar.xz
	https://static.rust-lang.org/dist/rust-std-${RUST_BOOTSTRAP_VERSION}-${RUST_BOOTSTRAP_HOST_TRIPLE}.tar.xz
	https://static.rust-lang.org/dist/cargo-${RUST_BOOTSTRAP_VERSION}-${RUST_BOOTSTRAP_HOST_TRIPLE}.tar.xz
"

S="${WORKDIR}"

pkg_setup() {
	python-any-r1_pkg_setup
}

src_unpack() {
	default

	# Copy bootstrap std to where bootstrap rustc will find it
	local rust_std_dir="${WORKDIR}/rust-std-${RUST_BOOTSTRAP_VERSION}-${RUST_BOOTSTRAP_HOST_TRIPLE}/rust-std-${RUST_BOOTSTRAP_HOST_TRIPLE}"
	local rustc_dir="${WORKDIR}/rustc-${RUST_BOOTSTRAP_VERSION}-${RUST_BOOTSTRAP_HOST_TRIPLE}/rustc"
	cp -a \
		"${rust_std_dir}/lib/rustlib/${RUST_BOOTSTRAP_HOST_TRIPLE}" \
		"${rustc_dir}/lib/rustlib/" \
		|| die
}

src_prepare() {
	default

	cd "${WORKDIR}/rustc-${RUST_VERSION}-src" || die

	# Copy "unknown" vendor targets to create cros_sdk target triple
	# variants as referred to in 0001-add-cros-targets.patch and RUSTC_TARGET_TRIPLES.
	# armv7a is treated specially because the cros toolchain differs in
	# more than just the vendor part of the target triple. The arch is
	# armv7a in cros versus armv7.
	pushd compiler/rustc_target/src/spec || die
	sed -e 's:"unknown":"pc":g' x86_64_unknown_linux_gnu.rs >x86_64_pc_linux_gnu.rs || die
	sed -e 's:"unknown":"cros":g' x86_64_unknown_linux_gnu.rs >x86_64_cros_linux_gnu.rs || die
	sed -e 's:"unknown":"cros":g' armv7_unknown_linux_gnueabihf.rs >armv7a_cros_linux_gnueabihf.rs || die
	sed -e 's:"unknown":"cros":g' aarch64_unknown_linux_gnu.rs >aarch64_cros_linux_gnu.rs || die
	popd || die

	eapply "${FILESDIR}/rust-1.58.1-add-cros-targets.patch"
	eapply "${FILESDIR}/rust-1.58.1-fix-rpath.patch"
	eapply "${FILESDIR}/rust-1.58.1-Revert-CMake-Unconditionally-add-.h-and-.td-files-to.patch"
	eapply "${FILESDIR}/rust-1.58.1-no-test-on-build.patch"
	eapply "${FILESDIR}/rust-1.58.1-sanitizer-supported.patch"
	eapply "${FILESDIR}/rust-1.58.1-cc.patch"
	eapply "${FILESDIR}/rust-1.58.1-revert-libunwind-build.patch"
	eapply "${FILESDIR}/rust-1.58.1-ld-argv0.patch"
	eapply "${FILESDIR}/rust-1.58.1-Handle-sparse-git-repo-without-erroring.patch"
	eapply "${FILESDIR}/rust-1.58.1-disable-mutable-noalias.patch"
	eapply "${FILESDIR}/rust-1.58.1-add-armv7a-sanitizers.patch"
	eapply "${FILESDIR}/rust-1.58.1-fix-libunwind-backtrace-visibility.patch"

	# For the rustc_llvm module, the build will link with -nodefaultlibs and manually choose the
	# std C++ library. For x86_64 Linux, the build script always chooses libstdc++ which will not
	# work if LLVM was built with USE="default-libcxx". This snippet changes that choice to libc++
	# in the case that clang++ defaults to libc++.
	if "${CXX}" -### -x c++ - < /dev/null 2>&1 | grep -q -e '-lc++'; then
		sed -i 's:"stdc++":"c++":g' compiler/rustc_llvm/build.rs || die
	fi
}

src_configure() {
	cd "${WORKDIR}/rustc-${RUST_VERSION}-src" || die
	cat >config.toml <<EOF
[build]
target = [
	"x86_64-unknown-linux-gnu",
	"aarch64-cros-linux-gnu",
	"armv7a-cros-linux-gnueabihf",
	"x86_64-cros-linux-gnu",
	"thumbv6m-none-eabi",
	"riscv32i-unknown-none-elf",
]
cargo = "${WORKDIR}/cargo-${RUST_BOOTSTRAP_VERSION}-${RUST_BOOTSTRAP_HOST_TRIPLE}/cargo/bin/cargo"
rustc = "${WORKDIR}/rustc-${RUST_BOOTSTRAP_VERSION}-${RUST_BOOTSTRAP_HOST_TRIPLE}/rustc/bin/rustc"
docs = false
submodules = false
python = "${EPYTHON}"
vendor = true
extended = false
tools = ["cargo"]
sanitizers = false
profiler = false

[llvm]
ninja = true
targets = "AArch64;ARM;RISCV;X86"
experimental-targets = ""

[install]
prefix = "${D}/opt/hps-sdk"
mandir = "share/man"

[rust]
description = "${PF}"
channel = "nightly"
codegen-units = 0
llvm-libunwind = 'in-tree'
codegen-tests = false
new-symbol-mangling = true
lld = false
use-lld = false
default-linker = "${CBUILD}-clang"

[target.x86_64-unknown-linux-gnu]
cc = "${CBUILD}-clang"
cxx = "${CBUILD}-clang++"
linker = "${CBUILD}-clang++"

[target.aarch64-cros-linux-gnu]
cc = "aarch64-cros-linux-gnu-clang"
cxx = "aarch64-cros-linux-gnu-clang++"
linker = "aarch64-cros-linux-gnu-clang++"

[target.armv7a-cros-linux-gnueabihf]
cc = "armv7a-cros-linux-gnueabihf-clang"
cxx = "armv7a-cros-linux-gnueabihf-clang++"
linker = "armv7a-cros-linux-gnueabihf-clang++"

[target.x86_64-cros-linux-gnu]
cc = "x86_64-cros-linux-gnu-clang"
cxx = "x86_64-cros-linux-gnu-clang++"
linker = "x86_64-cros-linux-gnu-clang++"

[target.thumbv6m-none-eabi]
cc = "armv7m-cros-eabi-clang"
cxx = "armv7m-cros-eabi-clang++"
linker = "armv7m-cros-eabi-clang++"

[target.riscv32i-unknown-none-elf]
cc = "clang"
cxx = "clang++"
linker = "ld.lld"
EOF
}

src_compile() {
	cd "${WORKDIR}/rustc-${RUST_VERSION}-src" || die
	${EPYTHON} x.py build --stage 2 || die
}

src_install() {
	cd "${WORKDIR}/rustc-${RUST_VERSION}-src" || die
	${EPYTHON} x.py install || die
}
