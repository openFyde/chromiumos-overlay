# Copyright (c) 2010 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=2

DESCRIPTION="Chrome OS restricted set of certificates"
HOMEPAGE="http://src.chromium.org"
SRC_URI=""

LICENSE="BSD"
SLOT="0"
KEYWORDS="*"

S=${WORKDIR}

src_compile() {
	"${FILESDIR}/split-root-certs.py"		\
		--extract-to "${S}"			\
		--roots-pem "${FILESDIR}/roots.pem"	\
		|| die "Couldn't extract certs from roots.pem"
}

src_install() {
	CA_CERT_DIR=/usr/share/chromeos-ca-certificates
	insinto "${CA_CERT_DIR}"
	doins "${S}"/*.pem
	c_rehash "${D}/${CA_CERT_DIR}"
}
