# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="d6c01c3a1f72d95d7ecafc0ab9c3fa4bbc7960dd"
CROS_WORKON_TREE="f795131b8c94f56d9da33ac2cfc3489f84cffc0a"
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
	dev-python/python-gnupg[${PYTHON_USEDEP}]
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
