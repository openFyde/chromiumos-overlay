# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6..9} )
PYTHON_REQ_USE="xml"
inherit cros-constants gnome.org meson python-single-r1 xdg

DESCRIPTION="Introspection system for GObject-based libraries"
HOMEPAGE="https://wiki.gnome.org/Projects/GObjectIntrospection"

LICENSE="LGPL-2+ GPL-2+"
SLOT="0"
IUSE="cros_host doctool gtk-doc test"
RESTRICT="!test? ( test )"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"
KEYWORDS="*"

# virtual/pkgconfig needed at runtime, bug #505408
RDEPEND="
	>=dev-libs/gobject-introspection-common-${PV}
	>=dev-libs/glib-2.58.0:2
	dev-libs/libffi:=
	doctool? (
		$(python_gen_cond_dep '
			dev-python/mako[${PYTHON_USEDEP}]
			dev-python/markdown[${PYTHON_USEDEP}]
		')
	)
	virtual/pkgconfig
	${PYTHON_DEPS}
"
# Wants real bison, not virtual/yacc
DEPEND="${RDEPEND}
	gtk-doc? ( >=dev-util/gtk-doc-1.19
		app-text/docbook-xml-dtd:4.3
		app-text/docbook-xml-dtd:4.5
	)
	sys-devel/bison
	sys-devel/flex
	test? (
		x11-libs/cairo[glib]
		$(python_gen_cond_dep '
			dev-python/mako[${PYTHON_USEDEP}]
			dev-python/markdown[${PYTHON_USEDEP}]
		')
	)
"

BDEPEND="
	!cros_host? (
		>=dev-libs/gobject-introspection-${PV}
		app-emulation/qemu
	)
"

pkg_setup() {
	python-single-r1_pkg_setup
}

src_configure() {
	local emesonargs=(
		$(meson_feature test cairo)
		$(meson_feature doctool)
		#-Dglib_src_dir
		$(meson_use gtk-doc gtk_doc)
		#-Dcairo_libname
		-Dpython="${EPYTHON}"
		#-Dgir_dir_prefix
	)

	if ! use cros_host ; then
		emesonargs+=(
			-Dgi_cross_pkgconfig_sysroot_path="${SYSROOT}"
			-Dgi_cross_use_prebuilt_gi=true
			-Dgi_cross_binary_wrapper="${FILESDIR}/exec_wrapper"
			-Dgi_cross_ldd_wrapper="${FILESDIR}/ldd_wrapper"
		)
		# The ldd & binary wrappers rely on these locations being defined via
		# the values in cros-constants.eclass
		export CHROMITE_BIN_DIR CHROOT_SOURCE_ROOT
	fi

	tc-export PKG_CONFIG
	meson_src_configure
}

src_compile() {
	tc-export PKG_CONFIG
	meson_src_compile
}

src_install() {
	meson_src_install
	python_fix_shebang "${ED}"/usr/bin/
	python_optimize "${ED}"/usr/$(get_libdir)/gobject-introspection/giscanner

	# Prevent collision with gobject-introspection-common
	rm -v "${ED}"/usr/share/aclocal/introspection.m4 \
		"${ED}"/usr/share/gobject-introspection-1.0/Makefile.introspection || die
	rmdir "${ED}"/usr/share/aclocal || die
}
