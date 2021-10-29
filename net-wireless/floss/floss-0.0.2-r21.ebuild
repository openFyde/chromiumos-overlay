# Copyright 2021 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

CROS_WORKON_COMMIT=("80fcb53102c1c921de187ba00b780f1ea0a13e18" "b6e307d61e1a2f361079c1f308d8a1566026d4b2" "06ed9cf72897e1f8b54a8d74f4aed932a4996662" "fd36c25f2a8c6659c83f07391f95af3a171cb685")
CROS_WORKON_TREE=("f9c9ff0f07a0e5d4015af871a558204de304bb90" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb" "d472c5e43eee9d548ec97228ae2f141078e3410e" "7eae68a604c33288e18b948cc1cf30a87f0a74bc" "7a34b72edeab38960a8149a82cf554cd16606dba")
CROS_WORKON_PROJECT=(
	"chromiumos/platform2"
	"aosp/platform/system/bt"
	"aosp/platform/frameworks/proto_logging"
	"chromiumos/third_party/rust_crates"
)
CROS_WORKON_LOCALNAME=(
	"../platform2"
	"../aosp/system/bt/upstream"
	"../aosp/frameworks/proto_logging"
	"../third_party/rust_crates"
)
CROS_WORKON_DESTDIR=(
	"${S}/platform2"
	"${S}/platform2/bt"
	"${S}/platform2/external/proto_logging"
	"${S}/platform2/external/rust"
)
CROS_WORKON_SUBTREE=("common-mk .gn" "" "" "")
CROS_WORKON_EGIT_BRANCH=("main" "main" "master" "main")
CROS_WORKON_INCREMENTAL_BUILD=1

PLATFORM_SUBDIR="bt"

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
IUSE="bt_dynlib"

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
		# Build tools and move to host directory
		mkdir -p "$(cros-workon_get_build_dir)/${CBUILD}"
		tc-env_build platform "configure" "--host"
		tc-env_build platform "compile" "tools" "--host"
		mv "$(cros-workon_get_build_dir)/out" "$(cros-workon_get_build_dir)/${CBUILD}/"
	fi

	local cxx_outdir="$(cros-workon_get_build_dir)/out/Default"
	local rustflags=(
		# Add C/C++ build path to linker search path
		"-L ${cxx_outdir}"

		# Also ignore multiple definitions for now (added due to some
		# shared library shenaningans)
		"-C link-arg=-Wl,--allow-multiple-definition"
	)
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
	# Export all build env variables
	tc-export_build_env PKG_CONFIG

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

	# Install tmpfiles
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
	cros-rust_src_test

	# TODO(b/190750167) - Re-enable once we're fully Bazel build
	#local test_bin
	#for test_bin in "${tests[@]}"; do
		#platform_test run "${OUT}/${test_bin}"
	#done
}
