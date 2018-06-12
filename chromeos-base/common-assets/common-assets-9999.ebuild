# Copyright (c) 2012 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=4
CROS_WORKON_PROJECT="chromiumos/platform/assets"

inherit cros-workon toolchain-funcs

DESCRIPTION="Common Chromium OS assets (images, sounds, etc.)"
HOMEPAGE="http://www.chromium.org/"
SRC_URI=""
LICENSE="BSD"
SLOT="0"
KEYWORDS="~*"
IUSE="
	+fonts
	+tts
"

DEPEND=""

RDEPEND="!<chromeos-base/chromeos-assets-0.0.2"

# display_boot_message calls the pango-view program.
RDEPEND+="
	fonts? ( chromeos-base/chromeos-fonts )
	x11-libs/pango"

CROS_WORKON_LOCALNAME="assets"

src_install() {
	insinto /usr/share/chromeos-assets/images
	doins -r "${S}"/images/*

	insinto /usr/share/chromeos-assets/images_100_percent
	doins -r "${S}"/images_100_percent/*

	insinto /usr/share/chromeos-assets/images_200_percent
	doins -r "${S}"/images_200_percent/*

	insinto /usr/share/chromeos-assets/text
	doins -r "${S}"/text/boot_messages
	dosbin "${S}"/text/display_boot_message

	insinto /usr/share/chromeos-assets
	doins -r "${S}"/connectivity_diagnostics
	doins -r "${S}"/connectivity_diagnostics_launcher

	#
	# Speech synthesis
	#
	if use tts ; then
		insinto /usr/share/chromeos-assets/speech_synthesis/patts

		doins speech_synthesis/patts/*.{css,html,js,json,zvoice}
		doins speech_synthesis/patts/tts_service.nmf

		# Speech synthesis engine (platform-specific native client module).
		pushd "${D}"/usr/share/chromeos-assets/speech_synthesis/patts >/dev/null || die
		if use arm ; then
			unzip "${S}"/speech_synthesis/patts/tts_service_arm.nexe.zip || die
		elif use x86 ; then
			unzip "${S}"/speech_synthesis/patts/tts_service_x86_32.nexe.zip || die
		elif use amd64 ; then
			unzip "${S}"/speech_synthesis/patts/tts_service_x86_64.nexe.zip || die
		fi
		# We don't need these to be executable, and some autotests will fail it.
		chmod 0644 *.nexe || die
		popd >/dev/null
	fi
}
