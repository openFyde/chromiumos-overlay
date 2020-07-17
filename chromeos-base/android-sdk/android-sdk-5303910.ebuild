# Copyright 2020 Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Android SDK"
HOMEPAGE="http://developer.android.com"
SRC_URI="https://ci.android.com/builds/submitted/${PV}/sdk/latest/android-sdk_${PV}_linux-x86.zip"

LICENSE="
	Apache-2.0
	BSD
	BSD-2
	BSD-4
	CPL-1.0
	EPL-1.0
	FTL
	GPL-2
	IJG
	ISC
	icu
	LGPL-2
	LGPL-2.1
	libpng
	MIT
	MPL-1.1
	openssl
	SGI-B-2.0
	UoI-NCSA
	ZLIB
	W3C
	"
SLOT="0"
KEYWORDS="*"
IUSE="android-container-pi"
RESTRICT="strip"

DEPEND=""
# Android P depends on Java 8 or 9. Android R depends on Java 9 or later.
# !android-container-pi includes all the android-vm-* versions like:
#   android-vm-rvc and android-vm-master
RDEPEND="
	android-container-pi? ( <=virtual/jdk-9 )
	!android-container-pi? ( >=virtual/jdk-9 )
	>=dev-java/ant-core-1.6.5
	sys-libs/zlib"
BDEPEND=""

ANDROID_SDK_DIR="/opt/android-sdk"

S="${WORKDIR}/${PN}_${PV}_linux-x86"

src_install() {
	insinto "${ANDROID_SDK_DIR}"
	doins -r platforms
	insopts "-m0755"
	doins -r build-tools
}
