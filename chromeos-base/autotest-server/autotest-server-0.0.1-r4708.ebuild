# Copyright (c) 2014 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=4
CROS_WORKON_COMMIT="c8c68b328cbf4dbfdc5210d353c44eae6b2846b2"
CROS_WORKON_TREE="e1cb9827ad37fb1c61b19efd1c48dda9ac1830c9"
CROS_WORKON_PROJECT="chromiumos/third_party/autotest"
CROS_WORKON_LOCALNAME=../third_party/autotest/files

inherit cros-workon cros-constants

DESCRIPTION="Autotest scripts and tools"
HOMEPAGE="http://dev.chromium.org/chromium-os/testing"
SRC_URI=""
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="*"

RDEPEND="
	chromeos-base/autotest-server-deps
	chromeos-base/autotest-web-frontend
	chromeos-base/infra-virtualenv
	chromeos-base/lucifer
	chromeos-base/tast-cmd
	chromeos-base/tast-remote-tests-cros
"

DEPEND=""

AUTOTEST_WORK="${WORKDIR}/autotest-work"
AUTOTEST_BASE="/autotest"

src_prepare() {
	mkdir -p "${AUTOTEST_WORK}"
	cp -fpru "${S}"/* "${AUTOTEST_WORK}/" &>/dev/null
	find "${AUTOTEST_WORK}" -name '*.pyc' -delete

	rm "${AUTOTEST_WORK}"/shadow_config.ini
	# We want to create a symlink here instead.
	rm -rf "${AUTOTEST_WORK}"/logs
}

src_compile() {
	protoc --proto_path "${S}" --python_out="${AUTOTEST_WORK}" "${S}/tko/tko.proto"
	protoc --proto_path "${S}" --python_out="${AUTOTEST_WORK}" "${S}/site_utils/cloud_console.proto"
}

src_configure() {
	cros-workon_src_configure
}

src_install() {
	insinto "${AUTOTEST_BASE}"
	doins -r "${AUTOTEST_WORK}"/*
	chmod a+x "${D}/${AUTOTEST_BASE}"/tko/*.cgi

	dosym /var/log/autotest "${AUTOTEST_BASE}"/logs

	insinto /etc/init
	doins "${FILESDIR}"/*.conf
}

src_test() {
	# Run the autotest unit tests.
	./utils/unittest_suite.py --debug || die "Autotest unit tests failed."
}
