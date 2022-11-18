# Copyright 2017 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT=("655a5e80b4ee792762b837cd699d929c4ab9d86d" "77cc36d72b2a07ce056c6dc57290b2e094db7931")
CROS_WORKON_TREE=("ebcce78502266e81f55c63ade8f25b8888e2c103" "6fda24b237d5f1a58e29d9846bc190c99ec3fd58" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6" "4baf7cba90f916c94dd07c5746355f65e2ee0d8e")
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
