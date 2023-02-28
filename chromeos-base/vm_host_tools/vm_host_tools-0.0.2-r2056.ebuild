# Copyright 2017 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="51de882c758cbb9ae92c7ade70469069d0ea6540"
CROS_WORKON_TREE=("0f4044624c1fabe638a8289e62ec74756aa62176" "bad9f4d57787fe1853a9de318f85d3b7c270b53d" "e1f223c8511c80222f764c8768942936a8de01e4" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6" "e1126a7bca529afdbaf1a59f6f0b8bae42321a02" "38f983ae23e512488aa823385f16b0400c88dd03" "9b13cf002efdd9140fd4e6d0d146231f9610a7f3" "a26b0252ca4dd8384cc9ff4aec931dda6a1587c9" "696dbcb4fabc5182d75e7e1739c56bc14cf6e0eb" "83b0d0fca8e6c2d1ae472e9b6590344eb83f0f37" "5852251e47b16a2ea9b67f472edd3fafd95bd90b" "c17d6fbf0fe2a1c9a4c7bc2aa1a805ee80b522d4" "237c59961fc50759f97896875176d26a6937025d" "2e62052dbd21deda32fa208329835508d3d39d5b" "ee7a391100d5bf60f65682988029562ee9c82798" "647b4d5095422df33a76c4ea606af151468792a2" "e7484fcabff8350254feec93c24db8c75bdc4965" "d627d2791ec16eba0c89b461064006b8e1f5d462" "780211c6fe3bcc43023964e6bc852b20a94d7e7e" "a18480f909e2245ab4a53fd0a090f1ffffb59a8f" "17f393726ed123668b98d3adff46d962184a3a18" "7f5002fb7806ceba6257b01c82f882ac3173aa2f" "0f8ac67491f7a52e0de6999644a3797b7fed364c" "d1531884133da981fe6414dbcd67713d10efeef7")
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_INCREMENTAL_BUILD=1

PLATFORM2_PATHS=(
	common-mk
	featured
	metrics
	.gn
	sirenia
	spaced
	libcrossystem

	vm_tools/BUILD.gn
	vm_tools/host
	vm_tools/common

	vm_tools/cicerone
	vm_tools/concierge
	vm_tools/dbus
	vm_tools/init
	vm_tools/maitred/client.cc
	vm_tools/modprobe
	vm_tools/pstore_dump
	vm_tools/seneschal
	vm_tools/syslog
	vm_tools/tmpfiles.d
	vm_tools/udev
	vm_tools/vsh

	# Required by the fuzzer
	vm_tools/OWNERS

	# Required by the vm_concierge
	chromeos-config
)
CROS_WORKON_SUBTREE="${PLATFORM2_PATHS[*]}"

PLATFORM_SUBDIR="vm_tools"

inherit tmpfiles cros-workon platform udev user arc-build-constants

DESCRIPTION="VM host tools for Chrome OS"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/vm_tools"

LICENSE="BSD-Google"
KEYWORDS="*"
# The crosvm-wl-dmabuf and crosvm-virtio-video USE flags
# are used when preprocessing concierge source.
IUSE="+kvm_host +seccomp +crosvm-wl-dmabuf fuzzer wilco +crosvm-virtio-video vulkan libglvnd crosvm_siblings virtgpu_native_context cross_domain_context iioservice vfio_gpu"
REQUIRED_USE="kvm_host"

COMMON_DEPEND="
	app-arch/libarchive:=
	!!chromeos-base/vm_tools
	chromeos-base/chunnel:=
	chromeos-base/chromeos-config-tools:=
	chromeos-base/crosvm:=
	chromeos-base/libcrossystem:=
	>=chromeos-base/metrics-0.0.1-r3152:=
	chromeos-base/minijail:=
	chromeos-base/patchpanel:=
	chromeos-base/patchpanel-client:=
	chromeos-base/spaced
	net-libs/grpc:=
	dev-libs/protobuf:=
	sys-apps/util-linux:=
"

RDEPEND="
	${COMMON_DEPEND}
	dev-rust/s9
"
DEPEND="
	${COMMON_DEPEND}
	chromeos-base/dlcservice-client:=
	chromeos-base/featured:=
	chromeos-base/manatee-client:=
	chromeos-base/shill-client:=
	chromeos-base/system_api:=[fuzzer?]
	chromeos-base/vboot_reference:=
	chromeos-base/vm_protos:=
	fuzzer? ( dev-libs/libprotobuf-mutator:= )
"

get_vmlog_forwarder_start_services() {
	local start_services="starting vm_concierge"
	if use wilco; then
		start_services+=" or starting wilco_dtc_dispatcher"
	fi
	echo "${start_services}"
}

get_vmlog_forwarder_stop_services() {
	local stop_services="stopped vm_concierge"
	if use wilco; then
		stop_services="stopping system-services"
	fi
	echo "${stop_services}"
}

pkg_setup() {
	# Duplicated from the crosvm ebuild. These are necessary here in order
	# to create the daemon-store folder for concierge in src_install().
	enewuser crosvm
	enewgroup crosvm
	enewuser pluginvm
	cros-workon_pkg_setup

	enewuser crosvm-root
	enewgroup crosvm-root
}

src_install() {
	platform_src_install

	dobin "${OUT}"/cicerone_client
	dobin "${OUT}"/concierge_client
	dobin "${OUT}"/maitred_client
	dobin "${OUT}"/seneschal
	dobin "${OUT}"/seneschal_client
	dobin "${OUT}"/vm_cicerone
	dobin "${OUT}"/vm_concierge
	dobin "${OUT}"/vmlog_forwarder
	dobin "${OUT}"/vsh

	if use arcvm; then
		dobin "${OUT}"/vm_pstore_dump
		dobin "${OUT}"/vshd
	fi

	# fuzzer_component_id is unknown/unlisted
	platform_fuzzer_install "${S}"/OWNERS "${OUT}"/cicerone_container_listener_fuzzer
	platform_fuzzer_install "${S}"/OWNERS "${OUT}"/vsh_client_fuzzer

	# Install header for passing USB devices to plugin VMs.
	insinto /usr/include/vm_concierge
	doins concierge/plugin_vm_usb.h

	insinto /etc/init
	doins init/seneschal.conf
	doins init/vm_cicerone.conf
	doins init/vm_concierge.conf

	dotmpfiles tmpfiles.d/*.conf

	# Modify vmlog_forwarder starting and stopping conditions based on USE flags.
	sed \
		"-e s,@dependent_start_services@,$(get_vmlog_forwarder_start_services),"\
		"-e s,@dependent_stop_services@,$(get_vmlog_forwarder_stop_services)," \
		init/vmlog_forwarder.conf.in | newins - vmlog_forwarder.conf

	insinto /etc/dbus-1/system.d
	doins dbus/*.conf

	if use vfio_gpu; then
		insinto /etc/modprobe.d
		doins modprobe/vfio-dgpu.conf

		exeinto /sbin
		doexe modprobe/dgpu.sh
	fi

	insinto /usr/local/vms/etc
	doins init/arcvm_dev.conf

	# TODO(b/159953121): File and steps below should be removed later.
	insinto /etc
	newins init/arcvm_dev.conf_deprecated arcvm_dev.conf

	insinto /usr/share/policy
	if use seccomp; then
		newins "init/vm_cicerone-seccomp-${ARCH}.policy" vm_cicerone-seccomp.policy
	fi

	udev_dorules udev/99-vm.rules

	keepdir /opt/google/vms

	# Create daemon store folder for crosvm and pvm
	local crosvm_store="/etc/daemon-store/crosvm"
	dodir "${crosvm_store}"
	fperms 0750 "${crosvm_store}"
	fowners crosvm:crosvm "${crosvm_store}"

	local pvm_store="/etc/daemon-store/pvm"
	dodir "${pvm_store}"
	fperms 0770 "${pvm_store}"
	fowners pluginvm:crosvm "${pvm_store}"
}

platform_pkg_test() {
	local tests=(
		cicerone_test
		concierge_test
		syslog_forwarder_test
	)
	if use arcvm; then
		tests+=(
			vm_pstore_dump_test
		)
	fi

	# Running a gRPC server under qemu-user causes flake, at least with the
	# combination of gRPC 1.16.1 and qemu 3.0.0. Disable TerminaVmTest.* while
	# running under qemu to avoid triggering this flake.
	# TODO(crbug.com/1066425): Reenable gRPC server tests under qemu-user.
	local qemu_gtest_filter="-TerminaVmTest.*"
	local test_bin
	for test_bin in "${tests[@]}"; do
		platform_test "run" "${OUT}/${test_bin}" "0" "" "${qemu_gtest_filter}"
	done
}

pkg_preinst() {
	# We need the syslog user and group for both host and guest builds.
	enewuser syslog
	enewgroup syslog

	enewuser vm_cicerone
	enewgroup vm_cicerone

	enewuser seneschal
	enewgroup seneschal
	enewuser seneschal-dbus
	enewgroup seneschal-dbus

	enewuser pluginvm
	enewgroup pluginvm

	enewgroup virtaccess
}
