# Copyright 2014 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="d92347efe59230c8b44ecd3213d8c53fd3a4ba43"
CROS_WORKON_TREE=("d12eaa6a060046041408b6cf0c2444c7da2bce2b" "8d856cb1fd8b7169075c5ae9c9a1ed9d4b8cbd6b" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_DESTDIR="${S}/platform2"
CROS_WORKON_SUBTREE="common-mk metrics .gn"

PLATFORM_SUBDIR="metrics"

inherit cros-constants cros-workon platform tmpfiles systemd user

DESCRIPTION="Metrics aggregation service for Chromium OS"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/metrics/"
LICENSE="BSD-Google"
KEYWORDS="*"
IUSE="fuzzer metrics_uploader +passive_metrics systemd"

COMMON_DEPEND="
	dev-libs/protobuf:=
	dev-libs/re2:=
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
	platform_src_install

	dobin "${OUT}"/metrics_client
	dobin "${OUT}"/chromeos-pgmem

	if use passive_metrics; then
		dobin "${OUT}"/metrics_daemon
		if use systemd; then
			systemd_dounit init/metrics-daemon.service
			systemd_enable_service multi-user.target metrics-daemon.service
			systemd_dotmpfilesd init/metrics.conf
		else
			dotmpfiles tmpfiles.d/metrics_daemon_dirs.conf
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

	local daemon_store="/etc/daemon-store/uma-consent"
	dodir "${daemon_store}"
	fperms 0774 "${daemon_store}"
	fowners chronos:chronos-access "${daemon_store}"

	local appsync_daemon_store="/etc/daemon-store/appsync-consent"
	dodir "${appsync_daemon_store}"
	fperms 0774 "${appsync_daemon_store}"
	fowners chronos:chronos-access "${appsync_daemon_store}"

	insinto "/usr/$(get_libdir)/pkgconfig"
	dolib.so "${OUT}/lib/libmetrics.so"
	doins "${S}/libmetrics.pc"
	dolib.so "${OUT}/lib/libstructuredmetrics.so"
	doins "${OUT}"/obj/metrics/structured/libstructuredmetrics.pc

	dotmpfiles tmpfiles.d/structured_metrics.conf

	insinto /usr/include/metrics
	doins c_metrics_library.h \
		cumulative_metrics.h \
		metrics_library{,_mock}.h \
		persistent_integer.h \
		structured/c_structured_metrics.h \
		timer{,_mock}.h \
		"${OUT}"/gen/include/metrics/structured/structured_events.h

	insinto /usr/include/metrics/structured
	doins structured/event_base.h

	insinto /usr/include/metrics/structured/proto
	doins "${OUT}"/gen/include/metrics/structured/proto/storage.pb.h \
		"${OUT}"/gen/include/metrics/structured/proto/structured_data.pb.h

	# Install the protobuf so that autotests can have access to it.
	insinto /usr/include/metrics/proto
	doins uploader/proto/*.proto

	local fuzzer_component_id="1087262"
	platform_fuzzer_install "${S}"/OWNERS "${OUT}"/metrics_library_consent_id_fuzzer \
		--comp "${fuzzer_component_id}"
	platform_fuzzer_install "${S}"/OWNERS \
		"${OUT}"/metrics_serialization_utils_fuzzer \
		--comp "${fuzzer_component_id}"
}

platform_pkg_test() {
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
