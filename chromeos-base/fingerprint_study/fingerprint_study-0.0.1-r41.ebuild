# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="17b2db36046a6d6b259eca232fffab81b5753b2e"
CROS_WORKON_TREE="de17f77709d82f697db11c418ab295c778adaa54"
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_SUBTREE="biod/study"
PYTHON_COMPAT=( python3_{6..9} pypy3 )

inherit cros-workon python-r1

DESCRIPTION="Chromium OS Fingerprint user study software"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/biod/study"

LICENSE="BSD-Google"
KEYWORDS="*"

# The fingerprint study can optionally make use of the private package
# virtual/chromeos-fpmcu-test, which holds the C+python fputils lib.
# This library is also used for factory tests, thus it was labeled fpmcu-test.
# The chromeos-base/ec-utils pkg provides ectool.
# The chromeos-base/ec-utils-test pkg provides flash_fp_mcu for test operator.
DEPEND=""
RDEPEND="
	${PYTHON_DEPS}
	chromeos-base/ec-utils
	chromeos-base/ec-utils-test
	dev-python/cherrypy[${PYTHON_USEDEP}]
	dev-python/python-gnupg[${PYTHON_USEDEP}]
	dev-python/ws4py[${PYTHON_USEDEP}]
	virtual/chromeos-fpmcu-test
	"

src_unpack() {
	cros-workon_src_unpack
	S+="/biod/study"
}

src_install() {
	# install the study local server
	exeinto /opt/google/fingerprint_study
	newexe study_serve.py study_serve

	# Content to serve
	insinto /opt/google/fingerprint_study/html
	doins html/index.html
	doins html/bootstrap-3.3.7.min.css
	doins html/fingerprint.svg

	insinto /etc/init
	doins init/fingerprint_study.conf
	doins init/syslog_fingerprint_study.conf

	insinto /etc/bash/bashrc.d
	doins shell-audit.sh

	insinto /etc/rsyslog.d
	doins rsyslog.fpstudy-audit.conf
}
