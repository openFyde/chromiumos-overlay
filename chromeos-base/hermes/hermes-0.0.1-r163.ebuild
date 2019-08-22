# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

CROS_WORKON_COMMIT="66ed10a4e172bdd47b4e08f1661fe21e975c2ef9"
CROS_WORKON_TREE=("730940d1ad982b0928be2d517a8583b66235e15e" "5147f6dda3db9b3af3621302f271831108c54bcc" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
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
