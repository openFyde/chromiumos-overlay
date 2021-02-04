# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cros-constants libchrome

DESCRIPTION="Packages tools for termina VM containers"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/master/vm_tools"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
IUSE="vm_borealis"

S="${WORKDIR}"

RDEPEND="
	x11-themes/cros-adapta
"
DEPEND="
	chromeos-base/chunnel
	!vm_borealis? ( chromeos-base/sommelier )
	chromeos-base/vm_guest_tools
	vm_borealis? ( chromeos-base/crash-reporter )
	net-libs/grpc:=
	dev-libs/protobuf:=
	!vm_borealis? ( media-libs/mesa )
	!vm_borealis? ( x11-apps/xkbcomp )
	!vm_borealis? ( x11-base/xwayland )
"

src_install() {
	local tools=(
		"/usr/bin/chunnel"
		"/usr/bin/garcon"
		"/usr/bin/guest_service_failure_notifier"
		"/usr/bin/notificationd"
		"/usr/sbin/vshd"
	)
	if use vm_borealis; then
		tools+=(
			"/sbin/init"
			"/sbin/crash_reporter"
			"/usr/bin/vm_syslog"
		)
	else
		tools+=(
			"/usr/bin/sommelier"
			"/usr/bin/wayland_demo"
			"/usr/bin/Xwayland"
			"/usr/bin/x11_demo"
			"/usr/bin/xkbcomp"
		)
	fi
	"${CHROMITE_BIN_DIR}"/lddtree --root="${SYSROOT}" --bindir=/bin \
			--libdir=/lib --generate-wrappers \
			--copy-to-tree="${WORKDIR}"/container_pkg/ \
			"${tools[@]}"

	# These libraries are dlopen()'d so lddtree doesn't know about them.
	local dlopen_libs=(
		"/$(get_libdir)/libnss_compat.so.2" \
		"/$(get_libdir)/libnss_files.so.2" \
		"/$(get_libdir)/libnss_nis.so.2" \
		"/$(get_libdir)/libnss_dns.so.2"
	)
	if ! use vm_borealis; then
		dlopen_libs+=(
			"/usr/$(get_libdir)/dri/i965_dri.so" \
			"/usr/$(get_libdir)/dri/swrast_dri.so" \
			"/usr/$(get_libdir)/dri/virtio_gpu_dri.so" \
			"/usr/$(get_libdir)/libwayland-egl.so.1" \
			"/usr/$(get_libdir)/libEGL.so.1" \
			"/usr/$(get_libdir)/libGLESv2.so.2" \
		)
	fi

	mapfile -t dlopen_libs < <("${CHROMITE_BIN_DIR}"/lddtree --root="${SYSROOT}" --list "${dlopen_libs[@]}")

	cp -aL "${dlopen_libs[@]}" "${WORKDIR}"/container_pkg/lib/

	# These are scripts, so lddtree doesn't like them.
	cp -aL "${SYSROOT}/usr/bin/upgrade_container" "${WORKDIR}/container_pkg/bin"

	insinto /opt/google/cros-containers
	insopts -m0755
	doins -r "${WORKDIR}"/container_pkg/*
}
