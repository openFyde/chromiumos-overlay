# Copyright 2015 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="49606eb2e520e6fa24d7a92dd61985a1c3bb5ea8"
CROS_WORKON_TREE="9e7d53348cab1d5a04e4fa974fa30c11f3ec9b8f"
CROS_WORKON_PROJECT="chromiumos/platform/bmpblk"
CROS_WORKON_LOCALNAME="../platform/bmpblk"
CROS_WORKON_OUTOFTREE_BUILD="1"
CROS_WORKON_USE_VCSID="1"

# TODO(hungte) When "tweaking ebuilds by source repository" is implemented, we
# can generate this list by some script inside source repo.
CROS_BOARDS=(
	ambassador
	asurada
	atlas
	auron_paine
	auron_yuna
	banjo
	brya
	buddy
	butterfly
	candy
	chell
	cherry
	cid
	clapper
	cranky
	daisy
	daisy_snow
	daisy_spring
	daisy_skate
	dedede
	deltaur
	dragonegg
	drallion
	endeavour
	enguarde
	expresso
	eve
	falco
	fizz
	flapjack
	glados
	glimmer
	gnawty
	grunt
	guado
	hatch
	herobrine
	jacuzzi
	kalista
	kevin
	kip
	kukui
	lars
	leon
	link
	lulu
	lumpy
	mccloud
	meowth
	monroe
	mushu
	nami
	nautilus
	ninja
	nocturne
	nyan
	nyan_big
	octopus
	orco
	palkia
	panther
	parrot
	peach_pi
	peach_pit
	peppy
	poppy
	puff
	quawks
	rammus
	reks
	rikku
	sarien
	scarlet
	soraka
	squawks
	stout
	strongbad
	stumpy
	sumo
	swanky
	tglrvp
	tidus
	tricky
	trogdor
	veyron_brain
	veyron_danger
	veyron_jerry
	veyron_mickey
	veyron_minnie
	veyron_pinky
	veyron_romy
	volteer
	winky
	wolf
	zako
	zoombini
	zork
)

PYTHON_COMPAT=( python3_{6..8} )
inherit cros-workon cros-board python-any-r1

DESCRIPTION="Chrome OS Firmware Bitmap Block"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform/bmpblk/"
SRC_URI=""
LICENSE="BSD-Google"
KEYWORDS="*"
IUSE="detachable diag_payload +minidiag physical_presence_power
	physical_presence_recovery"

BDEPEND="${PYTHON_DEPS}"
DEPEND="virtual/chromeos-vendor-strings"

src_prepare() {
	export BOARD="$(get_current_board_with_variant "${ARCH}-generic")"
	export VCSID

	default

	# if fontconfig's cache is empty, prepare single use cache.
	# That's still faster than having each process (of which there
	# are many) re-scan the fonts
	if find /usr/share/cache/fontconfig -maxdepth 0 -type d -empty \
		-exec false {} +; then

		return
	fi

	TMPCACHE=$(mktemp -d)
	cat > $TMPCACHE/local-conf.xml <<-EOF
		<?xml version="1.0"?>
		<!DOCTYPE fontconfig SYSTEM "fonts.dtd">
		<fontconfig>
		<cachedir>$TMPCACHE</cachedir>
		<include>/etc/fonts/fonts.conf</include>
		</fontconfig>
	EOF
	export FONTCONFIG_FILE=$TMPCACHE/local-conf.xml
	fc-cache -v
}

src_compile() {
	local vendor_strings_dir="${SYSROOT}/firmware/vendor-strings"
	if use detachable ; then
		export DETACHABLE=1
	fi

	# Both diag_payload and minidiag need additional UI images from
	# chromeos-bmpblk.
	if use diag_payload || use minidiag ; then
		export DIAGNOSTIC_UI=1
	fi
	if [[ -f "${vendor_strings_dir}/vendor_format.yaml" ]] ; then
		export VENDOR_STRINGS_DIR="${vendor_strings_dir}"
	fi
	if use physical_presence_power ; then
		export PHYSICAL_PRESENCE="power"
	elif use physical_presence_recovery ; then
		export PHYSICAL_PRESENCE="recovery"
	else
		export PHYSICAL_PRESENCE="keyboard"
	fi
	emake OUTPUT="${WORKDIR}" BOARD="${BOARD}"
	emake OUTPUT="${WORKDIR}/${BOARD}" ARCHIVER="/usr/bin/archive" archive
	if [[ "${BOARD}" == "${ARCH}-generic" ]]; then
		printf "1" > "${WORKDIR}/${BOARD}/vbgfx_not_scaled"
	fi
}

doins_if_exist() {
	local f
	for f in "$@"; do
		if [[ -r "${f}" ]]; then
			doins "${f}"
		fi
	done
}

src_install() {
	# Most bitmaps need to reside in the RO CBFS only. Many boards do
	# not have enough space in the RW CBFS regions to contain all
	# image files.
	insinto /firmware/cbfs-ro-compress
	# These files aren't necessary for debug builds. When these files
	# are missing, Depthcharge will render text-only screens. They look
	# obviously not ready for release.
	doins_if_exist "${WORKDIR}/${BOARD}"/vbgfx.bin
	doins_if_exist "${WORKDIR}/${BOARD}"/locales
	doins_if_exist "${WORKDIR}/${BOARD}"/locale/ro/locale_*.bin
	doins_if_exist "${WORKDIR}/${BOARD}"/font.bin
	# This flag tells the firmware_Bmpblk test to flag this build as
	# not ready for release.
	doins_if_exist "${WORKDIR}/${BOARD}"/vbgfx_not_scaled

	# However, if specific bitmaps need to be updated via RW update,
	# we should also install here.
	insinto /firmware/cbfs-rw-compress-override
	doins_if_exist "${WORKDIR}/${BOARD}"/locale/rw/rw_locale_*.bin
}
