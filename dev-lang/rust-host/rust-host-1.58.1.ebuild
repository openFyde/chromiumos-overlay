# Copyright 2022 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

RUSTC_TARGET_TRIPLES=(
	x86_64-pc-linux-gnu
)
RUSTC_BARE_TARGET_TRIPLES=()

inherit cros-rustc

DESCRIPTION="The parts of our Rust toolchain necessary to build host binaries"

KEYWORDS="*"

# dev-lang/rust-1.58.1-r1 introduced the split between dev-lang/rust and
# dev-lang/rust-host; note that here to work around file collisions.
RDEPEND="!<dev-lang/rust-1.58.1-r1"

src_install() {
	local obj="${CROS_RUSTC_BUILD_DIR}/x86_64-unknown-linux-gnu/stage2"
	local tools="${obj}-tools/x86_64-unknown-linux-gnu/release/"
	dobin "${obj}/bin/rustc" "${obj}/bin/rustdoc"
	dobin "${tools}/cargo"
	dobin "${tools}/rustfmt" "${tools}/cargo-fmt"
	dobin "${tools}/clippy-driver" "${tools}/cargo-clippy"
	dobin src/etc/rust-gdb src/etc/rust-lldb
	insinto "/usr/$(get_libdir)"
	doins -r "${obj}/lib/"*
	doins -r "${obj}/lib64/"*

	# Install miscellaneous LLVM tools.
	#
	# These tools are already provided in the SDK, but they're built with
	# the version of LLVM built by sys-devel/llvm. Rust uses an independent
	# version of LLVM, so the use of these tools is sometimes necessary to
	# produce artifacts that work with `rustc` and such.
	#
	# Our long-term plan is to have Rust using the same version of LLVM as
	# sys-devel/llvm. When that happens, all of the below will be removed, with
	# the expectation that users will migrate to the LLVM tools on `$PATH`.
	local llvm_tools="${CROS_RUSTC_BUILD_DIR}/x86_64-unknown-linux-gnu/llvm/bin"
	exeinto "/usr/libexec/rust"
	doexe "${llvm_tools}/llvm-profdata"
}
