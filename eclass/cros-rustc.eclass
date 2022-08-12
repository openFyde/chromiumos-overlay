# Copyright 2022 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: cros-rustc.eclass
# @MAINTAINER:
# The Chromium OS Toolchain Team <chromeos-toolchain@google.com>
# @BUGREPORTS:
# Please report bugs via
# https://issuetracker.google.com/issues/new?component=1038090&template=1576440
# @VCSURL: https://chromium.googlesource.com/chromiumos/overlays/chromiumos-overlay/+/HEAD/eclass/@ECLASS@
# @BLURB: Eclass for building CrOS' Rust toolchain.
# @DESCRIPTION:
# This eclass is used to build both dev-lang/rust-host and dev-lang/rust.
#
# dev-lang/rust-host is an ebuild that provides all artifacts necessary for
# building Rust for the host. dev-lang/rust supplements this with libraries for
# cross-compiling. We maintain this split because we need to build Rust
# binaries for the host prior to cross-* libraries being available.
#
# An important concept when building dev-lang/rust-host and dev-lang/rust is
# continuity: these packages are expected to be built from _identical_ Rust
# sources. This assumption:
# - doesn't restrict us in any meaningful way,
# - keeps us more consistent with upstream flows for building `rustc`, and
# - allows us to significantly cut down on the build time of dev-lang/rust,
#   since dev-lang/rust can skip unpacking sources, configuring them, and
#   rebuilding LLVM + stage0 + stage1.
#
# Moreover, if you want to make meaningful changes to Rust, you'll need to
# always reemerge _both_ dev-lang/rust-host and dev-lang/rust. dev-lang/rust
# assumes that the sources unpacked by dev-lang/rust-host, if present, are
# identical to the ones it will build. dev-lang/rust-host always starts with a
# clean slate.

if [[ -z ${_ECLASS_CROS_RUSTC} ]]; then
_ECLASS_CROS_RUSTC="1"

# Check for EAPI 7+.
case "${EAPI:-0}" in
[0123456]) die "unsupported EAPI (${EAPI}) in eclass (${ECLASS})" ;;
esac

EXPORT_FUNCTIONS pkg_setup src_unpack src_prepare src_configure src_compile

PYTHON_COMPAT=( python3_{6..9} )
inherit python-any-r1 toolchain-funcs

# @ECLASS-VARIABLE: RUSTC_TARGET_TRIPLES
# @DEFAULT_UNSET
# @REQUIRED
# @DESCRIPTION:
# This is the list of target triples for rustc as they appear in the cros_sdk.
# cros-rust_src_configure instructs cros-rust_src_compile to use
# "${triple}-clang" when building each one of these.

# @ECLASS-VARIABLE: RUSTC_BARE_TARGET_TRIPLES
# @DEFAULT_UNSET
# @DESCRIPTION:
# These are the triples we use GCC with. `*-cros-*` triples should not be
# included here.

# @ECLASS-VARIABLE: CROS_RUSTC_BUILD_RAW_SOURCES
# @DEFAULT_UNSET
# @DESCRIPTION:
# Set to a nonempty value if we want to build a nonstandard set of sources
# (this is intended mostly to power bisection of rustc itself).
# This should never be set to anything in production.
#
# If you want to set this as a user, each `emerge` of `dev-lang/rust-host` or
# `dev-lang/rust` assumes the following:
# 1. A full Rust checkout is available under `_CROS_RUSTC_RAW_SOURCES_ROOT`.
# 2. You've ensured that all submodules under `_CROS_RUSTC_RAW_SOURCES_ROOT` are
#    up-to-date with your currently checked out revision.
# 3. You've ensured that the appropriate bootstrap compiler is cached under
#    `_CROS_RUSTC_RAW_SOURCES_ROOT/build`.
# 4. You've run `cargo vendor` under `_CROS_RUSTC_RAW_SOURCES_ROOT`
# 5. The sources under `_CROS_RUSTC_RAW_SOURCES_ROOT` are the exact sources you
#    want to apply `${PATCHES}` to.
# 6. You are OK with this script modifying your rustc sources at
#    `_CROS_RUSTC_RAW_SOURCES_ROOT` (by applying patches to them).
#
# Step 2 can be done with
# `dev-lang/rust/files/bisect-scripts/clean_and_sync_rust_root.sh`. Steps 3 and
# 4 can be accomplished with
# `dev-lang/rust/files/bisect-scripts/prepare_rust_for_offline_build.sh`.
CROS_RUSTC_BUILD_RAW_SOURCES=

# There's a fair amount of direct commonality between dev-lang/rust and
# dev-lang/rust-host. Capture that here.
ABI_VER="$(ver_cut 1-2)"
SLOT="stable/${ABI_VER}"
MY_P="rustc-${PV}"
SRC="${MY_P}-src.tar.gz"

# The version of rust-bootstrap that we're using to build our current Rust
# toolchain. This is generally the version released prior to the current one,
# since Rust uses the beta compiler to build the nightly compiler.
BOOTSTRAP_VERSION="1.59.0"

# If `CROS_RUSTC_BUILD_RAW_SOURCES` is nonempty, a full Rust source tree is
# expected to be available here.
_CROS_RUSTC_RAW_SOURCES_ROOT="${FILESDIR}/rust"

HOMEPAGE="https://www.rust-lang.org/"

if [[ -z "${CROS_RUSTC_BUILD_RAW_SOURCES}" ]]; then
	SRC_URI="https://static.rust-lang.org/dist/${SRC} -> rustc-${PV}-src.tar.gz"
else
	# If a bisection is happening, we use the bootstrap compiler that upstream prefers.
	# Clear this so we don't accidentally use it below.
	BOOTSTRAP_VERSION=
fi

LICENSE="|| ( MIT Apache-2.0 ) BSD-1 BSD-2 BSD-4 UoI-NCSA"

RESTRICT="binchecks strip"

DEPEND="${PYTHON_DEPS}
	>=dev-libs/libxml2-2.9.6
	>=dev-lang/perl-5.0
"

if [[ -z "${CROS_RUSTC_BUILD_RAW_SOURCES}" ]]; then
	BDEPEND="dev-lang/rust-bootstrap:${BOOTSTRAP_VERSION}"
fi

PATCHES=(
	"${FILESDIR}/rust-${PV}-add-cros-targets.patch"
	"${FILESDIR}/rust-${PV}-fix-rpath.patch"
	"${FILESDIR}/rust-${PV}-Revert-CMake-Unconditionally-add-.h-and-.td-files-to.patch"
	"${FILESDIR}/rust-${PV}-no-test-on-build.patch"
	"${FILESDIR}/rust-${PV}-sanitizer-supported.patch"
	"${FILESDIR}/rust-${PV}-cc.patch"
	"${FILESDIR}/rust-${PV}-revert-libunwind-build.patch"
	"${FILESDIR}/rust-${PV}-ld-argv0.patch"
	"${FILESDIR}/rust-${PV}-Handle-sparse-git-repo-without-erroring.patch"
	"${FILESDIR}/rust-${PV}-disable-mutable-noalias.patch"
	"${FILESDIR}/rust-${PV}-add-armv7a-sanitizers.patch"
	"${FILESDIR}/rust-${PV}-fix-libunwind-backtrace-visibility.patch"
	"${FILESDIR}/rust-${PV}-passes-only-in-pre-link.patch"
	"${FILESDIR}/rust-${PV}-Revert-DebugInfo-Re-enable-instruction-referencing-f.patch"
	"${FILESDIR}/rust-${PV}-Don-t-build-std-for-uefi-targets.patch"
	"${FILESDIR}/rust-${PV}-Bump-cc-version-in-bootstrap-to-fix-build-of-uefi-ta.patch"
)

# Locations where we cache our build/src dirs.
CROS_RUSTC_DIR="${SYSROOT}/var/cache/portage/${CATEGORY}/rust-artifacts"
CROS_RUSTC_BUILD_DIR="${CROS_RUSTC_DIR}/build"
CROS_RUSTC_SRC_DIR="${CROS_RUSTC_DIR}/src"

S="${CROS_RUSTC_SRC_DIR}/${MY_P}-src"

_CROS_RUSTC_PREPARED_STAMP="${CROS_RUSTC_SRC_DIR}/cros-rust-prepared"
_CROS_RUSTC_STAGE1_EXISTS_STAMP="${CROS_RUSTC_BUILD_DIR}/cros-rust-has-stage1-build"

# @FUNCTION: cros-rustc_has_existing_checkout
# @DESCRIPTION:
# Tests whether we have a properly src_prepare'd checkout in ${CROS_RUSTC_DIR}.
cros-rustc_has_existing_checkout() {
	[[ -e "${_CROS_RUSTC_PREPARED_STAMP}" ]]
}

# @FUNCTION: cros-rustc_has_existing_stage1_build
# @DESCRIPTION:
# Tests whether ${CROS_RUSTC_BUILD_DIR} has a valid stage1 toolchain available.
cros-rustc_has_existing_stage1_build() {
	[[ -e "${_CROS_RUSTC_STAGE1_EXISTS_STAMP}" ]]
}

cros-rustc_pkg_setup() {
	python-any-r1_pkg_setup

	if [[ ${MERGE_TYPE} != "binary" ]]; then
		addwrite "${CROS_RUSTC_DIR}"
		# Disable warnings about 755 only applying to the deepest directory; that's
		# fine.
		# shellcheck disable=SC2174
		mkdir -p -m 755 "${CROS_RUSTC_DIR}"
		chown "${PORTAGE_USERNAME}:${PORTAGE_GRPNAME}" "${CROS_RUSTC_DIR}"

		if [[ -n "${CROS_RUSTC_BUILD_RAW_SOURCES}" ]]; then
			addwrite "${_CROS_RUSTC_RAW_SOURCES_ROOT}"
			ewarn "cros-rustc.eclass is using raw sources. This feature is for debugging only."
		fi
	fi
}

# Sets up a cargo config.toml that instructs our bootstrap rustc to use
# the correct linker. `rust-bootstrap` can be made to work around this since
# we have local patches, but bootstrap compilers downloaded from upstream
# (e.g., during bisection) cannot. This should be called during src_unpack
# if you opt out of calling `cros-rustc_src_unpack`. Otherwise,
# `cros-rustc_src_unpack` will take care of this.
cros-rustc_setup_cargo_home() {
	export CARGO_HOME="${T}/cargo_home"
	mkdir -p "${CARGO_HOME}" || die
	cat >> "${CARGO_HOME}/config.toml" <<EOF || die

[target.x86_64-unknown-linux-gnu]
linker = "${CHOST}-clang"

[target.${CHOST}]
linker = "${CHOST}-clang"
EOF
}

cros-rustc_src_unpack() {
	cros-rustc_setup_cargo_home

	if [[ -n "${CROS_RUSTC_BUILD_RAW_SOURCES}" ]]; then
		if [[ ! -d "${_CROS_RUSTC_RAW_SOURCES_ROOT}" ]]; then
			eerror "You must have a full Rust checkout in _CROS_RUSTC_RAW_SOURCES_ROOT."
			die
		fi
		if [[ -e "${S}" && ! -L "${S}" ]]; then
			rm -rf "${S}" || die
		fi
		ln -sf "$(readlink -m "${_CROS_RUSTC_RAW_SOURCES_ROOT}")" "${S}" || die
		default
		return
	fi

	local dirs=( "${CROS_RUSTC_BUILD_DIR}" "${CROS_RUSTC_SRC_DIR}" )
	if [[ -e "${CROS_RUSTC_SRC_DIR}" || -e "${CROS_RUSTC_BUILD_DIR}" ]]; then
		einfo "Removing old source/build directories..."
		rm -rf "${dirs[@]}"
	fi

	# Disable warnings about 755 only applying to the deepest directory; that's
	# fine.
	# shellcheck disable=SC2174
	mkdir -p -m 755 "${dirs[@]}"
	(cd "${CROS_RUSTC_SRC_DIR}" && default)
}

cros-rustc_src_prepare() {
	if [[ -n "${CROS_RUSTC_BUILD_RAW_SOURCES}" ]]; then
		einfo "Synchronizing bootstrap compiler caches ..."
		cp -avu "${_CROS_RUSTC_RAW_SOURCES_ROOT}/build/cache" "${CROS_RUSTC_BUILD_DIR}" || die
	fi

	# Copy "unknown" vendor targets to create cros_sdk target triple
	# variants as referred to in 0001-add-cros-targets.patch and
	# RUSTC_TARGET_TRIPLES. armv7a is treated specially because the cros
	# toolchain differs in more than just the vendor part of the target
	# triple. The arch is armv7a in cros versus armv7.
	pushd compiler/rustc_target/src/spec || die
	sed -e 's:"unknown":"pc":g' x86_64_unknown_linux_gnu.rs >x86_64_pc_linux_gnu.rs || die
	sed -e 's:"unknown":"cros":g' x86_64_unknown_linux_gnu.rs >x86_64_cros_linux_gnu.rs || die
	sed -e 's:"unknown":"cros":g' armv7_unknown_linux_gnueabihf.rs >armv7a_cros_linux_gnueabihf.rs || die
	sed -e 's:"unknown":"cros":g' aarch64_unknown_linux_gnu.rs >aarch64_cros_linux_gnu.rs || die
	popd || die

	# The miri tool is built because of 'extended = true' in
	# cros-config.toml, but the build is busted. See the upstream issue:
	# [https://github.com/rust- lang/rust/issues/56576]. Because miri isn't
	# installed or needed, this sed script eradicates the command that
	# builds it during the bootstrap script.
	pushd src/bootstrap || die
	sed -i 's@tool::Miri,@@g' builder.rs
	popd || die

	# Tsk. Tsk. The rust makefile for LLVM's compiler-rt uses -ffreestanding
	# but one of the files includes <stdlib.h> causing occasional problems
	# with MB_LEN_MAX. See crbug.com/730845 for the thrilling details. This
	# line patches over the problematic include.
	sed -e 's:#include <stdlib.h>:void abort(void);:g' \
		-i "${ECONF_SOURCE:-.}"/src/llvm-project/compiler-rt/lib/builtins/int_util.c || die

	# For the rustc_llvm module, the build will link with -nodefaultlibs and
	# manually choose the std C++ library. For x86_64 Linux, the build
	# script always chooses libstdc++ which will not work if LLVM was built
	# with USE="default-libcxx". This snippet changes that choice to libc++
	# in the case that clang++ defaults to libc++.
	if "${CXX}" -### -x c++ - < /dev/null 2>&1 | grep -q -e '-lc++'; then
		sed -i 's:"stdc++":"c++":g' compiler/rustc_llvm/build.rs || die
	fi

	default

	touch "${_CROS_RUSTC_PREPARED_STAMP}"
}

cros-rustc_src_configure() {
	tc-export CC PKG_CONFIG

	# If FEATURES=ccache is set, we can cache LLVM builds. We could set this to
	# true unconditionally, but invoking `ccache` to just have it `exec` the
	# compiler costs ~10secs of wall time on rust-host builds. No point in
	# wasting the cycles.
	local use_ccache=false
	[[ -z "${CCACHE_DISABLE:-}" ]] && use_ccache=true

	local targets=""
	local tt
	# These variables are defined by users of this eclass; their use here is safe.
	# shellcheck disable=SC2154
	for tt in "${RUSTC_TARGET_TRIPLES[@]}" "${RUSTC_BARE_TARGET_TRIPLES[@]}" ; do
		targets+="\"${tt}\", "
	done

	local bootstrap_compiler_info
	if [[ -z "${CROS_RUSTC_BUILD_RAW_SOURCES}" ]]; then
		bootstrap_compiler_info="
cargo = \"/opt/rust-bootstrap-${BOOTSTRAP_VERSION}/bin/cargo\"
rustc = \"/opt/rust-bootstrap-${BOOTSTRAP_VERSION}/bin/rustc\""
	fi

	local config=cros-config.toml
	cat > "${config}" <<EOF
[build]
target = [${targets}]
docs = false
submodules = false
python = "${EPYTHON}"
vendor = true
extended = true
tools = ["cargo", "rustfmt", "clippy", "cargofmt"]
sanitizers = true
profiler = true
build-dir = "${CROS_RUSTC_BUILD_DIR}"
${bootstrap_compiler_info}

[llvm]
ccache = ${use_ccache}
ninja = true
targets = "AArch64;ARM;X86"

[install]
prefix = "${ED}usr"
libdir = "$(get_libdir)"
mandir = "share/man"

[rust]
default-linker = "${CBUILD}-clang"
description = "${PF}"
channel = "nightly"
codegen-units = 0
llvm-libunwind = 'in-tree'
codegen-tests = false
new-symbol-mangling = true

EOF

	for tt in "${RUSTC_TARGET_TRIPLES[@]}" ; do
		cat >> "${config}" <<EOF
[target."${tt}"]
cc = "${tt}-clang"
cxx = "${tt}-clang++"
linker = "${tt}-clang++"

EOF
	done
}

cros-rustc_src_compile() {
	${EPYTHON} x.py build --stage 2 --config cros-config.toml "$@" || die

	# Remove the src/rust symlink which will be dangling after sources are
	# removed, and the containing src directory.
	rm "${CROS_RUSTC_BUILD_DIR}/x86_64-unknown-linux-gnu/stage2/lib/rustlib/src/rust" || die
	rmdir "${CROS_RUSTC_BUILD_DIR}/x86_64-unknown-linux-gnu/stage2/lib/rustlib/src" || die

	# Since we always build for stage2, we're guaranteed that stage1 exists
	# at this point.
	touch "${_CROS_RUSTC_STAGE1_EXISTS_STAMP}"
}
fi
