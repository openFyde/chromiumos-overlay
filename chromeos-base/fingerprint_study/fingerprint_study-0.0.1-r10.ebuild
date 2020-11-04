# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="70a569b4d3c39247cdcafe06ea1531ed79789557"
CROS_WORKON_TREE="65539b94936a31285f1a431d38c2f2cdd8ceb3ac"
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_SUBTREE="biod/study"
PYTHON_COMPAT=( python2_7 )

inherit cros-workon python-r1

DESCRIPTION="Chromium OS Fingerprint user study software"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/master/biod/study"

LICENSE="BSD-Google"
KEYWORDS="*"

DEPEND=""
RDEPEND="
	${PYTHON_DEPS}
	chromeos-base/ec-utils
	dev-python/cherrypy[${PYTHON_USEDEP}]
	dev-python/ws4py[${PYTHON_USEDEP}]
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
