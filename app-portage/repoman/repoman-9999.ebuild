# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DISTUTILS_USE_SETUPTOOLS=no
PYTHON_COMPAT=( python3_{6..9} )
PYTHON_REQ_USE='bzip2(+)'

inherit distutils-r1

CROS_WORKON_PROJECT="chromiumos/third_party/portage_tool"
CROS_WORKON_LOCALNAME="portage_tool"
CROS_WORKON_EGIT_BRANCH="chromeos-3.0.21"
CROS_WORKON_SUBTREE="repoman"
inherit cros-workon

KEYWORDS="~*"

DESCRIPTION="Repoman is a Quality Assurance tool for Gentoo ebuilds"
HOMEPAGE="https://wiki.gentoo.org/wiki/Project:Portage"

LICENSE="GPL-2"
SLOT="0"
IUSE=""

RDEPEND="
	>=sys-apps/portage-2.3.0_rc[${PYTHON_USEDEP}]
	>=dev-python/lxml-3.6.0[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}"

src_unpack() {
	cros-workon_src_unpack
	S+="/repoman"
}

python_test() {
	esetup.py test
}

python_install() {
	# Install sbin scripts to bindir for python-exec linking
	# they will be relocated in pkg_preinst()
	distutils-r1_python_install \
		--system-prefix="${EPREFIX}/usr" \
		--bindir="$(python_get_scriptdir)" \
		--docdir="${EPREFIX}/usr/share/doc/${PF}" \
		--htmldir="${EPREFIX}/usr/share/doc/${PF}/html" \
		--sbindir="$(python_get_scriptdir)" \
		--sysconfdir="${EPREFIX}/etc" \
		"${@}"
}

pkg_postinst() {
	if [[ -z ${REPLACING_VERSIONS} ]]; then
		elog ""
		elog "This release of repoman is from the new portage/repoman split"
		elog "release code base."
		elog "This new repoman code base is still being developed.  So its API's"
		elog "are not to be considered stable and are subject to change."
		elog "The code released has been tested and considered ready for use."
		elog "This however does not guarantee it to be completely bug free."
		elog "Please report any bugs you may encounter."
		elog ""
	fi
}
