# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT=("1f83d6ba0a311c5e4bc574208981d32f0a66660c" "77cc36d72b2a07ce056c6dc57290b2e094db7931")
CROS_WORKON_TREE=("da0a96cefc74908f44298f304bea19b64e602847" "31231d9b91954e1332b0c70e98f518eed9f27186" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb" "4baf7cba90f916c94dd07c5746355f65e2ee0d8e")
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
