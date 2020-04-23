# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="e5eb5a1bb994b6ea193e59891b7b585237c8032f"
CROS_WORKON_TREE=("2b7b46ab1083cdcc8b17bd7f5b05ddff336b0559" "e384f36ae22a1f2846b3887aa8f117037373fb58" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
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
KEYWORDS="*"
IUSE=""

DEPEND="
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
	doins dbus_bindings/org.chromium.Hermes.Manager.xml
	doins dbus_bindings/org.chromium.Hermes.Profile.xml
}

platform_pkg_test() {
	platform_test "run" "${OUT}/hermes_test"
}

pkg_preinst() {
	enewuser "hermes"
	enewgroup "hermes"
}
