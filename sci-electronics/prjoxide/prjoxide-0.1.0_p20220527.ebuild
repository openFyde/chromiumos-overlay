# Copyright 2021 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit cros-rust

DESCRIPTION="Project Oxide - documenting Lattice's 28nm \"Nexus\" FPGA parts"
HOMEPAGE="https://github.com/gatecat/prjoxide"

GIT_REV="d1fc5cd045531a0cc48ebffd5802f4ef84067aea"

# 'database' submodule.
DB_GIT_REV="1566e0d8af245c4d52f4c5ec04667e5a4f0f01e2"

# '3rdparty/fpga-interchange-schema' submodule.
SCHEMA_GIT_REV="78abf3f30770ccc6d0e1f5dbfeaef2666f55acf6"

SRC_URI="
	https://github.com/gatecat/prjoxide/archive/${GIT_REV}.tar.gz -> prjoxide-${GIT_REV}.tar.gz
	https://github.com/gatecat/prjoxide-db/archive/${DB_GIT_REV}.tar.gz -> prjoxide-db-${DB_GIT_REV}.tar.gz
	https://github.com/SymbiFlow/fpga-interchange-schema/archive/${SCHEMA_GIT_REV}.tar.gz -> fpga-interchange-schema-${SCHEMA_GIT_REV}.tar.gz
"

LICENSE="ISC"
SLOT="0"
KEYWORDS="*"

DEPEND="
	dev-rust/third-party-crates-src:=
	=dev-rust/capnp-0.14*
	=dev-rust/clap-3.1*
	=dev-rust/flate2-1*
	=dev-rust/include_dir-0.6*
	>=dev-rust/itertools-0.8.2 <dev-rust/itertools-0.9.0
	>=dev-rust/lazy_static-1.4.0 <dev-rust/lazy_static-2.0.0
	>=dev-rust/log-0.4.11 <dev-rust/log-0.5.0
	=dev-rust/multimap-0.8*
	=dev-rust/num-bigint-0.4*
	>=dev-rust/pulldown-cmark-0.6.1 <dev-rust/pulldown-cmark-0.7.0
	=dev-rust/regex-1*
	>=dev-rust/ron-0.5.1 <dev-rust/ron-0.6.0
	=dev-rust/serde-1*
	=dev-rust/serde_json-1*
"
RDEPEND="
	${DEPEND}
	sci-electronics/yosys
"

PRJOXIDE_ROOT_DIR="${WORKDIR}/${PN}-${GIT_REV}"
S="${PRJOXIDE_ROOT_DIR}/libprjoxide/prjoxide"

PATCHES=(
	"${FILESDIR}/prjoxide-update-clap.patch"
)

src_unpack() {
	cros-rust_src_unpack

	cd "${PRJOXIDE_ROOT_DIR}" || die
	mv -T ../prjoxide-db-* database || die
	mv -T ../fpga-interchange-schema-* 3rdparty/fpga-interchange-schema || die

	# Remove to build only the prjoxide binary (with prjoxide/Cargo.toml).
	rm libprjoxide/Cargo.toml || die
}

src_compile() {
	ecargo_build
}

src_test() {
	ebegin "Testing 'prjoxide --help'"
	"$(cros-rust_get_build_dir)/prjoxide" --help &>/dev/null \
		|| die "The binary hasn't been correctly built!"
	eend
}

src_install() {
	dobin "$(cros-rust_get_build_dir)/prjoxide"

	dodoc "${PRJOXIDE_ROOT_DIR}/README.md"

	insinto /usr/share/${PN}
	doins -r "${PRJOXIDE_ROOT_DIR}/examples"
}
