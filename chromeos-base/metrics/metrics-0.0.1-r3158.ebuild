# Copyright 2014 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="b19724e757f3e322222ba317309e04305824c4ba"
CROS_WORKON_TREE=("1c07dc76ec4881aeccc6c6151786dc26bf5f73c0" "2834854981f88e2b81fefd49c590185a31f2b1f1" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_DESTDIR="${S}/platform2"
CROS_WORKON_SUBTREE="common-mk metrics .gn"

PLATFORM_SUBDIR="metrics"

inherit cros-constants cros-workon libchrome-version platform systemd user

DESCRIPTION="Metrics aggregation service for Chromium OS"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/master/metrics/"
LICENSE="BSD-Google"
KEYWORDS="*"
IUSE="fuzzer metrics_uploader +passive_metrics systemd"

COMMON_DEPEND="
	dev-libs/dbus-glib:=
	dev-libs/libpcre:=
	dev-libs/protobuf:=
	sys-apps/rootdev:=
	"

RDEPEND="${COMMON_DEPEND}"
DEPEND="
	${COMMON_DEPEND}
	chromeos-base/session_manager-client:=
	chromeos-base/system_api:=[fuzzer?]
	chromeos-base/vboot_reference:=
	"

src_install() {
	dobin "${OUT}"/metrics_client
	dobin "${OUT}"/chromeos-pgmem

	if use passive_metrics; then
		dobin "${OUT}"/metrics_daemon
		if use systemd; then
			systemd_dounit init/metrics-daemon.service
			systemd_enable_service multi-user.target metrics-daemon.service
			systemd_dotmpfilesd init/metrics.conf
		else
			insinto /etc/init
			doins init/metrics_library.conf init/metrics_daemon.conf
		fi

		if use metrics_uploader; then
			if use systemd; then
				sed -i '/ExecStart=/s:metrics_daemon:metrics_daemon -uploader:' \
					"${D}"/usr/lib/systemd/system/metrics-daemon.service || die
			else
				sed -i '/DAEMON_FLAGS=/s:=.*:="-uploader":' \
					"${D}"/etc/init/metrics_daemon.conf || die
			fi
		fi
	fi

	insinto /usr/$(get_libdir)/pkgconfig
	local v="$(libchrome_ver)"
	./platform2_preinstall.sh "${OUT}" "${v}"
	dolib.so "${OUT}/lib/libmetrics.so"
	doins "${OUT}/lib/libmetrics.pc"

	# TODO(crbug/920513): Remove after all usages of libmetrics-$v are removed.
	# For packages using libmetrics-$v.pc.
	doins "${OUT}/lib/libmetrics-${v}.pc"

	insinto /usr/include/metrics
	doins c_metrics_library.h \
		cumulative_metrics.h \
		metrics_library{,_mock}.h \
		persistent_integer.h \
		timer{,_mock}.h

	# Install the protobuf so that autotests can have access to it.
	insinto /usr/include/metrics/proto
	doins uploader/proto/*.proto

	platform_fuzzer_install "${S}"/OWNERS "${OUT}"/metrics_library_consent_id_fuzzer
	platform_fuzzer_install "${S}"/OWNERS \
		"${OUT}"/metrics_serialization_utils_fuzzer
}

platform_pkg_test() {
	# Disable asan container overflow checks that is coming from gtest,
	# not metrics code, https://crbug.com/1067977 .
	export ASAN_OPTIONS+=":detect_container_overflow=0:"
	local tests=(
		cumulative_metrics_test
		metrics_library_test
		$(usex passive_metrics 'metrics_daemon_test' '')
		persistent_integer_test
		process_meter_test
		timer_test
		upload_service_test
	)

	local test_bin
	for test_bin in "${tests[@]}"; do
		platform_test "run" "${OUT}/${test_bin}"
	done
}

pkg_preinst() {
	enewuser metrics
	enewgroup metrics
}
