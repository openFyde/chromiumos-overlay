# Copyright 2014 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="9cb9c2690334acd72449d9addde9d3355c20e991"
CROS_WORKON_TREE=("0c3a30cd50ce72094fbd880f2d16d449139646a2" "404e947d0fd65bbefd8352abb6355ff02bbc664e" "f5449c2a6e7673cc217eda5620c78ce1726e21b4" "df143cde88af1b7e2427d71c8519156768a0ef36" "8d856cb1fd8b7169075c5ae9c9a1ed9d4b8cbd6b" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6")
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_USE_VCSID=1
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
# TODO(crbug.com/809389): Avoid directly including headers from other packages.
CROS_WORKON_SUBTREE="common-mk chaps libhwsec libhwsec-foundation metrics .gn"

PLATFORM_SUBDIR="chaps"

inherit cros-workon platform systemd user

DESCRIPTION="PKCS #11 layer over TrouSerS"
HOMEPAGE="http://www.chromium.org/developers/design-documents/chaps-technical-design"
SRC_URI=""

LICENSE="BSD-Google"
KEYWORDS="*"
IUSE="profiling systemd test tpm_insecure_fallback fuzzer"

RDEPEND="
	chromeos-base/chaps-client:=
	chromeos-base/libhwsec:=[test?]
	chromeos-base/minijail:=
	chromeos-base/system_api:=[fuzzer?]
	>=chromeos-base/metrics-0.0.1-r3152:=
	chromeos-base/tpm_manager:=
	!dev-db/leveldb
	dev-libs/leveldb:=
	dev-libs/openssl:=
	dev-libs/protobuf:=
"

# Note: We need dev-libs/nss and dev-libs/nspr for the pkcs11 headers.
DEPEND="${RDEPEND}
	test? (
		app-arch/gzip
		app-arch/tar
	)
	chromeos-base/system_api:=[fuzzer?]
	fuzzer? ( dev-libs/libprotobuf-mutator )
	dev-libs/nss:=
	dev-libs/nspr:=
	"

pkg_setup() {
	enewgroup "chronos-access"
	enewuser "chaps"
	cros-workon_pkg_setup
}

src_compile() {
	platform_src_compile

	# After compile, check the output for link dependency on nss.
	# We should NOT have any link dependency on nss because nss imports chaps.
	local out=$(scanelf -qRyn "${OUT}" | grep nss)
	[[ -n "${out}" ]] && die "No link dependency on nss allowed:\n${out}"
	# No dependency on nspr as well, same as above.
	out=$(scanelf -qRyn "${OUT}" | grep nspr)
	[[ -n "${out}" ]] && die "No link dependency on nspr allowed:\n${out}"
}

src_install() {
	platform_src_install

	# Install init scripts for systemd the ones for upstart are installd via
	# BUILD.gn.
	if use systemd; then
		systemd_dounit init/chapsd.service
		systemd_enable_service boot-services.target chapsd.service
		systemd_dotmpfilesd init/chapsd_directories.conf
	fi

	# Chaps keeps database inside the user's cryptohome.
	local daemon_store="/etc/daemon-store/chaps"
	dodir "${daemon_store}"
	fperms 0750 "${daemon_store}"
	fowners chaps:chronos-access "${daemon_store}"

	local fuzzer_component_id="1281105"
	local fuzzers=(
		chaps_attributes_fuzzer
		chaps_object_store_fuzzer
		chaps_utility_fuzzer
		chaps_slot_manager_fuzzer
		chaps_chaps_service_fuzzer
	)
	for fuzzer in "${fuzzers[@]}"; do
		platform_fuzzer_install "${S}"/OWNERS "${OUT}"/"${fuzzer}" \
			--comp "${fuzzer_component_id}"
	done
}

platform_pkg_test() {
	platform test_all
}

pkg_preinst() {
	local ug
	for ug in pkcs11 chaps; do
		enewuser "${ug}"
		enewgroup "${ug}"
	done
}
