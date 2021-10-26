# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit flag-o-matic multilib-minimal multiprocessing

DESCRIPTION="sandbox'd LD_PRELOAD hack"
HOMEPAGE="https://wiki.gentoo.org/wiki/Project:Sandbox"
SRC_URI="https://dev.gentoo.org/~vapier/dist/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="*"
IUSE="nnp"

DEPEND="app-arch/xz-utils
	>=app-misc/pax-utils-0.1.19" #265376
RDEPEND=""

has sandbox_death_notice ${EBUILD_DEATH_HOOKS} || EBUILD_DEATH_HOOKS+=" sandbox_death_notice"

sandbox_death_notice() {
	ewarn "If configure failed with a 'cannot run C compiled programs' error, try this:"
	ewarn "FEATURES='-sandbox -usersandbox' emerge sandbox"
}

src_prepare() {
	default

	eapply "${FILESDIR}"/${P}-pyc-hack.patch

	if ! use nnp ; then
		sed -i 's:PR_SET_NO_NEW_PRIVS:___disable_nnp_hack:' src/sandbox.c || die
	fi

	# sandbox uses `__asm__ (".symver "...` which does
	# not play well with gcc's LTO: https://gcc.gnu.org/PR48200
	append-flags -fno-lto
	append-ldflags -fno-lto
}

multilib_src_configure() {
	filter-lfs-flags #90228

	ECONF_SOURCE="${S}" econf
}

multilib_src_test() {
	# Default sandbox build will run with --jobs set to # cpus.
	# -j1 to prevent test faiures caused by file descriptor
	# injection GNU make does.
	emake -j1 check TESTSUITEFLAGS="--jobs=$(makeopts_jobs)"
}

multilib_src_install_all() {
	doenvd "${FILESDIR}"/09sandbox

	dodoc AUTHORS ChangeLog* README.md
}

pkg_postinst() {
	mkdir -p "${EROOT}"/var/log/sandbox
	chown root:portage "${EROOT}"/var/log/sandbox
	chmod 0770 "${EROOT}"/var/log/sandbox
}
