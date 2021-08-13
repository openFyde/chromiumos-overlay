# Copyright 2014 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="65599f7ca758b43b0c8658b8b364837ac782cd8b"
CROS_WORKON_TREE=("73fb751c9106f337f066c9d61b57a04de20d80c0" "d0745d1765ae4f3bcb274b0b2ea28b4d78c666f8" "c32154ddfff8e0ed06738bee2835526d9d4d339b" "78962e3d2a3c90053e8fdeac3bc261921399557b" "092bd07d5419aa527ad8b7df2938ed7ec704594b" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
# TODO(crbug/1184685): "libhwsec" is not necessary; remove it after solving
# the bug.
CROS_WORKON_SUBTREE="common-mk libhwsec libhwsec-foundation metrics trunks .gn"

PLATFORM_SUBDIR="trunks"

inherit cros-workon platform user

DESCRIPTION="Trunks service for Chromium OS"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/master/trunks/"

LICENSE="Apache-2.0"
KEYWORDS="*"
IUSE="
	cr50_onboard
	csme_emulator
	fuzzer
	ftdi_tpm
	generic_tpm2
	pinweaver_csme
	test
	ti50_onboard
	tpm_dynamic
	tpm2_simulator
	vtpm_proxy
"

# This depends on protobuf because it uses protoc and needs to be rebuilt
# whenever the protobuf library is updated since generated source files may be
# incompatible across different versions of the protobuf library.
COMMON_DEPEND="
	>=chromeos-base/metrics-0.0.1-r3152:=
	chromeos-base/minijail:=
	chromeos-base/power_manager-client:=
	ftdi_tpm? ( dev-embedded/libftdi:= )
	tpm2_simulator? (
		chromeos-base/tpm2:=
		vtpm_proxy? ( chromeos-base/tpm2-simulator:= )
	)
	dev-libs/protobuf:=
	fuzzer? (
		dev-cpp/gtest:=
	)
	"

RDEPEND="
	${COMMON_DEPEND}
	cr50_onboard? ( chromeos-base/chromeos-cr50 )
	ti50_onboard? ( chromeos-base/chromeos-ti50 )
	generic_tpm2? ( chromeos-base/chromeos-cr50-scripts )
	!tpm_dynamic? ( !app-crypt/tpm-tools )
	chromeos-base/libhwsec-foundation
	"

DEPEND="
	${COMMON_DEPEND}
	chromeos-base/chromeos-ec-headers:=
	"

src_install() {
	insinto /etc/dbus-1/system.d
	doins org.chromium.Trunks.conf

	insinto /etc/init
	if use tpm2_simulator && ! use vtpm_proxy; then
		newins trunksd.conf.tpm2_simulator trunksd.conf
	elif use cr50_onboard || use ti50_onboard; then
		newins trunksd.conf.cr50 trunksd.conf
	else
		doins trunksd.conf
	fi

	if use tpm_dynamic; then
		sed -i '/env TPM_DYNAMIC=/s:=.*:=true:' \
			"${D}/etc/init/trunksd.conf" ||
			die "Can't activate tpm_dynamic in trunksd.conf"
	fi

	if use pinweaver_csme && use generic_tpm2; then
		newins csme/tpm_tunneld.conf tpm_tunneld.conf
	fi

	dosbin "${OUT}"/pinweaver_client
	dosbin "${OUT}"/trunks_client
	dosbin "${OUT}"/trunks_send
	if use tpm_dynamic; then
		newsbin tpm_version tpm2_version
	else
		dosbin tpm_version
	fi
	dosbin "${OUT}"/trunksd
	dolib.so "${OUT}"/lib/libtrunks.so
	# trunks_test library implements trunks mocks which
	# are used by unittest and fuzzer.
	if use test || use fuzzer; then
		dolib.a "${OUT}"/libtrunks_test.a
	fi

	if use pinweaver_csme && use generic_tpm2; then
		dosbin "${OUT}"/pinweaver_provision
		dosbin "${OUT}"/tpm_tunneld
	fi

	insinto /usr/share/policy
	newins "trunksd-seccomp-${ARCH}.policy" trunksd-seccomp.policy

	if use pinweaver_csme && use generic_tpm2; then
		newins "csme/tpm_tunneld-seccomp-${ARCH}.policy" tpm_tunneld-seccomp.policy
	fi

	insinto /usr/include/trunks
	doins *.h
	doins "${OUT}"/gen/include/trunks/*.h

	insinto /usr/include/proto
	doins "${S}"/pinweaver.proto

	insinto /usr/include/chromeos/dbus/trunks
	doins "${S}"/trunks_interface.proto

	insinto "/usr/$(get_libdir)/pkgconfig"
	doins "${OUT}"/obj/trunks/libtrunks.pc
	platform_fuzzer_install "${S}"/OWNERS "${OUT}"/trunks_creation_blob_fuzzer
	platform_fuzzer_install "${S}"/OWNERS \
		"${OUT}"/trunks_hmac_authorization_delegate_fuzzer
	platform_fuzzer_install "${S}"/OWNERS "${OUT}"/trunks_key_blob_fuzzer
	platform_fuzzer_install "${S}"/OWNERS \
		"${OUT}"/trunks_password_authorization_delegate_fuzzer
	platform_fuzzer_install "${S}"/OWNERS "${OUT}"/trunks_resource_manager_fuzzer
	platform_fuzzer_install "${S}"/OWNERS "${OUT}"/trunks_tpm_pinweaver_fuzzer
}

platform_pkg_test() {
	"${S}/generator/generator_test.py" || die

	local tests=(
		trunks_testrunner
	)

	local test_bin
	for test_bin in "${tests[@]}"; do
		platform_test "run" "${OUT}/${test_bin}"
	done
}

pkg_preinst() {
	enewuser trunks
	enewgroup trunks
	if use pinweaver_csme && use generic_tpm2; then
		enewuser tpm_tunneld
		enewgroup tpm_tunneld
	fi
}
