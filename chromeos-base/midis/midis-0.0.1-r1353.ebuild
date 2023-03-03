# Copyright 2017 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT=("1c77f6728f1b4aabd016a79bdccabeba93680f9b" "77cc36d72b2a07ce056c6dc57290b2e094db7931")
CROS_WORKON_TREE=("3f8a9a04e17758df936e248583cfb92fc484e24c" "2e87e41d7e84a8893a401071b77ecfb84f1c9dc8" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6" "4baf7cba90f916c94dd07c5746355f65e2ee0d8e")
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
	platform_src_install

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
