# Copyright (c) 2012 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

CROS_WORKON_COMMIT="8f240620cc29a3dbe55916fd86189ae5376be277"
CROS_WORKON_TREE="1a688209ae0c00f02f54190ca2ad1988002f5ecc"
CROS_WORKON_PROJECT="chromiumos/platform/assets"
CROS_WORKON_LOCALNAME="assets"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_INCREMENTAL_BUILD=1

inherit cros-workon

DESCRIPTION="Common Chromium OS assets (images, sounds, etc.)"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform/assets"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
IUSE="
	+fonts
	+tts
"

# display_boot_message calls the pango-view program.
RDEPEND="
	fonts? ( chromeos-base/chromeos-fonts )
	x11-libs/pango"

# Don't strip NaCl executables. These are not linux executables and the
# linux host's strip command doesn't know how to handle them correctly.
STRIP_MASK="*.nexe"

src_install() {
	insinto /usr/share/chromeos-assets/images
	doins -r images/*

	insinto /usr/share/chromeos-assets/images_100_percent
	doins -r images_100_percent/*

	insinto /usr/share/chromeos-assets/images_200_percent
	doins -r images_200_percent/*

	insinto /usr/share/chromeos-assets/text
	doins -r text/boot_messages
	dosbin text/display_boot_message

	insinto /usr/share/chromeos-assets
	doins -r connectivity_diagnostics
	doins -r connectivity_diagnostics_launcher

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
