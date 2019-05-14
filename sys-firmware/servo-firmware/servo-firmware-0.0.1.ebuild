# Copyright 2017 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

DESCRIPTION="Firmware for tools based on Chromium OS EC"
HOMEPAGE="https://www.chromium.org/chromium-os/ec-development"

SERVO_MICRO_NAME="servo_micro_v2.3.7-096c7ee84" # servo-firmware-R70-11011.14.0
SERVO_V4_NAME="servo_v4_v2.3.7-096c7ee84"       # servo-firmware-R70-11011.14.0
SWEETBERRY_NAME="sweetberry_v2.3.7-096c7ee84"   # servo-firmware-R70-11011.14.0
UPDATER_PATH="/usr/share/servo_updater/firmware"

MIRROR_PATH="gs://chromeos-localmirror/distfiles/"

SRC_URI="
	${MIRROR_PATH}/${SERVO_MICRO_NAME}.tar.gz
	${MIRROR_PATH}/${SERVO_V4_NAME}.tar.gz
	${MIRROR_PATH}/${SWEETBERRY_NAME}.tar.gz
	"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
ISUE=""

DEPEND=""
RDEPEND="!<chromeos-base/ec-devutils-0.0.2"

S="${WORKDIR}"

src_install() {
	insinto "${UPDATER_PATH}"
	doins "${SERVO_MICRO_NAME}.bin"
	dosym "${SERVO_MICRO_NAME}.bin" "${UPDATER_PATH}/servo_micro.bin"

	doins "${SERVO_V4_NAME}.bin"
	dosym "${SERVO_V4_NAME}.bin" "${UPDATER_PATH}/servo_v4.bin"

	doins "${SWEETBERRY_NAME}.bin"
	dosym "${SWEETBERRY_NAME}.bin" "${UPDATER_PATH}/sweetberry.bin"
}
