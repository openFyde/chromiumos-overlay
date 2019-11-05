# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=6
CROS_WORKON_PROJECT="chromiumos/platform/crosvm"
CROS_WORKON_LOCALNAME="../platform/crosvm"
CROS_WORKON_INCREMENTAL_BUILD=1
# We don't use CROS_WORKON_OUTOFTREE_BUILD here since crosvm/Cargo.toml is
# using "# ignored by ebuild" macro which supported by cros-rust.

inherit cros-fuzzer cros-rust cros-workon toolchain-funcs user

KERNEL_PREBUILT_DATE="2019_10_10_00_22"

DESCRIPTION="Utility for running VMs on Chrome OS"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform/crosvm/"
SRC_URI="test? ( https://storage.googleapis.com/crosvm-testing/x86_64/${KERNEL_PREBUILT_DATE}/bzImage -> crosvm-bzImage-${KERNEL_PREBUILT_DATE} )"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="~*"
IUSE="test cros-debug crosvm-gpu -crosvm-plugin +crosvm-wl-dmabuf
	crosvm-gpu-forward fuzzer tpm2"

RDEPEND="
	sys-apps/dtc
	sys-libs/libcap:=
	!chromeos-base/crosvm-bin
	chromeos-base/minijail
	crosvm-gpu? (
		dev-libs/wayland
		media-libs/virglrenderer
	)
	crosvm-wl-dmabuf? ( media-libs/minigbm )
	virtual/libusb:1=
"
DEPEND="${RDEPEND}
	fuzzer? (
		dev-rust/cros_fuzz:=
		=dev-rust/rand-0.6*:=
	)
	=dev-rust/bitflags-1*:=
	~dev-rust/cc-1.0.25:=
	~dev-rust/getopts-0.2.18:=
	>=dev-rust/libc-0.2.44:= <dev-rust/libc-0.3.0
	~dev-rust/num_cpus-1.9.0:=
	~dev-rust/pkg-config-0.3.11:=
	~dev-rust/proc-macro2-0.4.21:=
	>=dev-rust/protobuf-2.8:=
	!>=dev-rust/protobuf-3
	>=dev-rust/protoc-rust-2.8:=
	!>=dev-rust/protoc-rust-3
	~dev-rust/quote-0.6.10:=
	dev-rust/trace_events:=
	dev-rust/remain:=
	=dev-rust/syn-0.15*:=
	crosvm-gpu-forward? ( chromeos-base/rendernodehost:= )
	tpm2? (
		chromeos-base/tpm2:=
		chromeos-base/trunks:=
		=dev-rust/dbus-0.6*:=
	)
	media-sound/audio_streams:=
	media-sound/libcras:=
"

get_seccomp_path() {
	local seccomp_arch="unknown"
	case ${ARCH} in
		amd64) seccomp_arch=x86_64;;
		arm) seccomp_arch=arm;;
		arm64) seccomp_arch=aarch64;;
	esac

	echo "seccomp/${seccomp_arch}"
}

FUZZERS=(
	crosvm_block_fuzzer
	crosvm_qcow_fuzzer
	crosvm_usb_descriptor_fuzzer
	crosvm_virtqueue_fuzzer
	crosvm_zimage_fuzzer
)

src_unpack() {
	# Unpack both the project and dependency source code
	cros-workon_src_unpack
	cros-rust_src_unpack
}

src_configure() {
	cros-rust_src_configure

	# Change the path used for the minijail pivot root from /var/empty.
	# See: https://crbug.com/934513
	export DEFAULT_PIVOT_ROOT="/mnt/empty"
}

src_compile() {
	local features=(
		$(usex crosvm-gpu gpu "")
		$(usex crosvm-plugin plugin "")
		$(usex crosvm-wl-dmabuf wl-dmabuf "")
		$(usex tpm2 tpm "")
		$(usex crosvm-gpu-forward gpu-forward "")
	)

	local packages=(
		qcow_utils
		crosvm
	)

	for pkg in "${packages[@]}"; do
		ecargo_build -v \
			--features="${features[*]}" \
			-p "${pkg}" \
			|| die "cargo build failed"
	done

	if use fuzzer; then
		cd fuzz
		local f
		for f in "${FUZZERS[@]}"; do
			ecargo_build_fuzzer --bin "${f}"
		done
	fi
}

src_test() {
	# Some of the tests will use /dev/kvm.
	addwrite /dev/kvm
	if ! use x86 && ! use amd64 ; then
		elog "Skipping unit tests on non-x86 platform"
	else
		# The parse_seccomp_policy file that is installed in the chroot can only
		# be used to check x86 seccomp policies.
		local seccomp_path="$(get_seccomp_path)"
		local policy
		for policy in "${seccomp_path}"/*.policy; do
			sed "s:/usr/share/policy/crosvm:./${seccomp_path}:g" "${policy}" \
				| parse_seccomp_policy >/dev/null \
				|| die "failed to compile seccomp policy ${policy}"
		done

		local feature_excludes=()
		use tpm2 || feature_excludes+=( --exclude tpm2 --exclude tpm2-sys )
		use crosvm-gpu-forward || feature_excludes+=( --exclude render_node_forward )

		# io_jail tests fork the process, which cause memory leak errors when
		# run under sanitizers.
		cros-rust_use_sanitizers && feature_excludes+=( --exclude io_jail )

		export CROSVM_CARGO_TEST_KERNEL_BINARY="${DISTDIR}/crosvm-bzImage-${KERNEL_PREBUILT_DATE}"
		[[ -e "${CROSVM_CARGO_TEST_KERNEL_BINARY}" ]] || \
			die "expected to find kernel binary at ${CROSVM_CARGO_TEST_KERNEL_BINARY}"

		# Exluding tests that need memfd_create, /dev/kvm, /dev/dri, or wayland
		# access because the bots don't support these.  Also exclude sys_util
		# since they already run as part of the dev-rust/sys_util package.
		ecargo_test --all \
			--exclude kvm \
			--exclude kvm_sys \
			--exclude net_util -v \
			--exclude qcow \
			--exclude aarch64 \
			--exclude gpu_buffer \
			--exclude gpu_display \
			--exclude gpu_renderer \
			--exclude sys_util \
			"${feature_excludes[@]}" \
			-- --test-threads=1 \
			|| die "cargo test failed"

		# Plugin tests all require /dev/kvm, but we want to make sure they build
		# at least.
		if use crosvm-plugin; then
			ecargo_test --no-run --features plugin \
				|| die "cargo build with plugin feature failed"
		fi
	fi
}

src_install() {
	# cargo doesn't know how to install cross-compiled binaries.  It will
	# always install native binaries for the host system.  Manually install
	# crosvm instead.
	local build_dir="$(cros-rust_get_build_dir)"
	dobin "${build_dir}/crosvm"

	# Install seccomp policy files.
	local seccomp_path="${S}/$(get_seccomp_path)"
	if [[ -d "${seccomp_path}" ]] ; then
		insinto /usr/share/policy/crosvm
		doins "${seccomp_path}"/*.policy
	fi

	# Install qcow utils library, header, and pkgconfig files.
	dolib.so "${build_dir}/deps/libqcow_utils.so"

	local include_dir="/usr/include/crosvm"

	"${S}"/qcow_utils/platform2_preinstall.sh "${PV}" "${include_dir}" \
		"${WORKDIR}"
	insinto "/usr/$(get_libdir)/pkgconfig"
	doins "${WORKDIR}/libqcow_utils.pc"

	insinto "${include_dir}"
	doins "${S}"/qcow_utils/src/qcow_utils.h

	# Install plugin library, when requested.
	if use crosvm-plugin ; then
		insinto "${include_dir}"
		doins "${S}/crosvm_plugin/crosvm.h"
		dolib.so "${build_dir}/deps/libcrosvm_plugin.so"
	fi

	if use fuzzer; then
		cd fuzz
		local f
		for f in "${FUZZERS[@]}"; do
			fuzzer_install "${S}/fuzz/OWNERS" \
				"${build_dir}/${f}"
		done
	fi
}

pkg_preinst() {
	enewuser "crosvm"
	enewgroup "crosvm"
}
