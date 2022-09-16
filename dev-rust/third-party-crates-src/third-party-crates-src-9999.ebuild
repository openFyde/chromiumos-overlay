# Copyright 2022 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_PROJECT="chromiumos/third_party/rust_crates"
CROS_WORKON_EGIT_BRANCH="main"
CROS_WORKON_LOCALNAME="rust_crates"
CROS_WORKON_OUTOFTREE_BUILD=1

PYTHON_COMPAT=( python3_{6..9} )

inherit cros-workon cros-rust python-single-r1

DESCRIPTION="Sources of third-party crates used by ChromeOS"
HOMEPAGE='https://chromium.googlesource.com/chromiumos/third_party/rust_crates/+/HEAD/'
KEYWORDS="~*"

# There's no obvious need for testing these crates at the moment. Further,
# testing these crates could be complicated, since we're pulling in the union of
# all crates needed for all CrOS projects on all architectures. Future Work(TM).
RESTRICT="test"

EXPECTED_LICENSES=(
	0BSD
	Apache-2.0
	BSD
	ISC
	MIT
	MPL-2.0
	ZLIB
)

LICENSE="${EXPECTED_LICENSES[*]}"

# A list of crate versions which we've fully replaced.
# FIXME(b/240953811): Remove this when our migration is done.
RDEPEND="
	!=dev-rust/memchr-2.4.0
	!=dev-rust/regex-1.5.4
	!=dev-rust/termcolor-1.1.2
"

# A list of crate versions available in rust_crates, which we can install in
# dev-rust. Logically, this is "all crates, minus those in a blocklist," but we
# have to have this info in `pkg_*` functions, so inspecting `rust_crates`
# sources and our blocklist isn't possible.
#
# FIXME(b/240953811): Remove this when our migration is done.
ALLOWED_CRATE_VERSIONS=(
	# NOTE: This list was generated by
	# ${FILESDIR}/write_allowlisted_crate_versions.py. Any
	# modifications may be overwritten.
	"android_system_properties-0.1.5"
	"bitvec-0.19.5"
	"bytemuck-1.12.1"
	"clipboard-win-4.2.1"
	"com_logger-0.1.1"
	"configparser-3.0.0"
	"core-foundation-sys-0.8.3"
	"cxx-1.0.42"
	"cxxbridge-flags-1.0.42"
	"cxxbridge-macro-1.0.42"
	"derive-into-owned-0.1.0"
	"encode_unicode-0.3.6"
	"errno-0.2.8"
	"errno-dragonfly-0.1.2"
	"error-code-2.3.0"
	"euclid-0.22.7"
	"failure-0.1.8"
	"funty-1.1.0"
	"grpcio-compiler-0.6.0"
	"iana-time-zone-0.1.47"
	"inotify-0.9.3"
	"inotify-sys-0.1.5"
	"io-lifetimes-0.7.3"
	"io-uring-0.5.4"
	"js-sys-0.3.59"
	"link-cplusplus-1.0.5"
	"linux-raw-sys-0.0.46"
	"miow-0.3.6"
	"ntapi-0.3.6"
	"protoc-grpcio-2.0.0"
	"radium-0.5.3"
	"redox_users-0.4.0"
	"rustix-0.35.9"
	"rustversion-1.0.9"
	"str-buf-1.0.5"
	"synom-0.11.3"
	"tap-1.0.1"
	"termcolor-1.1.2"
	"tokio-stream-0.1.3"
	"uart_16550-0.2.18"
	"volatile-0.4.5"
	"wasi-0.10.2+wasi-snapshot-preview1"
	"wasi-0.9.0+wasi-snapshot-preview1"
	"wasm-bindgen-backend-0.2.82"
	"wasm-bindgen-macro-0.2.82"
	"wasm-bindgen-macro-support-0.2.82"
	"wasm-bindgen-shared-0.2.82"
	"winapi-i686-pc-windows-gnu-0.4.0"
	"winapi-util-0.1.5"
	"winapi-x86_64-pc-windows-gnu-0.4.0"
	"windows-sys-0.36.1"
	"windows_aarch64_msvc-0.36.1"
	"windows_i686_gnu-0.36.1"
	"windows_i686_msvc-0.36.1"
	"windows_x86_64_gnu-0.36.1"
	"windows_x86_64_msvc-0.36.1"
	"wyz-0.2.0"
	"x86_64-0.14.10"
)

src_unpack() {
	# Do this first so "${S}" is set up as early as possible. This also
	# prevents cros-rust_src_unpack from modifying ${S}.
	cros-workon_src_unpack
	cros-rust_src_unpack
}

src_prepare() {
	[[ -n "${PATCHES[*]}" ]] && die "User patches are not supported in" \
		"this ebuild. Instead, add patches to" \
		"third_party/rust_crates; please see the README for details."
	# Call eapply_user; otherwise, portage gets upset.
	eapply_user
}

src_configure() {
	:
}

src_compile() {
	# For lack of a better place to put this (since we want it to run when
	# FEATURES=test is not enabled), verify licenses here.
	"${S}/verify_licenses.py" \
		--license-file="${S}/licenses_used.txt" \
		--expected-licenses="${EXPECTED_LICENSES[*]}" \
		|| die
	einfo "License verification complete."

	# If we're working on out-of-tree sources, mirror licenses to make
	# license checks happy. This is a bit hacky, but cheap.
	if [[ "${S}" != "${WORKDIR}"/* ]]; then
		local targ="${WORKDIR}/licenses"
		[[ -e "${targ}" ]] && die "${targ} shouldn't exist"
		einfo "Mirroring licenses from ${S}/vendor to ${targ}..."
		rsync -r --include='*/' --include='LICENSE*' --exclude='*' \
			--prune-empty-dirs "${S}/vendor" "${targ}" || die
	fi
}

# Shellcheck thinks CROS_RUST variables are never defined.
# shellcheck disable=SC2154
src_install() {
	insinto "${CROS_RUST_REGISTRY_DIR}"
	# Prebuilt .a files are installed by some packages, and should not be
	# stripped.
	dostrip -x "${CROS_RUST_REGISTRY_DIR}"
	cd "${S}/vendor" || die
	doins -r "${ALLOWED_CRATE_VERSIONS[@]}"
}

pkg_preinst() {
	cros-rust_cleanup_vendor_registry_links "${ALLOWED_CRATE_VERSIONS[@]}"
}

pkg_postinst() {
	cros-rust_create_vendor_registry_links \
		"${S}/vendor" \
		"${ALLOWED_CRATE_VERSIONS[@]}"
}

pkg_prerm() {
	cros-rust_cleanup_vendor_registry_links "${ALLOWED_CRATE_VERSIONS[@]}"
}

pkg_postrm() {
	cros-rust_create_vendor_registry_links \
		"${S}/vendor" \
		"${ALLOWED_CRATE_VERSIONS[@]}"
}
