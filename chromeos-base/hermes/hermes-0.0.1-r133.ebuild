# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

CROS_WORKON_COMMIT="f64c1749b81099c31822e6c99d229a1e250a8d5b"
CROS_WORKON_TREE=("11f584bb7dd3244e1eec145f7e377b32b68e8b3b" "80eca6700f50b518bae01c1ec8cbf5fc5764fba3" "dc1506ef7c8cfd2c5ffd1809dac05596ec18773c")
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_SUBTREE="common-mk hermes .gn"

PLATFORM_SUBDIR="hermes"

inherit cros-workon platform user

DESCRIPTION="Chrome OS eSIM/EUICC integration"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/master/hermes"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
IUSE=""

RDEPEND="
	chromeos-base/libbrillo:=
	"

DEPEND="
	${RDEPEND}
	chromeos-base/google-lpa:=
	chromeos-base/system_api:=
	"

src_install() {
	dobin "${OUT}"/hermes

	# Install CA certs.
	local cert_dir=/usr/share/hermes-ca-certificates
	insinto "${cert_dir}"
	doins -r certs/*
	c_rehash "${D}/${cert_dir}/prod" || die
	c_rehash "${D}/${cert_dir}/test" || die

	# Install upstart config.
	insinto /etc/init
	doins init/hermes.conf

	# Install DBus config.
	insinto /etc/dbus-1/system.d
	doins dbus/org.chromium.Hermes.conf

	# Install DBus interface.
	insinto /usr/share/dbus-1/interfaces
	doins dbus_bindings/org.chromium.Hermes.xml
}

platform_pkg_test() {
	platform_test "run" "${OUT}/hermes_test"
}

pkg_preinst() {
	enewuser "hermes"
	enewgroup "hermes"
}
