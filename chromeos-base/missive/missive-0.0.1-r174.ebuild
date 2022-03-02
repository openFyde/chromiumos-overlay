# Copyright 2020 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

CROS_WORKON_COMMIT="f253d9dea38f46cd256f5a9193982628f2b1b5e6"
CROS_WORKON_TREE=("b50e5ebc78fa3b45d6c6ea0ede1aa648d160fb92" "681110dc099a5f8294c98964bbb8d664be4e73b6" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_DESTDIR="${S}/platform2"
CROS_WORKON_SUBTREE="common-mk missive .gn"

PLATFORM_SUBDIR="missive"

inherit cros-workon platform user

DESCRIPTION="Daemon to encrypt, store, and forward reporting events for managed devices."
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/missive/"

LICENSE="BSD-Google"
SLOT=0/0
KEYWORDS="*"
IUSE=""

RDEPEND="
	app-arch/snappy
	chromeos-base/minijail:=
	dev-libs/protobuf:=
"

DEPEND="
	${RDEPEND}
	chromeos-base/system_api:=
"

pkg_preinst() {
	enewuser missived
	enewgroup missived
}

src_install() {
	# Installs the client libraries
	dolib.a "${OUT}/libmissiveclientlib.a"
	dolib.a "${OUT}/libmissiveprotostatus.a"
	dolib.a "${OUT}/libmissiveprotorecordconstants.a"
	dolib.a "${OUT}/libmissiveprotorecord.a"
	dolib.a "${OUT}/libmissiveprotointerface.a"

	# Installs the header files to /usr/include/missive/.
	local header_files=(
		"client/missive_client.h"
		"client/report_queue_configuration.h"
		"client/report_queue_factory.h"
		"client/report_queue.h"
		"util/status.h"
		"util/status_macros.h"
		"util/statusor.h"
	)
	local pd_header_files=(
		"${OUT}/gen/include/missive/proto/record_constants.pb.h"
		"${OUT}/gen/include/missive/proto/record.pb.h"
		"${OUT}/gen/include/missive/proto/status.pb.h"
	)
	local f
	for f in "${header_files[@]}"; do
		insinto "/usr/include/missive/${f%/*}"
		doins "${f}"
	done
	for f in "${pd_header_files[@]}"; do
		insinto "/usr/include/missive/proto"
		doins "${f}"
	done
	insinto "/usr/$(get_libdir)/pkgconfig"
	doins "${OUT}/obj/missive/libmissiveclient.pc"

	# Install binary
	dobin "${OUT}"/missived

	# Install upstart configurations
	insinto /etc/init
	doins init/missived.conf

	# TODO(zatrudo): Generate at end of devleopment before release.
	# Install seccomp policy file.
	#insinto /usr/share/policy
	#newins "seccomp/missived-seccomp-${ARCH}.policy" missived-seccomp.policy

	# Install D-Bus configuration file.
	insinto /etc/dbus-1/system.d
	doins dbus/org.chromium.Missived.conf

	# Install D-Bus service activation configuration.
	insinto /usr/share/dbus-1/system-services
	doins dbus/org.chromium.Missived.service

	# Install rsyslog config.
	# TODO(zatrudo): Determine if logs from this daemon should be redirected.
	#insinto /etc/rsyslog.d
	#doins rsyslog/rsyslog.missived.conf
}

platform_pkg_test() {
	platform_test "run" "${OUT}/missived_testrunner"
}
