# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

# This is the list of target triples as they appear in the cros_sdk. If this
# list gets changed, ensure that each of these values has a corresponding
# compiler/rustc_target/src/spec file created below and a line referring to it
# in 0001-add-cros-targets.patch.
# shellcheck disable=SC2034 # Used by cros-rustc.eclass
RUSTC_TARGET_TRIPLES=(
	x86_64-cros-linux-gnu
	armv7a-cros-linux-gnueabihf
	aarch64-cros-linux-gnu
)

# In this context BARE means the OS part of the triple is none and gcc is used
# for C/C++ and linking.
# shellcheck disable=SC2034 # Used by cros-rustc.eclass
RUSTC_BARE_TARGET_TRIPLES=(
	thumbv6m-none-eabi # Cortex-M0, M0+, M1
	thumbv7m-none-eabi # Cortex-M3
	thumbv7em-none-eabihf # Cortex-M4F, M7F, FPU, hardfloat
)

# shellcheck disable=SC2034
PYTHON_COMPAT=( python3_{6..9} )

inherit cros-rustc

# Use PVR to require simultaneous uprevs of both rust-host and rust, since
# they're logically talking about the same sources.
BDEPEND="=dev-lang/rust-host-${PVR}"
RDEPEND="=dev-lang/rust-host-${PVR}"
KEYWORDS="*"

# NOTE: since CROS_RUSTC_BUILD_DIR is a local cache, the cases below can't
# always presume that it exists.

src_unpack() {
	if cros-rustc_has_existing_checkout; then
		einfo "Skipping unpack; checkout already exists"
	else
		ewarn "No existing cros-rustc checkout found. Did you" \
			"remember to emerge dev-lang/rust-host?"
		cros-rustc_src_unpack
	fi
}

src_prepare() {
	if cros-rustc_has_existing_checkout; then
		einfo "Skipping src_prepare; checkout already exists"
		# `src_prepare` requires this to be called before exiting. The
		# actual use of user patches with this ebuild is not supported.
		eapply_user
	else
		cros-rustc_src_prepare
	fi
}

src_compile() {
	local keep_stages=()
	if cros-rustc_has_existing_stage1_build; then
		einfo "Stage1 build exists; instructing x.py to use it"
		keep_stages=("--keep-stage=0" "--keep-stage=1")
	fi
	cros-rustc_src_compile "${keep_stages[@]}" library/std
}

src_install() {
	# shellcheck disable=SC2154 # Defined in cros-rustc.eclass
	local obj="${CROS_RUSTC_BUILD_DIR}/x86_64-unknown-linux-gnu/stage2"
	for triple in "${RUSTC_TARGET_TRIPLES[@]}" "${RUSTC_BARE_TARGET_TRIPLES[@]}"; do
		insinto "/usr/$(get_libdir)/rustlib/${triple}"
		doins -r "${obj}/lib64/rustlib/${triple}/"*
	done
}
