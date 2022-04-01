# Copyright 2021 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

# No git repo for this so use empty-project.
CROS_WORKON_COMMIT="e8d0ce9c4326f0e57235f1acead1fcbc1ba2d0b9"
CROS_WORKON_TREE="f365214c3256d3259d78a5f4516923c79940b702"
CROS_WORKON_PROJECT="chromiumos/infra/build/empty-project"
CROS_WORKON_LOCALNAME="platform/empty-project"

inherit cros-workon

DESCRIPTION="Rootfs lacros for all architectures"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
S="${WORKDIR}"

# All runtime dependencies should already be part of
# chromeos-base/chromeos-chrome, the ones that aren't will be handled in
# crbug.com/1199441.
RDEPEND="chromeos-base/chromeos-chrome"
DEPEND=""

if [[ ${PV} != 9999 ]]; then
	ORIG_URI="gs://chrome-unsigned/desktop-5c0tCh"
	# arm64 will use arm32 build of lacros.
	SRC_URI="
		amd64? (
			${ORIG_URI}/${PV}/lacros64/lacros_compressed.squash -> ${PN}-amd64-squash-${PV}
			${ORIG_URI}/${PV}/lacros64/metadata.json -> ${PN}-amd64-metadata-${PV}
		)
		arm? (
			${ORIG_URI}/${PV}/lacros-arm32/lacros_compressed.squash -> ${PN}-arm-squash-${PV}
			${ORIG_URI}/${PV}/lacros-arm32/metadata.json -> ${PN}-arm-metadata-${PV}
		)
		arm64? (
			${ORIG_URI}/${PV}/lacros-arm32/lacros_compressed.squash -> ${PN}-arm-squash-${PV}
			${ORIG_URI}/${PV}/lacros-arm32/metadata.json -> ${PN}-arm-metadata-${PV}
		)
	"
fi

# Don't need to unpack anything.
# Also suppresses messages related to unpacking unrecognized formats.
src_unpack() {
	:
}

src_install() {
	insinto /opt/google/lacros
	if use amd64; then
		newins "${DISTDIR}/${PN}-amd64-squash-${PV}" lacros.squash
		newins "${DISTDIR}/${PN}-amd64-metadata-${PV}" metadata.json
	elif use arm || use arm64; then
		newins "${DISTDIR}/${PN}-arm-squash-${PV}" lacros.squash
		newins "${DISTDIR}/${PN}-arm-metadata-${PV}" metadata.json
	fi

	# Upstart configuration
	insinto /etc/init
	doins "${FILESDIR}/lacros-mounter.conf"
	doins "${FILESDIR}/lacros-unmounter.conf"

	# D-Bus configuration
	insinto /etc/dbus-1/system.d
	doins "${FILESDIR}/Lacros.conf"
}
