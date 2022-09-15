# Copyright 2017 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT=("1dffef3b5fa35642ed3ad2b54aa7554bf0d3ed60" "77cc36d72b2a07ce056c6dc57290b2e094db7931")
CROS_WORKON_TREE=("52639708fb7bf1a26ac114df488dc561a7ca9f3c" "63a2c33e4a92f07e290fd04ee505353f2f2dd170" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6" "4baf7cba90f916c94dd07c5746355f65e2ee0d8e")
CROS_WORKON_LOCALNAME=(
	"platform2"
	"chromium/src/media/midi"
)
CROS_WORKON_PROJECT=(
	"chromiumos/platform2"
	"chromium/src/media/midi"
)
CROS_WORKON_DESTDIR=(
	"${S}/platform2"
	"${S}/platform2/media/midi"
)
CROS_WORKON_EGIT_BRANCH="main"
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_SUBTREE=(
	"common-mk midis .gn"
	""
)

PLATFORM_SUBDIR="midis"

inherit cros-workon platform user

DESCRIPTION="MIDI Server for Chromium OS"
HOMEPAGE=""

LICENSE="BSD-Google"
KEYWORDS="*"
IUSE="+seccomp asan fuzzer"

COMMON_DEPEND="
	media-libs/alsa-lib:=
	chromeos-base/libbrillo:=[asan?,fuzzer?]
"

RDEPEND="${COMMON_DEPEND}"
DEPEND="${COMMON_DEPEND}"

src_install() {
	platform_install

	# fuzzer_component_id is unknown/unlisted
	platform_fuzzer_install "${S}"/OWNERS "${OUT}"/midis_seq_handler_fuzzer
}

pkg_preinst() {
	enewuser midis
	enewgroup midis
}

platform_pkg_test() {
	platform test_all
}
