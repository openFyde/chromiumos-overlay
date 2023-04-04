# Copyright 2012 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

CROS_WORKON_COMMIT="427105b989e24e9cf1c6666a9bf97b6289ff2ecf"
CROS_WORKON_TREE=("71a6d7914cd13df8d299f6853d4488c5b559fa54" "0d69a9dd1e3670ddca6fe57fc9019fdadafc9628" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="common-mk dev-install .gn"

PLATFORM_SUBDIR="dev-install"

inherit cros-workon platform

DESCRIPTION="Chromium OS Developer Packages installer"
HOMEPAGE="http://dev.chromium.org/chromium-os/how-tos-and-troubleshooting/install-software-on-base-images"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
IUSE=""

DEPEND="chromeos-base/vboot_reference:="
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

platform_pkg_test() {
	platform_test "run" "${OUT}/dev_install_test"
}

src_install() {
	platform_src_install

	dobin "${OUT}/dev_install"

	cd "${S}/share" || die
	insinto /usr/share/${PN}/portage/make.profile
	doins make.defaults

	fixup_make_defaults "${ED}"/usr/share/${PN}/portage/make.profile/make.defaults

	insinto /etc/bash/bashrc.d/
	newins bashrc ${PN}.sh

	insinto /etc/env.d
	doins 99devinstall
	sed -i "s:@LIBDIR@:$(get_libdir):g" "${ED}"/etc/env.d/99devinstall
}

pkg_preinst() {
	if [[ $(cros_target) == "target_image" ]]; then
		# We don't want to install these files into the normal /build/
		# dir because we need different settings at build time vs what
		# we want at runtime in release images.  Thus, install the files
		# into /usr/share but symlink them into /etc for the images.
		dosym "/usr/share/${PN}/portage" /etc/portage

		# The parent file content needs to be kept in sync with the
		# dev_install code.
		dodir /usr/local/etc/portage/make.profile
		echo /etc/portage/make.profile \
			>"${D}"/usr/local/etc/portage/make.profile/parent || die
	fi
}
