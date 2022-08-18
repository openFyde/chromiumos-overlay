# Copyright 2021 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

CROS_WORKON_COMMIT=("37e35ce12af9ed07d02b1f5640dd4619e4eec0b8" "e8c383dd94699ff14ab54f69ed44031125ccb401" "3b1cc03fd65dc8297f57ec40e2aa430b63ae3710" "68b356f2e7a8c6103eff9662d1d37d52a0f49305" "d4ff050ca5eaa354ec23814d77e4aabc9b53287f")
CROS_WORKON_TREE=("8f3a3aa2f657ddc8988991dbc99fe65da4f8c81c" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb" "2f525dea60494222ec0656830851b10cf11f3134" "e6a03b6525c113c7aac9a51fee69e65870992ba9" "c3473ab29243f136628d4c8708ab647c15f6a411" "f71b75534c69f14793eed21c434df87a8fee528d")
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
HOMEPAGE="https://android.googlesource.com/platform/packages/modules/Bluetooth"

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
	chromeos-base/metrics:=
	chromeos-base/system_api:=
	dev-libs/flatbuffers:=
	dev-libs/modp_b64:=
	dev-libs/tinyxml2:=
	dev-libs/openssl:=
	=dev-rust/cc-1*:=
	net-wireless/bluez
"

BDEPEND="
	dev-libs/tinyxml2:=
	net-wireless/floss_tools
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
	export TARGET_OS_VARIANT="chromeos"

	cros-rust_src_configure
	platform_src_configure "--target_os=chromeos"
}

copy_floss_tools() {
	local bin_dir="/usr/bin"
	local rust_dir="${ECARGO_HOME}/bin"
	local cxx_dir="$(cros-workon_get_build_dir)/out/Default"

	mkdir -p "${rust_dir}"
	cp "${bin_dir}/bluetooth_packetgen" "${rust_dir}/"
	cp "${bin_dir}/bluetooth_flatbuffer_bundler" "${rust_dir}/"
	cp "${bin_dir}/bluetooth_packetgen" "${cxx_dir}/"
	cp "${bin_dir}/bluetooth_flatbuffer_bundler" "${cxx_dir}/"
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

	# Some Rust crates may want to depend on C++ build output to determine
	# whether to re-run. Export this directory location so that Rust knows which
	# directory to check C++ output.
	export CXX_OUTDIR="$(cros-workon_get_build_dir)/out/Default"

	# System API location for proto files
	export CROS_SYSTEM_API_ROOT="${SYSROOT}/usr/include/chromeos"

	cros-rust_src_compile
}

src_compile() {
	# Copy the tools required for building the runtime to both the GN
	# directory and the Rust bin directory.
	copy_floss_tools

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

	# Install sysprop config file
	insinto /etc/bluetooth
	doins "${FILESDIR}/sysprops.conf"

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
