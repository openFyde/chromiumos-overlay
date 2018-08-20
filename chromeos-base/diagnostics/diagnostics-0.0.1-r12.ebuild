# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=6

CROS_WORKON_COMMIT="f609e0d232baf018944fd839d53fd481177138b2"
CROS_WORKON_TREE=("0ffc67db3979effc8c3e1dc09a1b45719ea6814c" "a722a7022ac5f9bd53d763f0510cae0c764f12fa")
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

	# Install seccomp policy file.
	insinto /usr/share/policy
	use seccomp && newins "init/diagnosticsd-seccomp-${ARCH}.policy" \
		diagnosticsd-seccomp.policy

	# Install the init scripts.
	insinto /etc/init
	doins init/diagnosticsd.conf
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
