# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

EAPI="6"
CROS_WORKON_COMMIT="86eea6ef7adb8a0a3cfc7cb3f9b12da4d114eeec"
CROS_WORKON_TREE="9a591a98ee1c52674918aa879386be794d3fec87"
CROS_WORKON_PROJECT="chromiumos/third_party/hostap"
CROS_WORKON_LOCALNAME="../third_party/wpa_supplicant-2.8"

PYTHON_COMPAT=( python3_{6,7} )

inherit cros-workon distutils-r1 toolchain-funcs

DESCRIPTION="Test package for the hostap project, intended for a VM"
HOMEPAGE="https://w1.fi"

LICENSE="BSD"
SLOT="0"
KEYWORDS="*"
IUSE="dbus"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DEPEND="net-libs/libpcap:="

# pygobject with python3 support requires recent versions (e.g., 3.28.3 --
# http://crrev.com/c/1869550), but recent versions are more difficult to
# cross-compile (gobject-introspection, in particular). Leave this behind an
# optional 'dbus' USE flag for now. Hwsim tests will skip D-Bus tests if
# libraries aren't available.
RDEPEND="${DEPEND}
	${PYTHON_DEPS}
	dbus? (
		dev-python/dbus-python[${PYTHON_USEDEP}]
		dev-python/pygobject[${PYTHON_USEDEP}]
	)
	dev-python/pycryptodome[${PYTHON_USEDEP}]
	dev-python/pyrad[${PYTHON_USEDEP}]
	net-analyzer/wireshark
	net-wireless/hostapd[wifi_hostap_test]
	net-wireless/wpa_supplicant-2_8[wifi_hostap_test]
"

src_unpack() {
	cros-workon_src_unpack
}

src_configure() {
	# Nothing to do.
	:
}

src_compile() {
	emake -C wlantest V=1
}

src_install() {
	local install_dir="/usr/libexec/hostap"
	exeinto "${install_dir}"/wlantest
	doexe wlantest/wlantest wlantest/wlantest_cli wlantest/test_vectors

	dodir "${install_dir}"/tests
	cp -pPR "${S}"/tests/hwsim "${D}/${install_dir}"/tests || die
	cp -pPR "${S}"/wpaspy "${D}/${install_dir}" || die

	# We have a few wrapper scripts, to overlay onto the hostap
	# source/build hierarchy.
	local run="${FILESDIR}/runme.sh"
	exeinto "${install_dir}"/hostapd
	local exe
	for exe in hostapd hostapd_cli hlr_auc_gw; do
		newexe "${run}" "${exe}"
	done
	exeinto "${install_dir}"/wpa_supplicant
	for exe in wpa_supplicant wpa_cli; do
		newexe "${run}" "${exe}"
	done
}
