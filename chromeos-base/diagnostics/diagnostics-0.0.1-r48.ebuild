# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=6

CROS_WORKON_COMMIT="881812bab12fe462752b347ced064cc008681b38"
CROS_WORKON_TREE=("68a853bd6ab2d1bd1ad2689975aae9e9da5ce36a" "d9b6d7e969e8d8c380f24dd781c4a6aaab962da2")
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_SUBTREE="common-mk diagnostics"

PLATFORM_SUBDIR="diagnostics"

inherit cros-workon platform user

DESCRIPTION="Device telemetry and diagnostics for Chrome OS"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/master/diagnostics"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
IUSE="+seccomp"

COMMON_DEPEND="
	chromeos-base/libbrillo:=
	chromeos-base/libmojo
	dev-libs/grpc
	dev-libs/protobuf:=
"
DEPEND="
	${COMMON_DEPEND}
	chromeos-base/system_api
"
RDEPEND="
	${COMMON_DEPEND}
	chromeos-base/minijail
"

pkg_preinst() {
	enewuser diagnostics
	enewgroup diagnostics
}

src_install() {
	dobin "${OUT}/diagnosticsd"
	dobin "${OUT}/diagnostics_processor"

	# Install seccomp policy files.
	insinto /usr/share/policy
	use seccomp && newins "init/diagnosticsd-seccomp-${ARCH}.policy" \
		diagnosticsd-seccomp.policy
	use seccomp && newins "init/diagnostics_processor-seccomp-${ARCH}.policy" \
		diagnostics_processor-seccomp.policy

	# Install D-Bus configuration file.
	insinto /etc/dbus-1/system.d
	doins dbus/org.chromium.Diagnosticsd.conf

	# Install the init scripts.
	insinto /etc/init
	doins init/diagnosticsd.conf
	doins init/diagnostics_processor.conf
}

platform_pkg_test() {
	local tests=(
		diagnosticsd_test
		libgrpc_async_adapter_test
	)

	local test_bin
	for test_bin in "${tests[@]}"; do
		platform_test "run" "${OUT}/${test_bin}"
	done
}
