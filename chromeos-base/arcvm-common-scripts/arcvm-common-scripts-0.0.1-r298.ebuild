# Copyright 2018 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="5f05913184c2f17a1217b1faf88f95ae7fad93e9"
CROS_WORKON_TREE=("36bc32d34cdd5a8aa796661ad9ca401b99c7f218" "bc29adba57b7e34d511e0ceef32a4a13fdacddaf" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
CROS_WORKON_INCREMENTAL_BUILD="1"
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="common-mk arc/vm/scripts .gn"

inherit cros-workon

DESCRIPTION="ARCVM common scripts."
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/arc/vm/scripts"

LICENSE="BSD-Google"
KEYWORDS="*"

RDEPEND="
	${RDEPEND}
	!<=chromeos-base/arc-base-0.0.1-r349
	!<=chromeos-base/arc-common-scripts-0.0.1-r132
	chromeos-base/arcvm-mount-media-dirs
"

src_install() {
	dosbin arc/vm/scripts/android-sh

	insinto /etc/init
	doins arc/vm/scripts/init/arcvm-fsverity-certs.conf
	doins arc/vm/scripts/init/arcvm-host.conf
	doins arc/vm/scripts/init/arcvm-media-sharing-services.conf
	doins arc/vm/scripts/init/arcvm-post-login-services.conf
	doins arc/vm/scripts/init/arcvm-post-vm-start-services.conf
	doins arc/vm/scripts/init/arcvm-pre-login-services.conf
	doins arc/vm/scripts/init/arcvm-ureadahead.conf

	insinto /etc/dbus-1/system.d
	doins arc/vm/scripts/init/dbus-1/ArcVmScripts.conf

	insinto /usr/share/arcvm
	doins arc/vm/scripts/init/config.json

	insinto /usr/share/arcvm/fsverity-certs
	doins arc/vm/scripts/init/certs/fsverity-release.x509.der
	doins arc/vm/scripts/init/certs/play_store_fsi_cert.der
	doins arc/vm/scripts/init/certs/gms_fsverity_cert.der

	# Redirect ARCVM logs to arc.log.
	insinto /etc/rsyslog.d
	doins arc/vm/scripts/rsyslog.arc.conf
}
