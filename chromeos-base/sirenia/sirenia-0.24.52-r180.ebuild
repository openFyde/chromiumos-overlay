# Copyright 2020 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="616c714e61ce48380286b52f0cea7d465a68ef4d"
CROS_WORKON_TREE="ba2a65e5030f6074a2c2504f705958d51219d63f"
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_SUBTREE="sirenia"

inherit cros-workon cros-rust user

DESCRIPTION="The runtime environment and middleware for ManaTEE."
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/sirenia/"

LICENSE="BSD-Google"
KEYWORDS="*"
IUSE="cros_host manatee sirenia"

DEPEND="
	dev-rust/third-party-crates-src:=
	chromeos-base/crosvm-base:=
	chromeos-base/libsirenia:=
	dev-libs/openssl:0=
	dev-rust/balloon_control:=
	dev-rust/chromeos-dbus-bindings:=
	dev-rust/data_model:=
	=dev-rust/dbus-0.9*
	=dev-rust/dbus-crossroads-0.5*
	=dev-rust/flexbuffers-2*
	dev-rust/libchromeos:=
	=dev-rust/serde_json-1*
"
# (crbug.com/1182669): build-time only deps need to be in RDEPEND so they are pulled in when
# installing binpkgs since the full source tree is required to use the crate.
RDEPEND="${DEPEND}
	chromeos-base/cronista
	chromeos-base/manatee-runtime
	dev-rust/manatee-client
	sys-apps/dbus
"
BDEPEND="chromeos-base/sirenia-tools"

# Don't support USE=manatee on the host.
REQUIRED_USE="cros_host? ( !manatee )"

src_install() {
	local build_dir="$(cros-rust_get_build_dir)"
	dobin "${build_dir}/dugong"

	insinto /etc/dbus-1/system.d
	doins dbus/org.chromium.ManaTEE.conf

	insinto /etc/rsyslog.d
	doins rsyslog/rsyslog.manatee.conf

	insinto /usr/lib/tmpfiles.d
	doins tmpfiles.d/*.conf

	# In USE=sirenia, install trichichus and manatee_memory_service in the
	# root filesystem.
	if use sirenia; then
		dobin "${build_dir}/trichechus"
		dobin "${build_dir}/manatee_crash_handler"
		dobin "${build_dir}/manatee_memory_service"
	fi

	# In USE=manatee builds, install trichichus and manatee_memory_service
	# into the hypervisor's initramfs.
	if use manatee ;  then
		# Start dugong with the system.
		insinto /etc/init
		doins upstart/dugong.conf

		# Install binaries in the initramfs.
		exeinto "/build/initramfs"
		doexe "${build_dir}/trichechus"
		doexe "${build_dir}/manatee_crash_handler"
		doexe "${build_dir}/manatee_memory_service"
	fi
}

pkg_setup() {
	enewuser dugong
	enewgroup dugong
	cros-rust_pkg_setup
}
