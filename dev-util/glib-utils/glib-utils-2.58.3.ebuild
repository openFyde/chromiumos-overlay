# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5
PYTHON_COMPAT=( python{2_7,3_5,3_6,3_7} )
GNOME_ORG_MODULE="glib"

inherit gnome.org python-single-r1

DESCRIPTION="Build utilities for GLib using projects"
HOMEPAGE="https://www.gtk.org/"

LICENSE="LGPL-2.1+"
SLOT="0" # /usr/bin utilities that can't be parallel installed by their nature
IUSE=""
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

KEYWORDS="*"

RDEPEND="${PYTHON_DEPS}
	!<dev-libs/glib-2.56.2:2
"
DEPEND="${RDEPEND}
	dev-libs/libxslt
	app-text/docbook-xsl-stylesheets
"

src_configure() { :; }

do_xsltproc_command() {
	# Taken from meson.build for manual manpage building - keep in sync (also copied to dev-util/gdbus-codegen)
	xsltproc \
		--nonet \
		--stringparam man.output.quietly 1 \
		--stringparam funcsynopsis.style ansi \
		--stringparam man.th.extra1.suppress 1 \
		--stringparam man.authors.section.enabled 0 \
		--stringparam man.copyright.section.enabled 0 \
		-o "${2}" \
		http://docbook.sourceforge.net/release/xsl/current/manpages/docbook.xsl \
		"${1}" || die "manpage generation failed"
}

src_compile() {
	sed -e "s:@VERSION@:${PV}:g;s:@PYTHON@:python:g" gobject/glib-genmarshal.in > gobject/glib-genmarshal || die
	sed -e "s:@VERSION@:${PV}:g;s:@PYTHON@:python:g" gobject/glib-mkenums.in > gobject/glib-mkenums || die
	sed -e "s:@GLIB_VERSION@:${PV}:g;s:@PYTHON@:python:g" glib/gtester-report.in > glib/gtester-report || die
	do_xsltproc_command docs/reference/gobject/glib-genmarshal.xml docs/reference/gobject/glib-genmarshal.1
	do_xsltproc_command docs/reference/gobject/glib-mkenums.xml docs/reference/gobject/glib-mkenums.1
	do_xsltproc_command docs/reference/glib/gtester-report.xml docs/reference/glib/gtester-report.1
}

src_install() {
	python_fix_shebang gobject/glib-genmarshal
	python_fix_shebang gobject/glib-mkenums
	python_fix_shebang glib/gtester-report
	exeinto /usr/bin
	doexe gobject/glib-genmarshal
	doexe gobject/glib-mkenums
	doexe glib/gtester-report
	doman docs/reference/gobject/glib-genmarshal.1
	doman docs/reference/gobject/glib-mkenums.1
	doman docs/reference/glib/gtester-report.1
}
