# Copyright (c) 2011 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5

CROS_WORKON_COMMIT=("86fed24396246733bae4c963ed5208bff777fb61" "a9ac639b38af7ad3d745975ad850cbde73fbb7ee")
CROS_WORKON_TREE=("32c5802f3fce5f474cfae5f70fb058b1df68675f" "ac9cf3c6cf6f3fabdf385f919ed420cb51f454f8")
CROS_GO_PACKAGES=(
	"chromiumos/system_api/vm_cicerone_proto"
	"chromiumos/system_api/vm_concierge_proto"
)

CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_LOCALNAME=(
	"platform2"
	"platform/system_api"
)
CROS_WORKON_PROJECT=(
	"chromiumos/platform2"
	"chromiumos/platform/system_api"
)
CROS_WORKON_DESTDIR=(
	"${S}/platform2"
	"${S}/platform/system_api"
)
CROS_WORKON_SUBTREE=(
	"common-mk"
	""
)

PLATFORM_SUBDIR="system_api"

inherit cros-go cros-workon toolchain-funcs platform

DESCRIPTION="Chrome OS system API (D-Bus service names, etc.)"
HOMEPAGE="http://www.chromium.org/"
LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
IUSE="cros_host"

RDEPEND="chromeos-base/libmojo"

DEPEND="${RDEPEND}
	dev-libs/protobuf
	cros_host? ( dev-libs/grpc )
"

src_unpack() {
	local s="${S}"
	platform_src_unpack

	# The platform eclass will look for system_api in src/platform2.
	# This forces it to look in src/platform.
	S="${s}/platform/system_api"
	CROS_GO_WORKSPACE="${OUT}/gen/go"
}

src_install() {
	dolib.a "${OUT}"/libsystem_api*.a

	insinto /usr/"$(get_libdir)"/pkgconfig
	doins system_api.pc

	rm dbus/power_manager/OWNERS

	insinto /usr/include/chromeos
	doins -r dbus switches constants

	# Install the dbus-constants.h files in the respective daemons' client library
	# include directory. Users will need to include the corresponding client
	# library to access these files.
	local dir dirs=(
		apmanager
		biod
		cros-disks
		cryptohome
		debugd
		login_manager
		lorgnette
		permission_broker
		power_manager
		shill
		smbprovider
		update_engine
	)
	for dir in "${dirs[@]}"; do
		insinto /usr/include/"${dir}"-client/"${dir}"
		doins dbus/"${dir}"/dbus-constants.h
	done

	dirs=(
		authpolicy biod chaps cryptohome login_manager power_manager smbprovider system_api vm_applications vm_cicerone vm_concierge
	)
	for dir in "${dirs[@]}"; do
		insinto /usr/include/"${dir}"/proto_bindings
		doins -r "${OUT}"/gen/include/"${dir}"/proto_bindings/*.h
	done

	cros-go_src_install
}
