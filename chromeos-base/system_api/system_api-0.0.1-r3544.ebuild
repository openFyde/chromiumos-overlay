# Copyright (c) 2011 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5

CROS_WORKON_COMMIT="df0b779fe523e3ffb9f121091cd271a01c567f34"
CROS_WORKON_TREE=("aa92b41330c5ee79fcd1757aa67b3bda7eec4ea2" "2c62e6d6cec0549400053a6a2e009e4ed06552ee" "dc1506ef7c8cfd2c5ffd1809dac05596ec18773c")
CROS_GO_PACKAGES=(
	"chromiumos/system_api/..."
)

CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="common-mk system_api .gn"

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
	dev-go/protobuf
	dev-libs/protobuf:=
	cros_host? ( net-libs/grpc:= )
"

src_unpack() {
	platform_src_unpack
	CROS_GO_WORKSPACE="${OUT}/gen/go"
}

src_install() {
	insinto /usr/"$(get_libdir)"/pkgconfig
	doins system_api.pc

	insinto /usr/include/chromeos
	doins -r dbus switches constants
	find "${D}" -name OWNERS -delete || die

	# Install the dbus-constants.h files in the respective daemons' client library
	# include directory. Users will need to include the corresponding client
	# library to access these files.
	local dir dirs=(
		biod
		cros-disks
		cryptohome
		debugd
		diagnosticsd
		dlcservice
		login_manager
		lorgnette
		oobe_config
		runtime_probe
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

	# These are files/projects installed in the common dir.
	dirs=( system_api )

	# These are project-specific files.
	dirs+=( $(
		cd "${S}/dbus" || die
		dirname */*.proto | sort -u
	) )

	for dir in "${dirs[@]}"; do
		insinto /usr/include/"${dir}"/proto_bindings
		doins "${OUT}"/gen/include/"${dir}"/proto_bindings/*.h

		if [[ "${dir}" == "system_api" ]]; then
			dolib.a "${OUT}/libsystem_api-protos.a"
		else
			dolib.a "${OUT}/libsystem_api-${dir}-protos.a"
		fi
	done

	cros-go_src_install
}
