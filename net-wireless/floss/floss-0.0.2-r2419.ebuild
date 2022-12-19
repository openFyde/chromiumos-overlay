# Copyright 2021 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

CROS_WORKON_COMMIT=("a03cc84f987e4ae46540c1504e642c1db9ab8c98" "7f79d1828aa7356ee3702911c116f80dab138071" "62c7f2aae431635ca1233abcd9b92ecc3de5485a" "68b356f2e7a8c6103eff9662d1d37d52a0f49305" "c91d5ceba40cd79bdb70d22a207722161fd4f7e5")
CROS_WORKON_TREE=("0c3a30cd50ce72094fbd880f2d16d449139646a2" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6" "be5d9a6127c4aeb6e11901fb220b7ca856970267" "8e7a74c34f188d64f6ff0dafbf84cf17b2074e1e" "c3473ab29243f136628d4c8708ab647c15f6a411" "c35979a15b69734b37fc6ca5e53699ff9d2cd114")
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

inherit cros-workon toolchain-funcs cros-rust platform tmpfiles udev

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
	dev-rust/third-party-crates-src:=
	chromeos-base/metrics:=
	chromeos-base/system_api:=
	dev-libs/flatbuffers:=
	dev-libs/modp_b64:=
	dev-libs/tinyxml2:=
	dev-libs/openssl:=
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

	# TODO(b/261541399) - Limit number of jobs on arm test builds. This
	# specific scenario is causing OOM failures.
	local local_makeopts="${MAKEOPTS}"
	if use test && (use arm || use arm64); then
		local_makeopts="${local_makeopts} --jobs 4"
	fi

	# Cros rust unpack should come after platform unpack otherwise platform
	# unpack will fail.
	MAKEOPTS="${local_makeopts}" cros-rust_src_unpack

	# In order to be compatible with cros-rust.eclass while also using our
	# own vendored crates, we re-use the existing config but add a floss
	# source and replace source.crates-io with it.
	# shellcheck disable=SC2154 # ECARGO_HOME is defined in cros-rust.eclass
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

	# TODO(b/261541399) - Building generated code for arm for unit-tests
	# seems to fail due to OOM issues. Reduce opt-level to reduce memory
	# usage.
	use test && (use arm || use arm64) && rustflags+=( '-C opt-level=0' )

	export EXTRA_RUSTFLAGS="${rustflags[*]}"
	export TARGET_OS_VARIANT="chromeos"

	cros-rust_src_configure
	platform_src_configure "--target_os=chromeos"
}

copy_floss_tools() {
	local bin_dir="/usr/bin"
	# shellcheck disable=SC2154 # ECARGO_HOME is defined in cros-rust.eclass
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
	# shellcheck disable=SC2154 # BUILD_CFLAGS is defined in
	# toolchain-funcs.eclass
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

	# shellcheck disable=SC2154 # CARGO_TARGET_DIR is defined in cros-rust.eclass
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

	# Install sysprop config file and override dir
	insinto /etc/bluetooth
	doins "${FILESDIR}/sysprops.conf"
	keepdir "/etc/bluetooth/sysprops.conf.d"

	# Change permissions so root can write and bluetooth can read
	chown -R root:bluetooth "${ED}"/etc/bluetooth/sysprops.conf.d
	chmod -R 640 "${ED}"/etc/bluetooth/sysprops.conf.d

	# Install tmpfiles (don't forget to update sepolicy if you change the
	# files/folders created to something other than /var/lib/bluetooth)
	dotmpfiles "${FILESDIR}/tmpfiles.d/floss.conf"

	# Install config files
	insinto /etc/bluetooth/
	doins "${FILESDIR}/config/bt_did.conf"
	doins "${FILESDIR}/config/admin_policy.json"

	# Install udev rules
	udev_dorules "${FILESDIR}/udev/99-floss-chown-properties.rules"
}

platform_pkg_test() {
	#local tests=(
		#"bluetoothtbd_test"
		#"bluetooth_test_common"
		#"net_test_avrcp"
		#"net_test_btcore"
		#"net_test_types"
		#"net_test_btm_iso"
		## TODO(b/178740721) - This test wasn't compiling. Need to fix
		## this and re-enable it.
		## "net_test_btpackets"
	#)

	# Run rust tests
	# TODO(b/210127355) - Fix flaky tests and re-enable
	# cros-rust_src_test

	# TODO(b/190750167) - Re-enable once we're fully Bazel build
	#local test_bin
	#for test_bin in "${tests[@]}"; do
		#platform_test run "${OUT}/${test_bin}"
	#done
	:
}
