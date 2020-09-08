# Copyright 2020 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

# Bootstraps rustc (the official Rust compiler) using mrustc (a Rust
# compiler written in C++).
#
# The version of this ebuild reflects the version of rustc that will
# ultimately be installed.

EAPI=7

inherit toolchain-funcs

DESCRIPTION="Bootstraps the rustc Rust compiler using mrustc"
HOMEPAGE="https://github.com/thepowersgang/mrustc"
MRUSTC_VERSION="0.9"
MRUSTC_NAME="mrustc-${MRUSTC_VERSION}"
INITIAL_RUSTC_VERSION="1.29.0"
# Versions of rustc to build after the initial one.
RUSTC_VERSION_SEQUENCE=(
	1.30.0
	1.31.1
	1.32.0
	1.33.0
	1.34.2
	1.35.0
	1.36.0
	1.37.0
	1.38.0
	1.39.0
	1.40.0
	1.41.1
	1.42.0
	1.43.1
	1.44.1
	${PV}
)
SRC_URI="gs://chromeos-localmirror/distfiles/${MRUSTC_NAME}.tar.gz
	gs://chromeos-localmirror/distfiles/rustc-${INITIAL_RUSTC_VERSION}-src.tar.gz"
for version in "${RUSTC_VERSION_SEQUENCE[@]}"; do
	SRC_URI+=" gs://chromeos-localmirror/distfiles/rustc-${version}-src.tar.gz"
done
LICENSE="MIT Apache-2.0 BSD-1 BSD-2 BSD-4 UoI-NCSA"
SLOT="0"
KEYWORDS="*"
IUSE=""

DEPEND="dev-libs/openssl
	net-libs/libssh2"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/${P}-no-curl.patch"
	"${FILESDIR}/${P}-compilation-fixes.patch"
	"${FILESDIR}/${P}-8ddb05-invalid-output-constraint.patch"
	"${FILESDIR}/${P}-libgit2-sys-pkg-config.patch"
	"${FILESDIR}/${P}-cc.patch"
	"${FILESDIR}/${P}-libc++.patch"
	"${FILESDIR}/${P}-printf.patch"
)

# These tasks take a long time to run for not much benefit: Most of the files
# they check are never installed. Those that are are only there to bootstrap
# the rust ebuild, which has the same RESTRICT anyway.
RESTRICT="binchecks strip"

S="${WORKDIR}/${MRUSTC_NAME}"

src_unpack() {
	default
	# Move rustc sources to where mrustc expects them.
	mv "${WORKDIR}/rustc-${INITIAL_RUSTC_VERSION}-src" "${S}" || die
}

src_prepare() {
	# Call the default implementation. This applies PATCHES.
	default

	# The next few steps mirror what mrustc's Makefile does to configure the
	# build for a specific rustc version.
	(cd "rustc-${INITIAL_RUSTC_VERSION}-src" || die; eapply -p0 "${S}/rustc-${INITIAL_RUSTC_VERSION}-src.patch")
	cd "${S}" || die
	echo "${INITIAL_RUSTC_VERSION}" > "rust-version" || die
	cp "rust-version" "rustc-${INITIAL_RUSTC_VERSION}-src/dl-version" || die

	# There are some patches that need to be applied to the rustc versions
	# we build with rustc. Apply them here.
	local version
	for version in "${RUSTC_VERSION_SEQUENCE[@]}"; do
		einfo "Patching rustc-${version}"
		(cd "${WORKDIR}/rustc-${version}-src" || die; eapply -p2 "${FILESDIR}/${P}-libc++.patch")
	done
}

src_compile() {
	# 1. Build initial rustc using mrustc
	# -----------------------------------
	#
	# All of these specify:
	#  - CC and CXX so that we build with Clang instead of a GCC version that defaults to pre-C99 C.
	#  - LLVM_TARGETS, else it will be empty and rustc will not work.
	#  - RUSTC_VERSION because the Makefiles will otherwise set it to an incorrect value.
	#  - OPENSSL_DIR so that cargo knows where to look for OpenSSL headers.
	export CC=$(tc-getBUILD_CC)
	export CXX=$(tc-getBUILD_CXX)
	export PKG_CONFIG=$(tc-getBUILD_PKG_CONFIG)
	export OPENSSL_DIR="${ESYSROOT}/usr"
	# Two separate commands, because invoking just the second command leads to race
	# conditions.
	emake LLVM_TARGETS=X86 RUSTC_VERSION=${INITIAL_RUSTC_VERSION} output/rustc output/cargo
	emake LLVM_TARGETS=X86 RUSTC_VERSION=${INITIAL_RUSTC_VERSION} -C run_rustc

	# 2. Build successive versions of rustc using previous rustc
	# ----------------------------------------------------------
	local prev_version=${INITIAL_RUSTC_VERSION}
	local prev_cargo="${S}/run_rustc/output/prefix/bin/cargo"
	local prev_rustc="${S}/run_rustc/output/prefix/bin/rustc"
	local next_version rustc_dir
	for next_version in "${RUSTC_VERSION_SEQUENCE[@]}"; do
		einfo "Building rustc-${next_version} using rustc-${prev_version}"
		rustc_dir="${WORKDIR}/rustc-${next_version}-src"
		cd "${rustc_dir}" || die "Could not chdir to ${rustc_dir}"
		cat > config.toml <<EOF
[build]
cargo = "${prev_cargo}"
rustc = "${prev_rustc}"
docs = false
vendor = true
# extended means we also build cargo and a few other commands.
extended = true

[install]
prefix = "${ED}/opt/rust-bootstrap-${next_version}"

[rust]
default-linker = "${CC}"

[target.x86_64-unknown-linux-gnu]
cc = "${CC}"
cxx = "${CXX}"
linker = "${CC}"
EOF

		# --stage 2 causes this to use the previously-built compiler,
		# instead of the default behavior of downloading one from
		# upstream.
		./x.py --stage 2 build || die
		# For some rustc versions (e.g. 1.31.1), the build script will exit with
		# a nonzero exit status because miri fails to build when it is not in a git
		# repository. This does not affect the ability to build the next rustc.
		# So instead of looking at the exit code, we check if rustc and cargo
		# were built.
		prev_version=${next_version}
		prev_cargo="${rustc_dir}/build/x86_64-unknown-linux-gnu/stage2-tools/x86_64-unknown-linux-gnu/release/cargo"
		prev_rustc="${rustc_dir}/build/x86_64-unknown-linux-gnu/stage2/bin/rustc"
		[[ -x "${prev_rustc}" ]] || die "Failed to build ${prev_rustc}"
		[[ -x "${prev_cargo}" ]] || die "Failed to build ${prev_cargo}"
		einfo "Built rustc-${next_version}"
	done

	# Remove the src/rust symlink which will be dangling after sources are
	# removed, and the containing src directory.
	rm "${WORKDIR}/rustc-${PV}-src/build/x86_64-unknown-linux-gnu/stage2/lib/rustlib/src/rust" || die
	rmdir "${WORKDIR}/rustc-${PV}-src/build/x86_64-unknown-linux-gnu/stage2/lib/rustlib/src" || die
}

src_install() {
	local obj="${WORKDIR}/rustc-${PV}-src/build/x86_64-unknown-linux-gnu/stage2"
	local tools="${obj}-tools/x86_64-unknown-linux-gnu/release/"
	exeinto "/opt/${P}/bin"
	# With rustc-1.45.2 at least, regardless of the value of install.libdir,
	# the rpath seems to end up as $ORIGIN/../lib. So install the libraries there.
	insinto "/opt/${P}/lib"
	doexe "${obj}/bin/rustc"
	doexe "${tools}/cargo"
	doins -r "${obj}/lib/"*
	find "${D}" -name '*.so' -exec chmod +x '{}' ';'
}
