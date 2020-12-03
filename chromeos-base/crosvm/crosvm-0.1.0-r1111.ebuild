# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="add16addf40a4af44ece66a108b4d10c25aecae5"
CROS_WORKON_TREE="cbc11dc698972921877693314d1ee33b611c850f"
CROS_WORKON_PROJECT="chromiumos/platform/crosvm"
CROS_WORKON_LOCALNAME="platform/crosvm"
CROS_WORKON_INCREMENTAL_BUILD=1
# We don't use CROS_WORKON_OUTOFTREE_BUILD here since crosvm/Cargo.toml is
# using "# ignored by ebuild" macro which supported by cros-rust.

inherit cros-fuzzer cros-rust cros-workon user

KERNEL_PREBUILT_DATE="2019_10_10_00_22"

DESCRIPTION="Utility for running VMs on Chrome OS"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform/crosvm/"
SRC_URI="test? ( https://storage.googleapis.com/crosvm-testing/x86_64/${KERNEL_PREBUILT_DATE}/bzImage -> crosvm-bzImage-${KERNEL_PREBUILT_DATE} )"

LICENSE="BSD-Google"
KEYWORDS="*"
IUSE="test cros-debug crosvm-gpu -crosvm-plugin +crosvm-power-monitor-powerd +crosvm-video-decoder +crosvm-video-encoder +crosvm-wl-dmabuf fuzzer tpm2 arcvm_gce_l1"

COMMON_DEPEND="
	sys-apps/dtc:=
	sys-libs/libcap:=
	chromeos-base/libvda:=
	chromeos-base/minijail:=
	crosvm-gpu? (
		dev-libs/wayland:=
		media-libs/virglrenderer:=
	)
	crosvm-wl-dmabuf? ( media-libs/minigbm:= )
	dev-rust/libchromeos:=
	virtual/libusb:1=
"

RDEPEND="${COMMON_DEPEND}
	!chromeos-base/crosvm-bin
"

DEPEND="${COMMON_DEPEND}
	=dev-rust/android_log-sys-0.2*:=
	>=dev-rust/anyhow-1.0.32:= <dev-rust/anyhow-2.0
	=dev-rust/async-trait-0.1*:=
	fuzzer? (
		dev-rust/cros_fuzz:=
		=dev-rust/rand-0.6*:=
	)
	=dev-rust/bitflags-1*:=
	~dev-rust/cc-1.0.25:=
	>=dev-rust/downcast-rs-1.2.0:= <dev-rust/downcast-rs-2.0
	=dev-rust/futures-0.3*:=
	=dev-rust/gdbstub-0.4*:=
	~dev-rust/getopts-0.2.18:=
	>=dev-rust/libc-0.2.44:= <dev-rust/libc-0.3.0
	dev-rust/libvda:=
	dev-rust/minijail:=
	~dev-rust/num_cpus-1.9.0:=
	dev-rust/p9:=
	=dev-rust/paste-1*:=
	=dev-rust/pin-utils-0.1*:=
	~dev-rust/pkg-config-0.3.11:=
	=dev-rust/proc-macro2-1*:=
	>=dev-rust/protobuf-2.8:=
	!>=dev-rust/protobuf-3
	>=dev-rust/protoc-rust-2.8:=
	!>=dev-rust/protoc-rust-3
	=dev-rust/quote-1*:=
	=dev-rust/syn-1*:=
	>=dev-rust/thiserror-1.0.20:= <dev-rust/thiserror-2.0
	dev-rust/trace_events:=
	dev-rust/remain:=
	tpm2? (
		chromeos-base/tpm2:=
		chromeos-base/trunks:=
		=dev-rust/dbus-0.6*:=
	)
	media-sound/audio_streams:=
	media-sound/libcras:=
	crosvm-power-monitor-powerd? (
		chromeos-base/system_api
		=dev-rust/dbus-0.6*:=
	)
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
	crosvm_fs_server_fuzzer
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

src_prepare() {
	cros-rust_src_prepare

	if use arcvm_gce_l1; then
		eapply "${FILESDIR}"/0001-betty-arcvm-Loose-mprotect-mmap-for-software-renderi.patch
	fi

	default
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
		$(usex crosvm-gpu virtio-gpu-next "")
		$(usex crosvm-plugin plugin "")
		$(usex crosvm-power-monitor-powerd power-monitor-powerd "")
		$(usex crosvm-video-decoder video-decoder "")
		$(usex crosvm-video-encoder video-encoder "")
		$(usex crosvm-wl-dmabuf wl-dmabuf "")
		$(usex tpm2 tpm "")
		$(usex cros-debug gdb "")
		chromeos
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
	local test_opts=()
	use tpm2 || test_opts+=( --exclude tpm2 --exclude tpm2-sys )

	# io_jail tests fork the process, which cause memory leak errors when
	# run under sanitizers.
	cros-rust_use_sanitizers && test_opts+=( --exclude io_jail )

	export CROSVM_CARGO_TEST_KERNEL_BINARY="${DISTDIR}/crosvm-bzImage-${KERNEL_PREBUILT_DATE}"
	[[ -e "${CROSVM_CARGO_TEST_KERNEL_BINARY}" ]] || \
		die "expected to find kernel binary at ${CROSVM_CARGO_TEST_KERNEL_BINARY}"

	local skip_tests=()
	# The memfd_create() system call first appeared in Linux 3.17.  Skip
	# the boot test, which relies on this functionality, on older kernels.
	local cut_version=$(ver_cut 1-2 "$(uname -r)")
	if ver_test 3.17 -gt "${cut_version}"; then
		skip_tests+=( --skip "boot" )
	fi

	if ! use x86 && ! use amd64; then
		test_opts+=( --exclude "x86_64" )
		test_opts+=( --no-run )
	fi

	if ! use arm64; then
		test_opts+=( --exclude "aarch64" )
	fi

	if ! use crosvm-plugin; then
		test_opts+=( --exclude "crosvm_plugin" )
	fi

	# Excluding tests that run on a different arch, use /dev/dri,
	# /dev/net/tun, or wayland access because the bots don't support these.
	# Also exclude sys_util since they already run as part of the
	# dev-rust/sys_util package.
	ecargo_test --all -v \
		--exclude net_util \
		--exclude gpu_buffer \
		--exclude gpu_display \
		--exclude gpu_renderer \
		--exclude sys_util \
		"${test_opts[@]}" \
		-- --test-threads=1 \
		"${skip_tests[@]}" \
		|| die "cargo test failed"

	# Plugin tests all require /dev/kvm, but we want to make sure they build
	# at least.
	if use crosvm-plugin; then
		ecargo_test --no-run --features plugin \
			|| die "cargo build with plugin feature failed"
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
		local policy
		for policy in "${seccomp_path}"/*.policy; do
			sed -i "s:/usr/share/policy/crosvm:${seccomp_path}:g" "${policy}" \
				|| die "failed to modify seccomp policy ${policy}"
		done
		for policy in "${seccomp_path}"/*.policy; do
			local policy_output="${policy%.policy}.bpf"
			compile_seccomp_policy \
				--arch-json "${SYSROOT}/build/share/constants.json" \
				--default-action trap "${policy}" "${policy_output}" \
				|| die "failed to compile seccomp policy ${policy}"
		done
		rm "${seccomp_path}"/common_device.bpf
		insinto /usr/share/policy/crosvm
		doins "${seccomp_path}"/*.bpf
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
