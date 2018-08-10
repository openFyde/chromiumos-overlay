# Copyright 2014 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=6

CROS_WORKON_COMMIT="35f3ca6df8747d454c1f3430df5b7788089d5f49"
CROS_WORKON_TREE=("0d933f3b05830583b657e61eed24a84fd3e825ab" "04d4b495498ba79a7cd006b6bc57969e96992ac2")
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_DESTDIR="${S}/platform2"
CROS_WORKON_SUBTREE="common-mk metrics"

PLATFORM_SUBDIR="metrics"

inherit cros-constants cros-workon platform systemd

DESCRIPTION="Metrics aggregation service for Chromium OS"
HOMEPAGE="http://www.chromium.org/"
LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
IUSE="metrics_uploader +passive_metrics systemd"

RDEPEND="
	chromeos-base/libbrillo
	chromeos-base/system_api
	dev-libs/dbus-glib
	dev-libs/protobuf
	sys-apps/rootdev
	"

DEPEND="
	${RDEPEND}
	chromeos-base/session_manager-client
	chromeos-base/vboot_reference
	"

src_install() {
	dobin "${OUT}"/metrics_client

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
	for v in "${LIBCHROME_VERS[@]}"; do
		./platform2_preinstall.sh "${OUT}" "${v}"
		dolib.so "${OUT}/lib/libmetrics-${v}.so"
		doins "${OUT}/lib/libmetrics-${v}.pc"
	done

	insinto /usr/include/metrics
	doins c_metrics_library.h \
		cumulative_metrics.h \
		metrics_library{,_mock}.h \
		persistent_integer.h \
		timer{,_mock}.h

	# Install the protobuf so that autotests can have access to it.
	insinto /usr/include/metrics/proto
	doins uploader/proto/*.proto
}

platform_pkg_test() {
	local tests=(
		cumulative_metrics_test
		metrics_library_test
		$(usex passive_metrics 'metrics_daemon_test' '')
                persistent_integer_test
		timer_test
		upload_service_test
	)

	local test_bin
	for test_bin in "${tests[@]}"; do
		platform_test "run" "${OUT}/${test_bin}"
	done
}
