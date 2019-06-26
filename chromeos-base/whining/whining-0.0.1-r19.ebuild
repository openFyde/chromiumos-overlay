# Copyright 2016 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

CROS_WORKON_COMMIT="f17caea7f6bdbafaca8de35e83178de3999e4f45"
CROS_WORKON_TREE="0369647c48e87ad453ed6f5e83742b9c6be47794"
CROS_WORKON_PROJECT="chromiumos/third_party/whining"
CROS_WORKON_LOCALNAME=../third_party/whining

inherit cros-workon

DESCRIPTION="Whining matrix"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/third_party/whining"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"

RDEPEND="
	dev-python/bottle
"

DEPEND=""

WHINING_WORK="${WORKDIR}/whining-work"
WHINING_BASE="/whining"

src_prepare() {
	default

	mkdir -p "${WHINING_WORK}"
	cp -fpru "${S}"/* "${WHINING_WORK}/" &>/dev/null
	find "${WHINING_WORK}" -name '*.pyc' -delete
}

src_install() {
	insinto "${WHINING_BASE}"
	doins -r "${WHINING_WORK}"/*
	doins "${FILESDIR}"/apache-conf
	doins "${FILESDIR}"/config.ini

	insinto /etc/init
	doins "${FILESDIR}"/whining_setup.conf
}
