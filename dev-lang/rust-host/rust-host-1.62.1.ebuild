# Copyright 2022 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

# shellcheck disable=SC2034 # Used by cros-rustc.eclass
RUSTC_TARGET_TRIPLES=(
	x86_64-pc-linux-gnu
)
# shellcheck disable=SC2034 # Used by cros-rustc.eclass
RUSTC_BARE_TARGET_TRIPLES=()

# shellcheck disable=SC2034
PYTHON_COMPAT=( python3_{6..9} )
inherit cros-rustc

KEYWORDS="*"

BDEPEND="sys-devel/llvm"
# dev-lang/rust-1.59.0 introduced the split between dev-lang/rust and
# dev-lang/rust-host; note that here to work around file collisions.
RDEPEND="!<dev-lang/rust-1.59.0"

src_install() {
	# shellcheck disable=SC2154 # defined in cros-rustc.eclass
	local obj="${CROS_RUSTC_BUILD_DIR}/x86_64-unknown-linux-gnu/stage2"
	local tools="${obj}-tools/x86_64-unknown-linux-gnu/release/"
	dobin "${obj}/bin/rustc" "${obj}/bin/rustdoc"
	dobin "${tools}/cargo"
	if ! use rust_profile_frontend_generate && ! use rust_profile_llvm_generate; then
		# These won't be built for an instrumented build.
		dobin "${tools}/rustfmt" "${tools}/cargo-fmt"
		dobin "${tools}/clippy-driver" "${tools}/cargo-clippy"
	fi
	dobin src/etc/rust-gdb src/etc/rust-lldb
	insinto "/usr/$(get_libdir)"
	doins -r "${obj}/lib/"*
	doins -r "${obj}/lib64/"*

	insinto "/usr/lib/rustlib/src/rust/"
	doins -r "${S}/library"

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
