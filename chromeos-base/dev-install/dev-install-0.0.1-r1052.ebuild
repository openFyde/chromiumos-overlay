# Copyright 2012 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

# This ebuild file installs the developer installer package. It:
#  + Copies dev_install.
#  + Copies some config files for emerge: make.defaults and make.conf.
#  + Generates a list of packages installed (in base images).
# dev_install downloads and bootstraps emerge in base images without
# modifying the root filesystem.

EAPI="6"
CROS_WORKON_COMMIT="67dcd127b9111b4fdf19d48670f09099deef364b"
CROS_WORKON_TREE="2ec274a5e99989c532402a4650bea0da34690867"
CROS_WORKON_PROJECT="chromiumos/platform/dev-util"
CROS_WORKON_LOCALNAME="dev"
CROS_WORKON_OUTOFTREE_BUILD="1"
CROS_WORKON_SUBTREE="dev-install"

inherit cros-workon

DESCRIPTION="Chromium OS Developer Packages installer"
HOMEPAGE="http://dev.chromium.org/chromium-os/how-tos-and-troubleshooting/install-software-on-base-images"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}
	app-arch/bzip2
	app-arch/tar
	net-misc/curl"

fixup_make_defaults() {
	local file=$1

	sed -i \
		-e "s/@IUSE_IMPLICIT@/${IUSE_IMPLICIT}/g" \
		-e "s/@ARCH@/${ARCH}/g" \
		-e "s/@ELIBC@/${ELIBC}/g" \
		-e "s/@USERLAND@/${USERLAND}/g" \
		-e "s/@KERNEL@/${KERNEL}/g" \
		-e "s/@USE_EXPAND_IMPLICIT@/${USE_EXPAND_IMPLICIT}/g" \
		${file} || die
}

# Nothing to compile.
src_compile() { :; }

src_install() {
	cd "${S}/dev-install"
	dobin dev_install

	insinto /usr/share/${PN}/portage/make.profile
	doins make.defaults

	fixup_make_defaults "${ED}"/usr/share/${PN}/portage/make.profile/make.defaults

	insinto /etc/bash/bashrc.d/
	newins bashrc ${PN}.sh

	insinto /etc/env.d
	doins 99devinstall
	sed -i "s:@LIBDIR@:$(get_libdir):g" "${ED}"/etc/env.d/99devinstall

	# Python will be installed in /usr/local after running dev_install.
	# Ideally this should always work.  There's a minor bug that sometimes
	# shows up https://bugs.gentoo.org/380569 so work around it if need be.
	local pyver=$(eselect python show --ABI)
	if [[ -z ${pyver} ]]; then
		pyver=$(readlink "${SYSROOT}"/usr/bin/python2 | sed s:python::)
	fi
	dosym "/usr/local/bin/python${pyver}" "/usr/bin/python"
}

pkg_preinst() {
	if [[ $(cros_target) == "target_image" ]]; then
		# We don't want to install these files into the normal /build/
		# dir because we need different settings at build time vs what
		# we want at runtime in release images.  Thus, install the files
		# into /usr/share but symlink them into /etc for the images.
		dosym "/usr/share/${PN}/portage" /etc/portage
	fi
}
