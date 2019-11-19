# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-portage/gentoolkit/gentoolkit-0.3.0.8-r2.ebuild,v 1.10 2014/07/06 12:35:20 mgorny Exp $

EAPI="5"

PYTHON_COMPAT=(python{2_6,2_7,3_2,3_3} pypy2_0)
PYTHON_REQ_USE="xml(+)"

inherit distutils-r1

DESCRIPTION="Collection of administration scripts for Gentoo"
HOMEPAGE="http://www.gentoo.org/proj/en/portage/tools/index.xml"
SRC_URI="mirror://gentoo/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
IUSE=""

KEYWORDS="*"

DEPEND="sys-apps/portage"
RDEPEND="${DEPEND}
	!<=app-portage/gentoolkit-dev-0.2.7
	|| ( >=sys-apps/coreutils-8.15 app-misc/realpath sys-freebsd/freebsd-bin )
	sys-apps/gawk
	sys-apps/grep"

PATCHES=(
	"${FILESDIR}"/${PV}-revdep-rebuild-484340.patch
	"${FILESDIR}"/${PV}-revdep-rebuild-476740.patch
	"${FILESDIR}"/${PV}-handle-debug-symbols.patch
)

python_prepare_all() {
	python_export_best
	echo VERSION="${PVR}" "${PYTHON}" setup.py set_version
	VERSION="${PVR}" "${PYTHON}" setup.py set_version
	mv ./bin/revdep-rebuild{,.py} || die
	distutils-r1_python_prepare_all
}

python_install_all() {
	distutils-r1_python_install_all

	# Rename the python versions of revdep-rebuild, since we are not ready
	# to switch to the python version yet. Link /usr/bin/revdep-rebuild to
	# revdep-rebuild.sh. Leaving the python version available for potential
	# testing by a wider audience.
	dosym revdep-rebuild.sh /usr/bin/revdep-rebuild

	# Create cache directory for revdep-rebuild
	keepdir /var/cache/revdep-rebuild
	use prefix || fowners root:0 /var/cache/revdep-rebuild
	fperms 0700 /var/cache/revdep-rebuild

	# remove on Gentoo Prefix platforms where it's broken anyway
	if use prefix; then
		elog "The revdep-rebuild command is removed, the preserve-libs"
		elog "feature of portage will handle issues."
		rm "${ED}"/usr/bin/revdep-rebuild*
		rm "${ED}"/usr/share/man/man1/revdep-rebuild.1
		rm -rf "${ED}"/etc/revdep-rebuild
		rm -rf "${ED}"/var
	fi

	# Portage installs this now.
	find "${D}" -name 'glsa-check*' -delete || die
	rm -rf "${D}"/var
}

pkg_postinst() {
	# Only show the elog information on a new install
	if [[ ! ${REPLACING_VERSIONS} ]]; then
		elog
		elog "For further information on gentoolkit, please read the gentoolkit"
		elog "guide: http://www.gentoo.org/doc/en/gentoolkit.xml"
		elog
		elog "Another alternative to equery is app-portage/portage-utils"
		elog
		elog "Additional tools that may be of interest:"
		elog
		elog "    app-admin/eclean-kernel"
		elog "    app-portage/diffmask"
		elog "    app-portage/flaggie"
		elog "    app-portage/install-mask"
		elog "    app-portage/portpeek"
		elog "    app-portage/smart-live-rebuild"
	fi
}
