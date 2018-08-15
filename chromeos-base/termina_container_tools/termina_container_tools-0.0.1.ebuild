# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cros-constants libchrome

DESCRIPTION="Packages tools for termina VM containers"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/master/vm_tools"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
IUSE=""

S="${WORKDIR}"

RDEPEND="
	x11-themes/cros-adapta
"
DEPEND="
	chromeos-base/vm_guest_tools
	dev-libs/grpc
	dev-libs/protobuf:=
	media-libs/mesa
	x11-apps/xkbcomp
	x11-base/xwayland
"

src_install() {
	"${CHROMITE_BIN_DIR}"/lddtree --root="${SYSROOT}" --bindir=/bin \
			--libdir=/lib --generate-wrappers \
			--copy-to-tree="${WORKDIR}"/container_pkg/ \
			/usr/bin/garcon \
			/usr/bin/notificationd \
			/usr/bin/sommelier \
			/usr/bin/wayland_demo \
			/usr/bin/Xwayland \
			/usr/bin/x11_demo \
			/usr/bin/xkbcomp \
			/usr/sbin/vshd

	# These libraries are dlopen()'d so lddtree doesn't know about them.
	local dlopen_libs=(
		$("${CHROMITE_BIN_DIR}"/lddtree --root="${SYSROOT}" --list \
			"/usr/$(get_libdir)/dri/swrast_dri.so" \
			"/usr/$(get_libdir)/dri/virtio_gpu_dri.so" \
			"/usr/$(get_libdir)/libwayland-egl.so.1" \
			"/usr/$(get_libdir)/libEGL.so.1" \
			"/usr/$(get_libdir)/libGLESv2.so.2" \
			"/$(get_libdir)/libnss_compat.so.2" \
			"/$(get_libdir)/libnss_files.so.2" \
			"/$(get_libdir)/libnss_nis.so.2"
		)
	)
	cp -aL "${dlopen_libs[@]}" "${WORKDIR}"/container_pkg/lib/

	insinto /opt/google/cros-containers
	insopts -m0755
	doins -r "${WORKDIR}"/container_pkg/*
}
