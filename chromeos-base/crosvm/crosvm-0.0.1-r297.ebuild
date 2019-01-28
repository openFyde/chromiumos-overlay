# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=6
CROS_WORKON_COMMIT="4133b0120d1e16cafbb373b2ae17a214b594038b"
CROS_WORKON_TREE="177506988846e4b86e639cdb963bbaba0c4e6ca9"
CROS_WORKON_PROJECT="chromiumos/platform/crosvm"
CROS_WORKON_LOCALNAME="../platform/crosvm"
CROS_WORKON_INCREMENTAL_BUILD=1
# We don't use CROS_WORKON_OUTOFTREE_BUILD here since crosvm/Cargo.toml is
# using "# ignored by ebuild" macro which supported by cros-rust.

inherit cros-rust cros-workon toolchain-funcs user

DESCRIPTION="Utility for running Linux VMs on Chrome OS"

LICENSE="BSD-Google BSD-2 Apache-2.0 MIT"
SLOT="0"
KEYWORDS="*"
IUSE="test cros-debug crosvm-gpu -crosvm-plugin +crosvm-wl-dmabuf"

RDEPEND="
	sys-apps/dtc
	!chromeos-base/crosvm-bin
	chromeos-base/minijail
	crosvm-gpu? (
		dev-libs/wayland
		media-libs/virglrenderer
	)
	crosvm-wl-dmabuf? ( media-libs/minigbm )
"
DEPEND="${RDEPEND}
	~dev-rust/byteorder-1.1.0:=
	~dev-rust/cc-1.0.25:=
	~dev-rust/getopts-0.2.18:=
	~dev-rust/libc-0.2.44:=
	~dev-rust/num_cpus-1.9.0:=
	~dev-rust/pkg-config-0.3.11:=
	~dev-rust/protoc-rust-1.4.3:=
	~dev-rust/protobuf-1.4.3:=
	~dev-rust/proc-macro2-0.4.21:=
	~dev-rust/quote-0.6.10:=
	~dev-rust/syn-0.15.21:=
	media-sound/audio_streams:=
	media-sound/libcras:=
"

src_unpack() {
	# Unpack both the project and dependency source code
	cros-workon_src_unpack
	cros-rust_src_unpack
}

src_compile() {
	local features=(
		$(usex crosvm-gpu gpu "")
		$(usex crosvm-plugin plugin "")
		$(usex crosvm-wl-dmabuf wl-dmabuf "")
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

}

src_test() {
	export RUST_BACKTRACE=1

	if ! use x86 && ! use amd64 ; then
		elog "Skipping unit tests on non-x86 platform"
	else
		# Exluding tests that need memfd_create, /dev/kvm, /dev/dri, libtpm2, or
		# wayland access because the bots don't support these.
		ecargo_test --all \
			--exclude kvm \
			--exclude kvm_sys \
			--exclude net_util -v \
			--exclude qcow \
			--exclude aarch64 \
			--exclude gpu_buffer \
			--exclude gpu_display \
			--exclude gpu_renderer \
			--exclude tpm2 \
			--exclude tpm2-sys \
			-- --test-threads=1 \
			|| die "cargo test failed"
		# Plugin tests all require /dev/kvm, but we want to make sure they build
		# at least.
		ecargo_test --no-run --features plugin \
			|| die "cargo build with plugin feature failed"
	fi
}

src_install() {
	local seccomp_arch="unknown"
	case ${ARCH} in
		amd64) seccomp_arch=x86_64;;
		arm) seccomp_arch=arm;;
		arm64) seccomp_arch=aarch64;;
	esac

	# cargo doesn't know how to install cross-compiled binaries.  It will
	# always install native binaries for the host system.  Manually install
	# crosvm instead.
	local build_dir="${WORKDIR}/${CHOST}/$(usex cros-debug debug release)"
	dobin "${build_dir}/crosvm"

	# Install seccomp policy files.
	local seccomp_path="${S}/seccomp/${seccomp_arch}"
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
}

pkg_preinst() {
	enewuser "crosvm"
	enewgroup "crosvm"
}
