# Copyright 2014 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

CROS_WORKON_COMMIT=("6549ea0eb91e124c3b9b75f77edc8e064b48813b" "66c5220045468a246bc17aa57f2aaed8bb528b49")
CROS_WORKON_TREE=("7af090f4e3d17daa9e628424e4d774e246757618" "f91b6afd5f2ae04ee9a2c19109a3a4a36f7659e6" "ec8482ff4ea3e443420aabf9a5a3b77874e42549")
CROS_WORKON_PROJECT=("chromiumos/platform2" "chromiumos/platform/libchrome")
CROS_WORKON_LOCALNAME=("platform2" "platform/libchrome")
CROS_WORKON_EGIT_BRANCH=("main" "main")
CROS_WORKON_DESTDIR=("${S}/platform2" "${S}/platform2/libchrome")
CROS_WORKON_SUBTREE=("common-mk .gn" "")

WANT_LIBCHROME="no"
inherit cros-workon platform

DESCRIPTION="Chrome base/ and dbus/ libraries extracted for use on Chrome OS"
HOMEPAGE="http://dev.chromium.org/chromium-os/packages/libchrome"
SRC_URI=""

LICENSE="BSD-Google"
KEYWORDS="*"
# TODO(b/204383858): remove 'endeavour' when patch
# backward-compatibility-add-base-AdaptCallbackForRepaeting.patch is not needed
IUSE="cros_host +crypto +dbus fuzzer +mojo media_perception"

PLATFORM_SUBDIR="libchrome"

# TODO(avakulenko): Put dev-libs/nss behind a USE flag to make sure NSS is
# pulled only into the configurations that require it.
# TODO(fqj): remove !chromeos-base/libchrome-${BASE_VER} on next uprev to r680000.
RDEPEND="
	>=chromeos-base/perfetto-21.0-r4:=
	>=dev-cpp/abseil-cpp-20200923-r4:=
	dev-libs/double-conversion:=
	dev-libs/glib:2=
	dev-libs/libevent:=
	dev-libs/modp_b64:=
	crypto? (
		dev-libs/nss:=
		dev-libs/openssl:=
	)
	dbus? (
		sys-apps/dbus:=
		dev-libs/protobuf:=
	)
	dev-libs/re2:=
	!~chromeos-base/libchrome-576279
	!chromeos-base/libchrome:576279
	!chromeos-base/libchrome:462023
	!chromeos-base/libchrome:456626
	!chromeos-base/libchrome:395517
"
DEPEND="${RDEPEND}
	dev-cpp/gtest:=
"

# libmojo used to be in a separate package, which now conflicts with libchrome.
# Add softblocker here, to resolve the conflict, in case building the package
# on the environment where old libmojo is installed.
# TODO(hidehiko): Clean up the blocker after certain period.
RDEPEND="${RDEPEND}
	!chromeos-base/libmojo"

# libmojo depends on libbase-crypto.
REQUIRED_USE="mojo? ( crypto )"

src_prepare() {
	# Apply patches
	while read -ra patch_config; do
		local patch="${patch_config[0]}"
		local use_flag="${patch_config[1]}"
		if [ -n "${use_flag}" ]; then
			if ! use "${use_flag}"; then
				einfo "Skipped ${patch}"
				continue
			fi
		fi
		if [[ ${patch} == *.patch ]]; then
			eapply "${S}/libchrome_tools/patches/${patch}"
		elif [[ -x "${S}/libchrome_tools/patches/${patch}" ]]; then
			einfo "Applying ${patch} ..."
			"${S}/libchrome_tools/patches/${patch}" || die "failed to patch by running script ${patch}"
		else
			die "Invalid patch file ${patch}"
		fi
	done < <(grep -E '^[^#]' "${S}/libchrome_tools/patches/patches")
	eapply_user
}

src_configure() {
	cros_optimize_package_for_speed
	platform_src_configure
}

src_test() {
	pushd libchrome_tools || die
	python3 -m unittest check_libchrome_test || die "failed python3 check-libchrome-test.py"
	pushd uprev || die
	python3 ./run_tests.py || die "failed python3 libchrome/uprev/run_tests.py"
	popd || die
	pushd developer-tools || die
	python3 -m unittest test_change_header || die "failed python3 test_change_headerpy"
	popd || die
	popd || die
	platform_test "run" "${OUT}/optional_unittests"
}

src_install() {
	platform_install

	dolib.so "${OUT}"/lib/libbase*.so
	dolib.a "${OUT}"/libbase*.a

	local mojom_dirs=()

	insinto "/usr/$(get_libdir)/pkgconfig"
	doins "${OUT}"/obj/libchrome/libchrome*.pc

	# Install libmojo.
	if use mojo; then
		# Install binary.
		dolib.so "${OUT}"/lib/libmojo.so

		# Install headers.
		mojom_dirs+=(
			mojo/public/interfaces/bindings
			mojo/public/mojom/base
		)

		# Install libmojo.pc.
		insinto "/usr/$(get_libdir)/pkgconfig"
		doins "${OUT}"/obj/libchrome/libmojo.pc

		# Install generate_mojom_bindings.
		# TODO(hidehiko): Clean up tools' install directory.
		insinto /usr/src/libmojo/mojo
		doins -r mojo/public/tools/bindings/*
		doins -r mojo/public/tools/mojom/*
		doins build/gn_helpers.py
		doins -r build/android/gyp/util
		doins -r build/android/pylib
		exeinto /usr/src/libmojo/mojo
		doexe libchrome_tools/mojom_generate_type_mappings.py

		insinto /usr/src/libmojo/third_party
		doins -r third_party/jinja2
		doins -r third_party/markupsafe
		doins -r third_party/ply

		# Mark scripts executable.
		fperms +x \
			/usr/src/libmojo/mojo/generate_type_mappings.py \
			/usr/src/libmojo/mojo/mojom_bindings_generator.py \
			/usr/src/libmojo/mojo/mojom_parser.py
	fi

	# Install header files.
	local d
	for d in "${mojom_dirs[@]}"; do
		insinto /usr/include/libchrome/"${d}"
		doins "${OUT}"/gen/include/"${d}"/*.h
		# Not to install mojom and pickle file to prevent misuse until Chromium IPC
		# team is ready to have a stable mojo_base. see crbug.com/1055379
		# insinto /usr/src/libchrome/mojom/"${d}"
		# doins "${S}"/"${d}"/*.mojom
		# insinto /usr/share/libchrome/pickle/"${d}"
		# doins "${OUT}"/gen/include/"${d}"/*.p
	done

	# TODO(fqj): Revisit later for type mapping (see libchrome/BUILD.gn)
	# Install libchrome base type mojo mapping
	# if use mojo; then
		# insinto /usr/share/libchrome/mojom_type_mappings_typemapping
		# doins "${OUT}"/gen/libchrome/mojom_type_mappings_typemapping
	# fi
}
