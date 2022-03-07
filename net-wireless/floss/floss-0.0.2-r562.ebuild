# Copyright 2021 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

CROS_WORKON_COMMIT=("ab19e478567b9adead327ae57245c729551cf400" "57622c268f271a2eafb1b2e39188c44671053389" "eb61e8bf8d9e6a604ee196628ac063b3bbdef2c1" "ffa962554f12fa6942546a4a3d7f21f83f6e7ac4" "bccc6fd42e657daf043864fc28684422cdb56957")
CROS_WORKON_TREE=("6aa4b259533027a10db1d4f89ed4cf9fbc0b65a2" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb" "b096cba1e7ed10ba05c77d634bb63a0150ed0284" "56ab96448a5bc077971f5a65de4d00e6b78a948d" "66f9d141406fd5ac2ef4f0709d11aba79363cc0f" "5da74ac655d7167f664aa6f1ca5cb51ae90a0952")
CROS_WORKON_PROJECT=(
	"chromiumos/platform2"
	"aosp/platform/packages/modules/Bluetooth"
	"aosp/platform/packages/modules/Bluetooth"
	"aosp/platform/frameworks/proto_logging"
	"chromiumos/third_party/rust_crates"
)
CROS_WORKON_LOCALNAME=(
	"../platform2"
	"../aosp/packages/modules/Bluetooth/local"
	"../aosp/packages/modules/Bluetooth/upstream"
	"../aosp/frameworks/proto_logging"
	"../third_party/rust_crates"
)
CROS_WORKON_DESTDIR=(
	"${S}/platform2"
	"${S}/platform2/bt"
	"${S}/platform2/bt"
	"${S}/platform2/external/proto_logging"
	"${S}/platform2/external/rust"
)
CROS_WORKON_SUBTREE=("common-mk .gn" "" "" "" "")
CROS_WORKON_EGIT_BRANCH=("main" "main" "upstream/master" "master" "main")
CROS_WORKON_OPTIONAL_CHECKOUT=(
	""
	"use !floss_upstream"
	"use floss_upstream"
	""
	""
)
CROS_WORKON_INCREMENTAL_BUILD=1
PLATFORM_SUBDIR="bt"

IUSE="bt_dynlib floss_upstream"

inherit cros-workon toolchain-funcs cros-rust platform tmpfiles

DESCRIPTION="Bluetooth Tools and System Daemons for Linux"
HOMEPAGE="https://android.googlesource.com/platform/system/bt/"

# Apache-2.0 for system/bt
# All others from rust crates
LICENSE="
	Apache-2.0
	MIT BSD ISC
"

KEYWORDS="*"

#
# TODO(b/188819708)
# Floss continues to depend on bluez for a few things:
#  - Several headers (bluetooth.h, l2cap.h, etc) which are used by Chrome
#  - Bluetooth user + group are added in bluez's postinst
#
DEPEND="
	dev-libs/flatbuffers:=
	dev-libs/modp_b64:=
	dev-libs/tinyxml2:=
	dev-libs/openssl:=
	=dev-rust/cc-1*:=
	net-wireless/bluez
"

BDEPEND="
	dev-libs/tinyxml2:=
"

RDEPEND="${DEPEND}"

DOCS=( README.md )

src_unpack() {
	platform_src_unpack

	# Cros rust unpack should come after platform unpack otherwise platform
	# unpack will fail.
	cros-rust_src_unpack

	# In order to be compatible with cros-rust.eclass while also using our
	# own vendored crates, we re-use the existing config but add a floss
	# source and replace source.crates-io with it.
	sed -i 's/replace-with = "chromeos"/replace-with = "floss"/' "${ECARGO_HOME}/config"
	cat <<- EOF >> "${ECARGO_HOME}/config"

	[source.floss]
	directory = "${S}/../external/rust/vendor"
	EOF
}

src_configure() {
	if tc-is-cross-compiler ; then
		# Delete old host build folder otherwise we will continue using
		# old binaries
		local build_dir="$(cros-workon_get_build_dir)"
		rm -rf "${build_dir:?}/${CBUILD}"

		# Build tools and move to host directory
		mkdir -p "${build_dir}/${CBUILD}"
		ARCH="$(tc-arch ${CBUILD})" tc-env_build platform "configure" "--host"
		ARCH="$(tc-arch ${CBUILD})" tc-env_build platform "compile" "tools" "--host"
		mv "${build_dir}/out" "${build_dir}/${CBUILD}/"
	fi

	local cxx_outdir="$(cros-workon_get_build_dir)/out/Default"
	local rustflags=(
		# Add C/C++ build path to linker search path
		"-L ${cxx_outdir}"

		# Add sysroot libdir to search path.
		"-L ${SYSROOT}/usr/$(get_libdir)/"

		# Also ignore multiple definitions for now (added due to some
		# shared library shenaningans)
		"-C link-arg=-Wl,--allow-multiple-definition"
	)

	# When using clang + asan, we need to link C++ lib. The build defaults
	# to using -lstdc++ which fails to link.
	use asan && rustflags+=( '-lc++' )

	export EXTRA_RUSTFLAGS="${rustflags[*]}"

	cros-rust_src_configure
	platform_src_configure
}

floss_build_tools() {
	local bin_dir="$(cros-workon_get_build_dir)/out/Default/"
	if tc-is-cross-compiler ; then
		local host_dir="$(cros-workon_get_build_dir)/${CBUILD}/out/Default"
		mkdir -p "${bin_dir}"
		cp "${host_dir}/bluetooth_packetgen" "${bin_dir}"
		cp "${host_dir}/bluetooth_flatbuffer_bundler" "${bin_dir}"
	else
		platform "compile" "tools" "--host"
	fi

	# Make sure packetgen is also available to rust
	mkdir -p "${ECARGO_HOME}/bin/"
	cp "${bin_dir}/bluetooth_packetgen" "${ECARGO_HOME}/bin/"
}

floss_build_rust() {
	# Check if cxxflags has -fno-exceptions and set -DRUST_CXX_NO_EXCEPTIONS
	# This is required to build the cxx rust dependency
	if is-flagq -fno-exceptions; then
		append-cxxflags -DRUST_CXX_NO_EXCEPTIONS
	fi

	# cc rust package requires CLANG_PATH so it uses correct clang triple
	export CLANG_PATH="$(tc-getCC)"
	export HOST_CFLAGS=${BUILD_CFLAGS}

	# Export the source path for bindgen
	export CXX_ROOT_PATH="${S}"

	cros-rust_src_compile
}

src_compile() {
	# Build tools required for building the runtime and copy to both the GN
	# directory and the Rust bin directory
	floss_build_tools

	# Compile for target (generates static libs)
	platform_src_compile

	# Build rust portion (finish linking in rust)
	floss_build_rust
}

src_install() {
	platform_src_install

	dobin "${CARGO_TARGET_DIR}/${CHOST}/release/btmanagerd"
	dobin "${CARGO_TARGET_DIR}/${CHOST}/release/btadapterd"
	dobin "${CARGO_TARGET_DIR}/${CHOST}/release/btclient"

	if use bt_dynlib; then
		dolib.so "${OUT}/lib/libbluetooth.so"
	fi

	# Install D-Bus config
	insinto /etc/dbus-1/system.d
	doins "${FILESDIR}/dbus/org.chromium.bluetooth.conf"

	# Install upstart rules
	insinto /etc/init/
	doins "${FILESDIR}/upstart/btmanagerd.conf"
	doins "${FILESDIR}/upstart/btadapterd.conf"

	# Install tmpfiles (don't forget to update sepolicy if you change the
	# files/folders created to something other than /var/lib/bluetooth)
	dotmpfiles "${FILESDIR}/tmpfiles.d/floss.conf"
}

platform_pkg_test() {
	local tests=(
		"bluetoothtbd_test"
		"bluetooth_test_common"
		"net_test_avrcp"
		"net_test_btcore"
		"net_test_types"
		"net_test_btm_iso"
		# TODO(b/178740721) - This test wasn't compiling. Need to fix
		# this and re-enable it.
		# "net_test_btpackets"
	)

	# Run rust tests
	# TODO(b/210127355) - Fix flaky tests and re-enable
	# cros-rust_src_test

	# TODO(b/190750167) - Re-enable once we're fully Bazel build
	#local test_bin
	#for test_bin in "${tests[@]}"; do
		#platform_test run "${OUT}/${test_bin}"
	#done
}
