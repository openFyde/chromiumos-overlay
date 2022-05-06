# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"
WANT_LIBTOOL="none"

inherit autotools flag-o-matic multiprocessing pax-utils \
	python-utils-r1 toolchain-funcs verify-sig

MY_P="Python-${PV%_p*}"
PYVER=$(ver_cut 1-2)
PATCHSET="python-gentoo-patches-${PV}"

DESCRIPTION="An interpreted, interactive, object-oriented programming language"
HOMEPAGE="https://www.python.org/"
SRC_URI="https://www.python.org/ftp/python/${PV%_*}/${MY_P}.tar.xz
	https://dev.gentoo.org/~mgorny/dist/python/${PATCHSET}.tar.xz
	verify-sig? (
		https://www.python.org/ftp/python/${PV%_*}/${MY_P}.tar.xz.asc
	)"
S="${WORKDIR}/${MY_P}"

LICENSE="PSF-2"
SLOT="${PYVER}/${PYVER}m"
KEYWORDS="*"
IUSE="bluetooth build examples gdbm hardened +ncurses +readline +sqlite +ssl test tk wininst +xml"
RESTRICT="!test? ( test )"

# Do not add a dependency on dev-lang/python to this ebuild.
# If you need to apply a patch which requires python for bootstrapping, please
# run the bootstrap code on your dev box and include the results in the
# patchset. See bug 447752.

RDEPEND="app-arch/bzip2:=
	app-arch/xz-utils:=
	dev-libs/libffi:=
	>=sys-libs/zlib-1.1.3:=
	virtual/libcrypt:=
	virtual/libintl
	gdbm? ( sys-libs/gdbm:=[berkdb] )
	ncurses? ( >=sys-libs/ncurses-5.2:= )
	readline? ( >=sys-libs/readline-4.1:= )
	sqlite? ( >=dev-db/sqlite-3.3.8:3= )
	ssl? ( dev-libs/openssl:= )
	tk? (
		>=dev-lang/tcl-8.0:=
		>=dev-lang/tk-8.0:=
		dev-tcltk/blt:=
		dev-tcltk/tix
	)
	xml? ( >=dev-libs/expat-2.1:= )"
# bluetooth requires headers from bluez
DEPEND="${RDEPEND}
	bluetooth? ( net-wireless/bluez )
	test? ( app-arch/xz-utils[extra-filters(+)] )"
BDEPEND="
	virtual/awk
	virtual/pkgconfig
	verify-sig? ( sec-keys/openpgp-keys-python )
	!sys-devel/gcc[libffi(-)]"
RDEPEND+=" !build? ( app-misc/mime-types )"

VERIFY_SIG_OPENPGP_KEY_PATH=${BROOT}/usr/share/openpgp-keys/python.org.asc

src_unpack() {
	if use verify-sig; then
		verify-sig_verify_detached "${DISTDIR}"/${MY_P}.tar.xz{,.asc}
	fi
	default
}

# Google-specific PGO bits
#
# NOTE: If you're looking here because python-*-profile.tar.xz is missing:
# - thanks for upgrading Python!
# - files/python3_gen_pgo.sh should be able to generate a PGO profile for you.
# - only new minor versions of Python should require a new PGO profile.
#
# Generally, PGO profile generation should be done as one of the last steps of
# a Python upgrade, so feel free to turn pgo_use off as a default until things
# are pretty finalized.
SRC_URI+=" pgo_use? ( gs://chromeos-localmirror/distfiles/python-$(ver_cut 1-2)-profile.tar.xz )"
IUSE+=" pgo_generate +pgo_use"
REQUIRED_USE+=" pgo_generate? ( !pgo_use )"

src_prepare() {
	# Ensure that internal copies of expat, libffi and zlib are not used.
	rm -fr Modules/expat || die
	rm -fr Modules/_ctypes/libffi* || die
	rm -fr Modules/zlib || die

	local PATCHES=(
		"${WORKDIR}/${PATCHSET}"
	)

	default

	# START: Chromium OS
	if tc-is-cross-compiler ; then
		eapply "${FILESDIR}/python-3.6.5-cross-h2py.patch"
		eapply "${FILESDIR}/python-3.6.5-cross-hack-compiler.patch"
	fi
	eapply "${FILESDIR}/python-3.6.5-cross-python-config.patch"
	eapply "${FILESDIR}/python-3.6.5-cross-setup-sysroot.patch"
	eapply "${FILESDIR}/python-3.6.5-cross-distutils.patch"
	eapply "${FILESDIR}/python-3.6.5-cross-sysconfig.patch"
	eapply "${FILESDIR}/python-3.6.5-ldshared.patch"
	eapply "${FILESDIR}/python-3.6.5-system-libffi.patch"
	eapply "${FILESDIR}/python-3.6.5-sigint-handler.patch"
	eapply "${FILESDIR}/python-3.6-mock.patch"

	if use pgo_use; then
		eapply "${FILESDIR}/python-3.6.12-pgo-use.patch"
		cp "${WORKDIR}/code.profclangd" "${S}" || die
	elif use pgo_generate; then
		eapply "${FILESDIR}/python-3.6.12-pgo-generate.patch"
	fi

	# Undo the @libdir@ change for portage's pym folder as it is always
	# installed into /usr/lib/ and not the abi libdir.
	sed -i \
		-e '/portage.*pym/s:@@GENTOO_LIBDIR@@:lib:g' \
		Lib/site.py || die

	sed -i -e "s:sys.exec_prefix]:sys.exec_prefix, '/usr/local']:g" \
		Lib/site.py || die "sed failed to add /usr/local to prefixes"
	# END: Chromium OS

	sed -i -e "s:@@GENTOO_LIBDIR@@:$(get_libdir):g" \
		Lib/distutils/command/install.py \
		Lib/distutils/sysconfig.py \
		Lib/site.py \
		Lib/sysconfig.py \
		Lib/test/test_site.py \
		Makefile.pre.in \
		Modules/Setup.dist \
		Modules/getpath.c \
		configure.ac \
		setup.py || die "sed failed to replace @@GENTOO_LIBDIR@@"

	# force correct number of jobs
	# https://bugs.gentoo.org/737660
	local jobs=$(makeopts_jobs "${MAKEOPTS}" "$(get_nproc)")
	sed -i -e "/self\.parallel/s:True:${jobs}:" setup.py || die

	eautoreconf
}

src_configure() {
	local disable
	# disable automagic bluetooth headers detection
	use bluetooth || export ac_cv_header_bluetooth_bluetooth_h=no
	use gdbm      || disable+=" gdbm"
	use ncurses   || disable+=" _curses _curses_panel"
	use readline  || disable+=" readline"
	use sqlite    || disable+=" _sqlite3"
	use ssl       || export PYTHON_DISABLE_SSL="1"
	use tk        || disable+=" _tkinter"
	use xml       || disable+=" _elementtree pyexpat" # _elementtree uses pyexpat.
	export PYTHON_DISABLE_MODULES="${disable}"

	if ! use xml; then
		ewarn "You have configured Python without XML support."
		ewarn "This is NOT a recommended configuration as you"
		ewarn "may face problems parsing any XML documents."
	fi

	if [[ -n "${PYTHON_DISABLE_MODULES}" ]]; then
		einfo "Disabled modules: ${PYTHON_DISABLE_MODULES}"
	fi

	if [[ "$(gcc-major-version)" -ge 4 ]]; then
		append-flags -fwrapv
	fi

	filter-flags -malign-double

	# https://bugs.gentoo.org/show_bug.cgi?id=50309
	if is-flagq -O3; then
		is-flagq -fstack-protector-all && replace-flags -O3 -O2
		use hardened && replace-flags -O3 -O2
	fi

	# Export CXX so it ends up in /usr/lib/python3.X/config/Makefile.
	tc-export CXX

	tc-export CC

	local dbmliborder
	if use gdbm; then
		dbmliborder+="${dbmliborder:+:}gdbm"
	fi

	local myeconfargs=(
		# glibc-2.30 removes it; since we can't cleanly force-rebuild
		# Python on glibc upgrade, remove it proactively to give
		# a chance for users rebuilding python before glibc
		ac_cv_header_stropts_h=no

		--with-fpectl
		--enable-shared
		--enable-ipv6
		--with-threads
		--infodir='${prefix}/share/info'
		--mandir='${prefix}/share/man'
		--with-computed-gotos
		--with-dbmliborder="${dbmliborder}"
		--with-libc=
		--enable-loadable-sqlite-extensions
		--without-ensurepip
		--with-system-expat
		--with-system-ffi
	)

	if use pgo_generate || use pgo_use; then
		myeconfargs+=(
			"LLVM_PROFDATA=$(which llvm-profdata)"
			--enable-optimizations
		)
	fi

	OPT="" econf "${myeconfargs[@]}"

	if grep -q "#define POSIX_SEMAPHORES_NOT_ENABLED 1" pyconfig.h; then
		eerror "configure has detected that the sem_open function is broken."
		eerror "Please ensure that /dev/shm is mounted as a tmpfs with mode 1777."
		die "Broken sem_open function (bug 496328)"
	fi
}

src_compile() {
	# Ensure sed works as expected
	# https://bugs.gentoo.org/594768
	local -x LC_ALL=C

	emake CPPFLAGS= CFLAGS= LDFLAGS=

	# Work around bug 329499. See also bug 413751 and 457194.
	if has_version dev-libs/libffi[pax-kernel]; then
		pax-mark E python
	else
		pax-mark m python
	fi
}

src_test() {
	# Tests will not work when cross compiling.
	if tc-is-cross-compiler; then
		elog "Disabling tests due to crosscompiling."
		return
	fi

	# Skip failing tests.
	local skipped_tests="gdb faulthandler"

	for test in ${skipped_tests}; do
		mv "${S}"/Lib/test/test_${test}.py "${T}"
	done

	# bug 660358
	local -x COLUMNS=80
	local -x PYTHONDONTWRITEBYTECODE=

	local jobs=$(makeopts_jobs "${MAKEOPTS}" "$(get_nproc)")

	emake test EXTRATESTOPTS="-u-network -j${jobs}" \
		CPPFLAGS= CFLAGS= LDFLAGS= < /dev/tty
	local result=$?

	for test in ${skipped_tests}; do
		mv "${T}/test_${test}.py" "${S}"/Lib/test
	done

	elog "The following tests have been skipped:"
	for test in ${skipped_tests}; do
		elog "test_${test}.py"
	done

	elog "If you would like to run them, you may:"
	elog "cd '${EPREFIX}/usr/$(get_libdir)/python${PYVER}/test'"
	elog "and run the tests separately."

	if [[ ${result} -ne 0 ]]; then
		die "emake test failed"
	fi
}

src_install() {
	local libdir=${ED}/usr/$(get_libdir)/python${PYVER}

	emake DESTDIR="${D}" altinstall

	# Remove static library
	rm "${ED}"/usr/$(get_libdir)/libpython*.a || die

	sed \
		-e "s/\(CONFIGURE_LDFLAGS=\).*/\1/" \
		-e "s/\(PY_LDFLAGS=\).*/\1/" \
		-i "${libdir}/config-${PYVER}"*/Makefile || die "sed failed"

	# Fix collisions between different slots of Python.
	rm "${ED}/usr/$(get_libdir)/libpython3.so" || die

	# Cheap hack to get version with ABIFLAGS
	local abiver=$(cd "${ED}/usr/include"; echo python*)
	if [[ ${abiver} != python${PYVER} ]]; then
		# Replace python3.X with a symlink to python3.Xm
		rm "${ED}/usr/bin/python${PYVER}" || die
		dosym "${abiver}" "/usr/bin/python${PYVER}"
		# Create python3.X-config symlink
		dosym "${abiver}-config" "/usr/bin/python${PYVER}-config"
		# Create python-3.5m.pc symlink
		dosym "python-${PYVER}.pc" "/usr/$(get_libdir)/pkgconfig/${abiver/${PYVER}/-${PYVER}}.pc"
	fi

	# python seems to get rebuilt in src_install (bug 569908)
	# Work around it for now.
	if has_version dev-libs/libffi[pax-kernel]; then
		pax-mark E "${ED}/usr/bin/${abiver}"
	else
		pax-mark m "${ED}/usr/bin/${abiver}"
	fi

	use sqlite || rm -r "${libdir}/"{sqlite3,test/test_sqlite*} || die
	use tk || rm -r "${ED}/usr/bin/idle${PYVER}" "${libdir}/"{idlelib,tkinter,test/test_tk*} || die

	use wininst || rm "${libdir}/distutils/command/"wininst-*.exe || die

	dodoc Misc/{ACKS,HISTORY,NEWS}

	if use examples; then
		docinto examples
		find Tools -name __pycache__ -exec rm -fr {} + || die
		dodoc -r Tools
	fi
	insinto /usr/share/gdb/auto-load/usr/$(get_libdir) #443510
	local libname=$(printf 'e:\n\t@echo $(INSTSONAME)\ninclude Makefile\n' | \
		emake --no-print-directory -s -f - 2>/dev/null)
	newins "${S}"/Tools/gdb/libpython.py "${libname}"-gdb.py

	newconfd "${FILESDIR}/pydoc.conf" pydoc-${PYVER}
	newinitd "${FILESDIR}/pydoc.init" pydoc-${PYVER}
	sed \
		-e "s:@PYDOC_PORT_VARIABLE@:PYDOC${PYVER/./_}_PORT:" \
		-e "s:@PYDOC@:pydoc${PYVER}:" \
		-i "${ED}/etc/conf.d/pydoc-${PYVER}" \
		"${ED}/etc/init.d/pydoc-${PYVER}" || die "sed failed"

	local -x EPYTHON=python${PYVER}
	# if not using a cross-compiler, use the fresh binary
	if ! tc-is-cross-compiler; then
		local -x PYTHON=./python
		local -x LD_LIBRARY_PATH=${LD_LIBRARY_PATH+${LD_LIBRARY_PATH}:}${PWD}
	else
		local -x PYTHON=${EPREFIX}/usr/bin/${EPYTHON}
	fi

	echo "EPYTHON='${EPYTHON}'" > epython.py || die
	python_domodule epython.py

	# python-exec wrapping support
	local pymajor=${PYVER%.*}
	local scriptdir=${D}$(python_get_scriptdir)
	mkdir -p "${scriptdir}" || die
	# python and pythonX
	ln -s "../../../bin/${abiver}" \
		"${scriptdir}/python${pymajor}" || die
	ln -s "python${pymajor}" "${scriptdir}/python" || die
	# python-config and pythonX-config
	# note: we need to create a wrapper rather than symlinking it due
	# to some random dirname(argv[0]) magic performed by python-config
	cat > "${scriptdir}/python${pymajor}-config" <<-EOF || die
		#!/bin/sh
		exec "${abiver}-config" "\${@}"
	EOF
	chmod +x "${scriptdir}/python${pymajor}-config" || die
	ln -s "python${pymajor}-config" \
		"${scriptdir}/python-config" || die
	# 2to3, pydoc, pyvenv
	ln -s "../../../bin/2to3-${PYVER}" \
		"${scriptdir}/2to3" || die
	ln -s "../../../bin/pydoc${PYVER}" \
		"${scriptdir}/pydoc" || die
	ln -s "../../../bin/pyvenv-${PYVER}" \
		"${scriptdir}/pyvenv" || die
	# idle
	if use tk; then
		ln -s "../../../bin/idle${PYVER}" \
			"${scriptdir}/idle" || die
	fi

	# Delete unittests as they are a waste of space and are unused.
	rm -rf "${libdir}/test" "${libdir}"/{ctypes,email,sqlite3,unittest}/test || die
}
