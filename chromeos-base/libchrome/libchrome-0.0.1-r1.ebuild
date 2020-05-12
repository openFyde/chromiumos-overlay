# Copyright 2014 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

CROS_WORKON_COMMIT=("fea991ebac790d1fb84ef7368b38abc00cacafda" "9bafc0a74a272a3fc0e5586d85bd788e69942216")
CROS_WORKON_TREE=("beaa4ae826abb3520fd39561f6556ff65c85078d" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb" "69452cd7575dc1e2846d4d05bf3fef9f6676c066")
CROS_WORKON_PROJECT=("chromiumos/platform2" "aosp/platform/external/libchrome")
CROS_WORKON_LOCALNAME=("platform2" "aosp/external/libchrome")
CROS_WORKON_DESTDIR=("${S}/platform2" "${S}/platform2/libchrome")
CROS_WORKON_SUBTREE=("common-mk .gn" "")

WANT_LIBCHROME="no"
inherit cros-workon libchrome-version platform

DESCRIPTION="Chrome base/ and dbus/ libraries extracted for use on Chrome OS"
HOMEPAGE="http://dev.chromium.org/chromium-os/packages/libchrome"
SRC_URI=""

LICENSE="BSD-Google"
KEYWORDS="*"
IUSE="cros_host +crypto +dbus fuzzer +mojo +timers"

PLATFORM_SUBDIR="libchrome"

# TODO(avakulenko): Put dev-libs/nss behind a USE flag to make sure NSS is
# pulled only into the configurations that require it.
# TODO(fqj): remove !chromeos-base/libchrome-${BASE_VER} on next uprev to r680000.
RDEPEND="dev-libs/glib:2=
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
	!~chromeos-base/libchrome-${BASE_VER}
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
	# epatch "${FILESDIR}"/${PN}-Replace-std-unordered_map-with-std-map-for-dbus-Prop.patch
	# epatch "${FILESDIR}"/${PN}-dbus-Filter-signal-by-the-sender-we-are-interested-i.patch
	# epatch "${FILESDIR}"/${PN}-dbus-Make-MockObjectManager-useful.patch
	# epatch "${FILESDIR}"/${PN}-dbus-Don-t-DCHECK-unexpected-message-type-but-ignore.patch
	# epatch "${FILESDIR}"/${PN}-Mock-more-methods-of-dbus-Bus-in-dbus-MockBus.patch

	# Cherry pick CLs from upstream.
	# Remove these when the libchrome gets enough new.
	# r576565.
	epatch "${FILESDIR}"/${PN}-dbus-Add-TryRegisterFallback.patch

	# r581937.
	epatch "${FILESDIR}"/${PN}-dbus-Remove-LOG-ERROR-in-ObjectProxy.patch

	# r582324
	epatch "${FILESDIR}"/${PN}-Fix-Wdefaulted-function-deleted-warning-in-MessageLo.patch

	# r583543.
	epatch "${FILESDIR}"/${PN}-dbus-Make-Bus-is_connected-mockable.patch

	# r596510.
	epatch "${FILESDIR}"/${PN}-Mojo-Check-if-dispatcher-is-null-in-Core-UnwrapPlatf.patch

	# This no_destructor.h is taken from r599267.
	epatch "${FILESDIR}"/${PN}-Add-base-NoDestructor-T.patch

	# r616020.
	epatch "${FILESDIR}"/${PN}-dbus-Support-UnexportMethod-from-an-exported-object.patch

	# Add support for SimpleAlarmTimer::Create{,ForTesting} to reflect changes in r626151.
	epatch "${FILESDIR}"/${PN}-Refactor-AlarmTimer-to-report-error-to-the-caller.patch

	# For backward compatibility.
	# TODO(crbug.com/909719): Remove this patch after clients are updated.
	epatch "${FILESDIR}"/${PN}-libchrome-Add-EmptyResponseCallback-for-backward-com.patch

	# Undo gn_helper sys.path update.
	epatch "${FILESDIR}"/${PN}-libchrome-Unpatch-sys.path-update.patch

	# Introduce stub ConvertableToTraceFormat for task_scheduler.
	epatch "${FILESDIR}"/${PN}-libchrome-Introduce-stub-ConvertableToTraceFormat.patch

	# Disable custom memory allocator when asan is used.
	# https://crbug.com/807685
	use_sanitizers && epatch "${FILESDIR}"/${PN}-Disable-memory-allocator.patch

	# Disable object lifetime tracking since it cuases memory leaks in
	# sanitizer builds, https://crbug.com/908138
	# TODO
	# epatch "${FILESDIR}"/${PN}-Disable-object-tracking.patch

	# Remove this patch after libchrome uprev past r626151.

	# Fix timing issue with dbus::ObjectManager.
	# # TODO(bingxue): Remove after libchrome uprev past r684392.
	epatch "${FILESDIR}"/${PN}-Connect-to-NameOwnerChanged-signal-when-setting-call.patch

	# Remove glib dependency.
	# TODO(hidehiko): Fix the config in AOSP libchrome.
	epatch "${FILESDIR}"/${PN}-libchrome-Remove-glib-dependency.patch

	# Fix FileDescriptorWatcher leak
	# TODO(fqj): Remove after libchrome past r627021.
	epatch "${FILESDIR}"/${PN}-fix-fd-watcher-leak.patch

	# Use correct shebang for these python2-only scripts.
	find "${S}"/mojo/ -name '*.py' \
		-exec sed -i -E '1{ /^#!/ s:(env )?python$:python2: }' {} +

	# Misc fix to build older crypto library.
	epatch "${FILESDIR}"/${PN}-libchrome-Update-crypto.patch

	# Enable location source to add function_name
	epatch "${FILESDIR}"/${PN}-enable-location-source.patch

	# Add WaitForServiceToBeAvailable back for MockObjectProxy
	epatch "${FILESDIR}"/${PN}-WaitForServiceToBeAvailable.patch

	# TODO(crbug.com/1044363): Remove after uprev >= r586219.
	epatch "${FILESDIR}"/${PN}-Fix-TimeDelta.patch

	# TODO(crbug.com/1065504): Remove after uprev to 754979.
	epatch "${FILESDIR}"/${PN}-libchrome-fix-integer-overflow-if-microseconds-is-IN.patch

	# Forward compatibility for r680000
	epatch "${FILESDIR}"/${PN}-r680000-forward-compatibility-patch-part-1.patch
	epatch "${FILESDIR}"/${PN}-r680000-forward-compatibility-patch-part-2.patch
}

src_install() {
	dolib.so "${OUT}"/lib/libbase*-"${BASE_VER}".so
	dolib.a "${OUT}"/libbase*-"${BASE_VER}".a

	local mojom_dirs=()
	local header_dirs=(
		base
		base/allocator
		base/containers
		base/debug
		base/files
		base/hash
		base/i18n
		base/json
		base/memory
		base/message_loop
		base/metrics
		base/numerics
		base/posix
		base/process
		base/strings
		base/synchronization
		base/system
		base/task
		base/task_scheduler
		base/third_party/icu
		base/third_party/nspr
		base/third_party/valgrind
		base/threading
		base/time
		base/timer
		base/trace_event
		base/trace_event/common
		build
		components/policy
		components/policy/core/common
		testing/gmock/include/gmock
		testing/gtest/include/gtest
	)
	use dbus && header_dirs+=( dbus )
	use timers && header_dirs+=( components/timers )

	insinto /usr/include/base-"${BASE_VER}"/base/test
	doins \
		base/test/bind_test_util.h \
		base/test/scoped_task_environment.h \
		base/test/simple_test_clock.h \
		base/test/simple_test_tick_clock.h \
		base/test/test_mock_time_task_runner.h \
		base/test/test_pending_task.h \

	if use crypto; then
		insinto /usr/include/base-${BASE_VER}/crypto
		doins \
			crypto/crypto_export.h \
			crypto/hmac.h \
			crypto/libcrypto-compat.h \
			crypto/nss_key_util.h \
			crypto/nss_util.h \
			crypto/nss_util_internal.h \
			crypto/openssl_util.h \
			crypto/p224.h \
			crypto/p224_spake.h \
			crypto/random.h \
			crypto/rsa_private_key.h \
			crypto/scoped_nss_types.h \
			crypto/scoped_openssl_types.h \
			crypto/scoped_test_nss_db.h \
			crypto/secure_hash.h \
			crypto/secure_util.h \
			crypto/sha2.h \
			crypto/signature_creator.h \
			crypto/signature_verifier.h
	fi

	insinto /usr/$(get_libdir)/pkgconfig
	doins "${OUT}"/obj/libchrome/libchrome*-"${BASE_VER}".pc

	# Install libmojo.
	if use mojo; then
		# Install binary.
		dolib.a "${OUT}"/libmojo-"${BASE_VER}".a

		# Install headers.
		header_dirs+=(
			ipc
			mojo/core/
			mojo/core/embedder
			mojo/core/ports
			mojo/public/c/system
			mojo/public/cpp/base
			mojo/public/cpp/bindings
			mojo/public/cpp/bindings/lib
			mojo/public/cpp/platform
			mojo/public/cpp/system
		)
		mojom_dirs+=(
			mojo/public/interfaces/bindings
			mojo/public/mojom/base
		)

		# Install libmojo.pc.
		insinto /usr/$(get_libdir)/pkgconfig
		doins "${OUT}"/obj/libchrome/libmojo-"${BASE_VER}".pc

		# Install generate_mojom_bindings.
		# TODO(hidehiko): Clean up tools' install directory.
		insinto /usr/src/libmojo-"${BASE_VER}"/mojo
		doins -r mojo/public/tools/bindings/*
		doins build/gn_helpers.py
		doins -r build/android/gyp/util
		doins -r build/android/pylib
		exeinto /usr/src/libmojo-"${BASE_VER}"/mojo
		doexe libchrome_tools/mojom_generate_type_mappings.py

		insinto /usr/src/libmojo-"${BASE_VER}"/third_party
		doins -r third_party/jinja2
		doins -r third_party/markupsafe
		doins -r third_party/ply

		# Mark scripts executable.
		fperms +x \
			/usr/src/libmojo-"${BASE_VER}"/mojo/generate_type_mappings.py \
			/usr/src/libmojo-"${BASE_VER}"/mojo/mojom_bindings_generator.py
	fi

	# Install header files.
	local d
	for d in "${header_dirs[@]}" ; do
		insinto /usr/include/base-"${BASE_VER}"/"${d}"
		doins "${d}"/*.h
	done
	for d in "${mojom_dirs[@]}"; do
		insinto /usr/include/base-"${BASE_VER}"/"${d}"
		doins "${OUT}"/gen/include/"${d}"/*.h
		# Not to install mojom and pickle file to prevent misuse until Chromium IPC
		# team is ready to have a stable mojo_base. see crbug.com/1055379
		# insinto /usr/src/libchrome/mojom/"${d}"
		# doins "${S}"/"${d}"/*.mojom
		# insinto /usr/share/libchrome/pickle/"${d}"
		# doins "${OUT}"/gen/include/"${d}"/*.p
	done

	# Install libchrome base type mojo mapping
	if use mojo; then
		insinto /usr/share/libchrome/mojom_type_mappings_typemapping
		doins "${OUT}"/gen/libchrome/mojom_type_mappings_typemapping
	fi
}
