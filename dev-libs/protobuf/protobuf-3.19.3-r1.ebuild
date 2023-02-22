# Copyright 2008-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# This ebuild is hacked up to only install the shared libraries needed until we
# can get a build of third party code linking against the newer version.

EAPI="7"

inherit autotools elisp-common flag-o-matic multilib-minimal toolchain-funcs

if [[ "${PV}" == "9999" ]]; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/protocolbuffers/protobuf"
	EGIT_SUBMODULES=()
fi

DESCRIPTION="Google's Protocol Buffers - Extensible mechanism for serializing structured data"
HOMEPAGE="https://developers.google.com/protocol-buffers/ https://github.com/protocolbuffers/protobuf"
if [[ "${PV}" == "9999" ]]; then
	SRC_URI=""
else
	SRC_URI="https://github.com/protocolbuffers/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
fi

LICENSE="BSD"
SLOT="PITA/30"
KEYWORDS="*"
IUSE="emacs examples static-libs test zlib"
RESTRICT="!test? ( test )"

BDEPEND="emacs? ( app-editors/emacs:* )"
DEPEND="test? ( >=dev-cpp/gtest-1.9[${MULTILIB_USEDEP}] )
	zlib? ( sys-libs/zlib[${MULTILIB_USEDEP}] )
	dev-libs/protobuf:0/32"
RDEPEND="emacs? ( app-editors/emacs:* )
	zlib? ( sys-libs/zlib[${MULTILIB_USEDEP}] )
	dev-libs/protobuf:0/32"

PATCHES=(
	"${FILESDIR}/${PN}-3.19.0-disable_no-warning-test.patch"
	"${FILESDIR}/${PN}-3.19.0-system_libraries.patch"
	"${FILESDIR}/${PN}-3.16.0-protoc_input_output_files.patch"
)

DOCS=(CHANGES.txt CONTRIBUTORS.txt README.md)

src_prepare() {
	default

	# https://github.com/protocolbuffers/protobuf/issues/7413
	sed -e "/^AC_PROG_CXX_FOR_BUILD$/d" -i configure.ac || die

	# https://github.com/protocolbuffers/protobuf/issues/8082
	sed -e "/^TEST_F(IoTest, LargeOutput) {$/,/^}$/d" -i src/google/protobuf/io/zero_copy_stream_unittest.cc || die

	# https://github.com/protocolbuffers/protobuf/issues/8459
	sed \
		-e "/^TEST(ArenaTest, BlockSizeSmallerThanAllocation) {$/a\\  if (sizeof(void*) == 4) {\n    GTEST_SKIP();\n  }" \
		-e "/^TEST(ArenaTest, SpaceAllocated_and_Used) {$/a\\  if (sizeof(void*) == 4) {\n    GTEST_SKIP();\n  }" \
		-i src/google/protobuf/arena_unittest.cc || die

	# https://github.com/protocolbuffers/protobuf/issues/8460
	sed -e "/^TEST(AnyTest, TestPackFromSerializationExceedsSizeLimit) {$/a\\  if (sizeof(void*) == 4) {\n    GTEST_SKIP();\n  }" -i src/google/protobuf/any_test.cc || die

	# https://github.com/protocolbuffers/protobuf/issues/9392
	sed -e "s/^AC_PROG_OBJC$/AS_CASE([\$target_os], [darwin*], [AC_PROG_OBJC], [AM_CONDITIONAL([am__fastdepOBJC], [false])])/" -i configure.ac || die

	# https://github.com/protocolbuffers/protobuf/issues/9433
	sed -e "/^[[:space:]]*static_assert(alignof(T) <= 8, \"\");$/d" -i src/google/protobuf/descriptor.cc || die

	eautoreconf
}

src_configure() {
	append-cppflags -DGOOGLE_PROTOBUF_NO_RTTI

	if tc-ld-is-gold; then
		# https://sourceware.org/bugzilla/show_bug.cgi?id=24527
		tc-ld-disable-gold
	fi

	multilib-minimal_src_configure
}

multilib_src_configure() {
	local options=(
		$(use_enable static-libs static)
		$(use_with zlib)
	)

	if tc-is-cross-compiler; then
		# Build system uses protoc when building, so protoc copy runnable on host is needed.
		mkdir -p "${WORKDIR}/build" || die
		pushd "${WORKDIR}/build" > /dev/null || die
		ECONF_SOURCE="${S}" econf_build "${options[@]}"
		options+=(--with-protoc="$(pwd)/src/protoc")
		popd > /dev/null || die
	fi

	ECONF_SOURCE="${S}" econf "${options[@]}"
}

src_compile() {
	multilib-minimal_src_compile
}

multilib_src_compile() {
	emake -C "src" libprotobuf-lite.la libprotobuf.la libprotoc.la
}

multilib_src_install() {
	DESTDIR="${ED}" emake -C "src" install-libLTLIBRARIES
	libtool --finish "${ED}/usr/lib64" || die

	# Remove
	# * .la files
	# * libprotoc which isn't needed.
	# * top level .so symlinks
	find "${ED}" \( -iname '*.la' -or -iname 'libprotoc.*' -or -iname 'libprotoc.*' -or -iname '*.so' \) -delete || die
}
