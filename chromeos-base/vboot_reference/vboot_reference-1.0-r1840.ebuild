# Copyright (c) 2012 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="53ddd2ac9a62c17d2a59851895e35f535546485d"
CROS_WORKON_TREE="081c1efa13a66d6decf69fa5a27581c019c2963f"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_PROJECT="chromiumos/platform/vboot_reference"
CROS_WORKON_LOCALNAME="platform/vboot_reference"

inherit cros-debug cros-fuzzer cros-sanitizers cros-workon

DESCRIPTION="Chrome OS verified boot tools"

LICENSE="BSD-Google"
KEYWORDS="*"
IUSE="cros_host dev_debug_force fuzzer pd_sync tpmtests tpm tpm2"

REQUIRED_USE="?? ( tpm2 tpm )"

COMMON_DEPEND="dev-libs/libzip:=
	dev-libs/openssl:=
	sys-apps/util-linux:="
RDEPEND="${COMMON_DEPEND}"
DEPEND="${COMMON_DEPEND}"

src_configure() {
	cros-workon_src_configure

	# Determine sanitizer flags. This is necessary because the Makefile
	# purposely ignores CFLAGS from the environment. So we collect the
	# sanitizer flags and pass just them to the Makefile explicitly.
	SANITIZER_CFLAGS=$(
		append-flags() {
			printf "%s" "$* "
		}
		sanitizers-setup-env
	)
	if use_sanitizers; then
		# Disable alignment sanitization and memory leak checks,
		# https://crbug.com/1015908 .
		SANITIZER_CFLAGS+=" -fno-sanitize=alignment"
		export ASAN_OPTIONS+=":detect_leaks=0:"
	fi
}

vemake() {
	emake \
		SRCDIR="${S}" \
		LIBDIR="$(get_libdir)" \
		ARCH=$(tc-arch) \
		SDK_BUILD=$(usev cros_host) \
		TPM2_MODE=$(usev tpm2) \
		PD_SYNC=$(usev pd_sync) \
		DEV_DEBUG_FORCE=$(usev dev_debug_force) \
		FUZZ_FLAGS="${SANITIZER_CFLAGS}" \
		"$@"
}

src_compile() {
	mkdir "${WORKDIR}"/build-main
	tc-export CC AR CXX PKG_CONFIG
	cros-debug-add-NDEBUG
	# vboot_reference knows the flags to use
	unset CFLAGS
	vemake BUILD="${WORKDIR}"/build-main $(usex fuzzer fuzzers all)
}

src_test() {
	! use amd64 && ! use x86 && ewarn "Skipping unittests for non-x86" && return 0
	vemake BUILD="${WORKDIR}"/build-main runtests
}

src_install() {
	if use fuzzer; then
		einfo "Installing fuzzers"
		fuzzer_install "${S}"/OWNERS "${WORKDIR}"/build-main/tests/cgpt_fuzzer
		fuzzer_install "${S}"/OWNERS "${WORKDIR}"/build-main/tests/vb2_keyblock_fuzzer
		fuzzer_install "${S}"/OWNERS "${WORKDIR}"/build-main/tests/vb2_preamble_fuzzer
		return
	fi

	einfo "Installing programs"
	vemake \
		BUILD="${WORKDIR}"/build-main \
		DESTDIR="${D}" \
		install

	if use cros_host; then
		exeinto /usr/share/vboot/bin
		doexe scripts/image_signing/*.sh
	fi

	if use tpmtests; then
		into /usr
		# copy files starting with tpmtest, but skip .d files.
		dobin "${WORKDIR}"/build-main/tests/tpm_lite/tpmtest*[^.]?
		dobin "${WORKDIR}"/build-main/utility/tpm_set_readsrkpub
	fi

	# Install devkeys to /usr/share/vboot/devkeys
	# (shared by host and target)
	einfo "Installing devkeys"
	insinto /usr/share/vboot/devkeys
	doins tests/devkeys/*

	# Install public headers to /build/${BOARD}/usr/include/vboot
	einfo "Installing header files"
	insinto /usr/include/vboot
	doins host/include/* \
		firmware/include/gpt.h \
		firmware/include/tlcl.h \
		firmware/include/tss_constants.h \
		firmware/include/tpm1_tss_constants.h \
		firmware/include/tpm2_tss_constants.h

	einfo "Installing host library"
	dolib.a "${WORKDIR}"/build-main/libvboot_host.a
}
