# Copyright 2020 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

CROS_WORKON_COMMIT="24101da4546e27854dcaee17995d037a6d6b75f2"
CROS_WORKON_TREE=("ebcce78502266e81f55c63ade8f25b8888e2c103" "081284d960056b9a056cae0778b443bbe8b639b0" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_DESTDIR="${S}/platform2"
CROS_WORKON_SUBTREE="common-mk missive .gn"

PLATFORM_SUBDIR="missive"

inherit cros-workon platform tmpfiles user

DESCRIPTION="Daemon to encrypt, store, and forward reporting events for managed devices."
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/missive/"

LICENSE="BSD-Google"
SLOT=0/0
KEYWORDS="*"
IUSE=""

RDEPEND="
	app-arch/snappy
	chromeos-base/metrics:=
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
	enewgroup missived_senders
}

src_install() {
	# Installs the client libraries
	dolib.a "${OUT}/libmissiveclientlib.a"
	dolib.a "${OUT}/libmissiveprotohealth.a"
	dolib.a "${OUT}/libmissiveprotointerface.a"
	dolib.a "${OUT}/libmissiveprotorecord.a"
	dolib.a "${OUT}/libmissiveprotorecordconstants.a"
	dolib.a "${OUT}/libmissiveprotosecurityxdrevents.a"
	dolib.a "${OUT}/libmissiveprotostatus.a"
	dolib.a "${OUT}/libmissiveclienttestlib.a"

	# Installs the header files to /usr/include/missive/.
	local header_files=(
		"client/missive_client.h"
		"client/report_queue_configuration.h"
		"client/report_queue_factory.h"
		"client/report_queue.h"
		"client/report_queue_provider.h"
		"client/mock_dm_token_retriever.h"
		"client/mock_report_queue.h"
		"client/mock_report_queue_provider.h"
		"client/report_queue_provider_test_helper.h"
		"storage/storage_module_interface.h"
		"util/status.h"
		"util/status_macros.h"
		"util/statusor.h"
	)
	local pd_header_files=(
		"${OUT}/gen/include/missive/proto/health.pb.h"
		"${OUT}/gen/include/missive/proto/record.pb.h"
		"${OUT}/gen/include/missive/proto/record_constants.pb.h"
		"${OUT}/gen/include/missive/proto/security_xdr_events.pb.h"
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

	# Install tmpfiles
	dotmpfiles tmpfiles.d/missived.conf

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
