# Copyright (c) 2012 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=4
CROS_WORKON_COMMIT="972af08bfe486d4cc3a9da06a9bafcf4144aff7f"
CROS_WORKON_TREE="376a1de2d9b3a230e23bacbd03897200785419c1"
CROS_WORKON_PROJECT="chromiumos/platform/assets"

inherit cros-workon toolchain-funcs

DESCRIPTION="Common Chromium OS assets (images, sounds, etc.)"
HOMEPAGE="http://www.chromium.org/"
SRC_URI=""
LICENSE="BSD"
SLOT="0"
KEYWORDS="*"
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

# Languages for which we preinstall text to speech voice data.
TTS_LANGUAGES="de-DE en-GB en-IN en-US es-ES es-US fr-FR hi-IN id-ID it-IT
	ko-KR nl-NL pt-BR"

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

	mkdir "${S}"/connectivity_diagnostics_launcher_deploy
	pushd "${S}"/connectivity_diagnostics_launcher_deploy > /dev/null
	unpack ./../connectivity_diagnostics_launcher/connectivity_diagnostics_launcher.zip
	insinto /usr/share/chromeos-assets/connectivity_diagnostics_launcher
	doins -r "${S}"/connectivity_diagnostics_launcher_deploy/*
	popd > /dev/null

	mkdir "${S}"/connectivity_diagnostics_deploy
	unzip "${S}"/connectivity_diagnostics/connectivity_diagnostics.zip \
		-d "${S}"/connectivity_diagnostics_deploy
	insinto /usr/share/chromeos-assets/connectivity_diagnostics
	doins -r "${S}"/connectivity_diagnostics_deploy/*

	mkdir "${S}"/connectivity_diagnostics_kiosk_deploy
	unzip "${S}"/connectivity_diagnostics/connectivity_diagnostics_kiosk.zip \
		-d "${S}"/connectivity_diagnostics_kiosk_deploy
	insinto /usr/share/chromeos-assets/connectivity_diagnostics_kiosk
	doins -r "${S}"/connectivity_diagnostics_kiosk_deploy/*

	#
	# Speech synthesis
	#

	if use tts ; then

		insinto /usr/share/chromeos-assets/speech_synthesis/patts

		# Speech synthesis component extension code
		doins "${S}"/speech_synthesis/patts/manifest.json
		doins "${S}"/speech_synthesis/patts/manifest_guest.json
		doins "${S}"/speech_synthesis/patts/tts_main.js
		doins "${S}"/speech_synthesis/patts/tts_controller.js
		doins "${S}"/speech_synthesis/patts/tts_service.nmf

		# Speech synthesis voice data
		for i in ${TTS_LANGUAGES}; do
			doins "${S}"/speech_synthesis/patts/voice_*${i}.js
			doins "${S}"/speech_synthesis/patts/voice_*${i}.zvoice
		done

		# Speech synthesis engine (platform-specific native client module)
		if use arm ; then
			unzip "${S}"/speech_synthesis/patts/tts_service_arm.nexe.zip
			doins "${S}"/tts_service_arm.nexe
		elif use x86 ; then
			unzip "${S}"/speech_synthesis/patts/tts_service_x86_32.nexe.zip
			doins "${S}"/tts_service_x86_32.nexe
		elif use amd64 ; then
			unzip "${S}"/speech_synthesis/patts/tts_service_x86_64.nexe.zip
			doins "${S}"/tts_service_x86_64.nexe
		fi

	fi
}
