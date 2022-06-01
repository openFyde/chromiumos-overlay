# Copyright 2014 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="200d966b5647a49ca460c18763fad1bceb447366"
CROS_WORKON_TREE=("d4469c62dab4018d72e6355d285651f2780df211" "7226e3910790963c0810793db376ae53c9a32be5" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_DESTDIR="${S}/platform2"
CROS_WORKON_SUBTREE="common-mk metrics .gn"

PLATFORM_SUBDIR="metrics"

inherit cros-constants cros-workon libchrome-version platform tmpfiles systemd user

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

	insinto "/usr/$(get_libdir)/pkgconfig"
	local v="$(libchrome_ver)"
	./platform2_preinstall.sh "${OUT}" "${v}"
	dolib.so "${OUT}/lib/libmetrics.so"
	doins "${OUT}/lib/libmetrics.pc"
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
