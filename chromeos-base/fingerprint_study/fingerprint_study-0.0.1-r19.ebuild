# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="f8d60e9b2e9e71fda2271160ef708570377737bb"
CROS_WORKON_TREE="e7f196d2c6118f9e6df2289159526121586f4dc0"
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_SUBTREE="biod/study"
PYTHON_COMPAT=( python3_{6,7,8} pypy3 )

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
