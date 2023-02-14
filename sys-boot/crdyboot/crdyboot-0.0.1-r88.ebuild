# Copyright 2022 The ChromiumOS Authors
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

EAPI=7

CROS_WORKON_COMMIT=("6fde75e1f4905d2f974a0f5b86cd04b01015c4a1" "83feacdcc05c1e2ebd56a20ccea008be49144aee")
CROS_WORKON_TREE=("eaed876dbc3e18c117b741f618bd2d6e01d1fcdd" "1bcdb0c3b544bc90d1f7d1bfc29fc67a34691cd0")
CROS_WORKON_PROJECT=("chromiumos/platform/crdyboot" "chromiumos/platform/vboot_reference")
CROS_WORKON_LOCALNAME=("../platform/crdyboot" "../platform/vboot_reference")
CROS_WORKON_DESTDIR=("${S}" "${S}/third_party/vboot_reference")

inherit cros-workon cros-rust

DESCRIPTION="Experimental UEFI bootloader for ChromeOS Flex"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"

DEPEND="dev-rust/third-party-crates-src:="
RDEPEND="${DEPEND}"

# TODO(b/253251805): disable tests, they don't yet work in the chroot build.
RESTRICT="test"

# Clear the subdir so that we stay in the root of the repo.
CROS_RUST_SUBDIR=""

UEFI_TARGET_I686="i686-unknown-uefi"
UEFI_TARGET_X64_64="x86_64-unknown-uefi"
UEFI_TARGETS=(
	"${UEFI_TARGET_I686}"
	"${UEFI_TARGET_X64_64}"
)

src_prepare() {
	# Drop some packages that are not needed.
	sed -i 's/, "enroller"//' "${S}/Cargo.toml" || die
	sed -i 's/, "xtask"//' "${S}/Cargo.toml" || die

	# Drop dev-dependencies (CROS_RUST_REMOVE_DEV_DEPS doesn't work
	# for packages in a workspace).
	sed -i 's/^regex.*$//' "${S}/vboot/Cargo.toml" || die
	sed -i 's/^simple_logger.*$//' "${S}/vboot/Cargo.toml" || die

	default
}

src_compile() {
	local key_section=".vbpubk"
	local key_path="${S}/third_party/vboot_reference/tests/devkeys/kernel_subkey.vbpubk"

	# Set the appropriate linker for UEFI targets.
	export RUSTFLAGS+=" -C linker=lld-link"

	# We need to pass in a `--target` to the C compiler, but the
	# compiler-wrapper for the board's CC appends the board target
	# at the end, overriding that setting. Use
	# `x86_64-pc-linux-gnu-clang` instead, as the host wrapper
	# happens to not suffix a target. See
	# `compiler_wrapper/clang_flags.go` at the end of
	# `processClangFlags`.
	export CC="x86_64-pc-linux-gnu-clang"

	for uefi_target in "${UEFI_TARGETS[@]}"; do
		if [[ "${uefi_target}" == "${UEFI_TARGET_I686}" ]]; then
			# TODO(b/250047389): With safeseh enabled, we
			# get errors like this for some objects from
			# compiler-builtins:
			#
			#     lld-link: error: /safeseh: udivdi3.o is not
			#     compatible with SEH
			#
			# Looks similar to
			# https://github.com/rust-lang/rust/pull/96523,
			# will hopefully be fixed with the next rustc
			# upgrade.
			export RUSTFLAGS+=" -C link-arg=/SAFESEH:NO"
		fi

		ecargo build \
			--offline \
			--release \
			--target="${uefi_target}" \
			--package crdyboot

		# CARGO_TARGET_DIR is defined in an eclass
		# shellcheck disable=SC2154
		local exe_path="${CARGO_TARGET_DIR}/${uefi_target}/release/crdyboot.efi"

		# Add the vboot test kernel subkey to a `.vbpubk`
		# section of the PE executable. This allows the
		# bootloader to work on unsigned builds. For signed
		# builds, the signer will throw this section out and put
		# in a different public key.
		llvm-objcopy \
			--add-section "${key_section}=${key_path}" \
			--set-section-flags "${key_section}=data,readonly" \
			"${exe_path}" \
			"${exe_path}.with_pubkey"
	done
}

# Get the standard suffix for a UEFI boot executable.
uefi_arch_suffix() {
	local uefi_target="$1"
	if [[ "${uefi_target}" == "${UEFI_TARGET_I686}" ]]; then
		echo "ia32.efi"
	elif [[ "${uefi_target}" == "${UEFI_TARGET_X64_64}" ]]; then
		echo "x64.efi"
	else
		die "unknown arch: ${uefi_target}"
	fi
}

src_install() {
	insinto /boot/efi/boot
	for uefi_target in "${UEFI_TARGETS[@]}"; do
		# CARGO_TARGET_DIR is defined in an eclass
		# shellcheck disable=SC2154
		newins "${CARGO_TARGET_DIR}/${uefi_target}/release/crdyboot.efi.with_pubkey" \
			"crdyboot$(uefi_arch_suffix "${uefi_target}")"
	done
}
