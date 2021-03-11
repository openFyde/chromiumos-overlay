# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="a91bd716e1355dddae287aa3e7037af4b2f351e5"
CROS_WORKON_TREE=("eaed4f3b0a8201ef3951bf1960728885ff99e772" "c5ccad5905baea62de74e457b4e1085a36cb251a" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_DESTDIR="${S}/platform2"
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_SUBTREE="common-mk midis .gn"

PLATFORM_SUBDIR="midis"

inherit cros-workon git-2 platform user

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

src_unpack() {
	platform_src_unpack

	EGIT_REPO_URI="${CROS_GIT_HOST_URL}/chromium/src/media/midi.git" \
	# Since there are a few headers that are included by other headers
	# in this directory, and these headers are referenced assuming the
	# "media" directory is stored in the base directory, we install
	# the Git checkout in platform2.
	EGIT_SOURCEDIR="${S}/../media/midi" \
	EGIT_COMMIT="294d224ae7a8a695bb71337be8781b29abb5dafc" \
	git-2_src_unpack
}

src_install() {
	dobin "${OUT}"/midis

	insinto /etc/init
	doins init/*.conf

	# Install midis DBUS configuration file
	insinto /etc/dbus-1/system.d
	doins dbus_permissions/org.chromium.Midis.conf

	# Install D-Bus service activation configuration.
	insinto /usr/share/dbus-1/system-services
	doins dbus_permissions/org.chromium.Midis.service

	# Install seccomp policy file.
	insinto /usr/share/policy
	use seccomp && newins "seccomp/midis-seccomp-${ARCH}.policy" midis-seccomp.policy

	platform_fuzzer_install "${S}"/OWNERS "${OUT}"/midis_seq_handler_fuzzer
}

pkg_preinst() {
	enewuser midis
	enewgroup midis
}

platform_pkg_test() {
	local tests=(
		"midis_testrunner"
	)

	local test
	for test in "${tests[@]}"; do
		platform_test "run" "${OUT}"/${test}
	done
}
