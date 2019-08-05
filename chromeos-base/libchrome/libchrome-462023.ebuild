# Copyright 2014 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

# Note: the ${PV} should represent the overall svn rev number of the
# chromium tree that we're extracting from rather than the svn rev of
# the last change actually made to the base subdir.

EAPI="5"

CROS_WORKON_PROJECT=("chromiumos/platform2" "aosp/platform/external/libchrome")
CROS_WORKON_COMMIT=("45cccb17d4e0c375b4eb1729c2ed14278035363d" "9887bc9626824394a2565e302a259d8fc89538c0")
CROS_WORKON_LOCALNAME=("platform2" "aosp/external/libchrome")
CROS_WORKON_DESTDIR=("${S}/platform2" "${S}/platform2/libchrome")
CROS_WORKON_SUBTREE=("common-mk .gn" "")
CROS_WORKON_BLACKLIST="1"

WANT_LIBCHROME="no"
inherit cros-workon libchrome-version platform

DESCRIPTION="Chrome base/ and dbus/ libraries extracted for use on Chrome OS"
HOMEPAGE="http://dev.chromium.org/chromium-os/packages/libchrome"
SRC_URI=""

LICENSE="BSD-Google"
SLOT="${PV}"
KEYWORDS="*"
IUSE="cros_host +crypto +dbus +mojo +timers"

PLATFORM_SUBDIR="libchrome"

# TODO(avakulenko): Put dev-libs/nss behind a USE flag to make sure NSS is
# pulled only into the configurations that require it.
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

src_unpack() {
	platform_src_unpack

	# Upgrade base/json r456626 to r576297 to catch important security
	# hardening work. The code is not vanilla r576297, but it has been
	# adjusted slightly to make it work with this libchrome version.
	# TODO(crbug.com/860181): Remove src_unpack() again once libchrome is
	# uprev'ed to r576297.
	rm "${S}/base/json/"* || die
	cp "${FILESDIR}/base_json_based_on_r576297/"* "${S}/base/json" || die
}

src_prepare() {
	epatch "${FILESDIR}"/${P}-Replace-std-unordered_map-with-std-map-for-dbus-Prop.patch
	epatch "${FILESDIR}"/${P}-dbus-Filter-signal-by-the-sender-we-are-interested-i.patch
	epatch "${FILESDIR}"/${P}-dbus-Make-MockObjectManager-useful.patch
	epatch "${FILESDIR}"/${P}-dbus-Don-t-DCHECK-unexpected-message-type-but-ignore.patch
	epatch "${FILESDIR}"/${P}-Mock-more-methods-of-dbus-Bus-in-dbus-MockBus.patch
	epatch "${FILESDIR}"/${P}-dbus-Add-TryRegisterFallback.patch
	epatch "${FILESDIR}"/${P}-dbus-Remove-LOG-ERROR-in-ObjectProxy.patch
	epatch "${FILESDIR}"/${P}-dbus-Make-Bus-is_connected-mockable.patch
	epatch "${FILESDIR}"/${P}-SequencedWorkerPool-allow-pools-of-one-thread.patch

	# Cherry-pick components/policy/core/common/policy_load_status.{cc,h}
	# from upstream r469654.
	epatch "${FILESDIR}"/${P}-Allow-PolicyLoadStatusSample-to-override-reporting-m.patch

	# ASAN fix cherry-picked from upstream r534999.
	epatch "${FILESDIR}"/${P}-Base-DirReader-Alignment.patch

	# This no_destructor.h is taken from r599267.
	# TODO(hidehiko): Remove this patch after libchrome is uprevved
	# to >= r599267.
	epatch "${FILESDIR}"/${P}-Add-base-NoDestructor-T.patch

	# TODO(hidehiko): Remove this patch after libchrome is uprevved
	# to >= r463684.
	epatch "${FILESDIR}"/${P}-Introduce-ValueReferenceAdapter-for-gracef.patch

	# Disable custom memory allocator when asan is used.
	# https://crbug.com/807685
	use_sanitizers && epatch "${FILESDIR}"/${P}-Disable-memory-allocator.patch

	# Disable object lifetime tracking since it cuases memory leaks in
	# sanitizer builds, https://crbug.com/908138
	epatch "${FILESDIR}"/${P}-Disable-object-tracking.patch

	# TODO(sonnysasaka): Remove after libchrome uprev past r616020.
	epatch "${FILESDIR}"/${P}-dbus-Support-UnexportMethod-from-an-exported-object.patch

	# Remove this patch after libchrome uprev past r531975.
	epatch "${FILESDIR}"/${P}-Add-implicit-fallthrough-warning.patch

	# Patch for the r576279 uprev compatibility.
	# TODO(crbug.com/909719): Remove on uprev.
	epatch "${FILESDIR}"/${P}-libchrome-add-alias-from-base-Location-base-GetProgr.patch

	# Remove this patch after libchrome uprev past r626151.
	epatch "${FILESDIR}"/${P}-components-timers-fix-fd-leak-in-AlarmTimer.patch

	# Remove glib dependency.
	# TODO(hidehiko): Fix the config in AOSP libchrome.
	epatch "${FILESDIR}"/${P}-libchrome-Remove-glib-dependency.patch

	# Add RingBuffer from libchrome.
	# # TODO(lnishan): Remove after libchrome uprev past r574656
	epatch "${FILESDIR}"/${P}-Add-base-containers-RingBuffer.patch
}

src_install() {
	dolib.so "${OUT}"/lib/libbase*-"${SLOT}".so
	dolib.a "${OUT}"/libbase*-"${SLOT}".a

	local gen_header_dirs=()
	local header_dirs=(
		base
		base/allocator
		base/containers
		base/debug
		base/files
		base/i18n
		base/json
		base/memory
		base/message_loop
		base/metrics
		base/numerics
		base/posix
		base/profiler
		base/process
		base/strings
		base/synchronization
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

	insinto /usr/include/base-"${SLOT}"/base/test
	doins \
		base/test/fuzzed_data_provider.h \
		base/test/simple_test_clock.h \
		base/test/simple_test_tick_clock.h \
		base/test/test_mock_time_task_runner.h \
		base/test/test_pending_task.h \

	if use crypto; then
		insinto /usr/include/base-${SLOT}/crypto
		doins \
			crypto/crypto_export.h \
			crypto/hmac.h \
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
	doins "${OUT}"/obj/libchrome/libchrome*-"${SLOT}".pc

	# Install libmojo.
	if use mojo; then
		# Install binary.
		dolib.a "${OUT}"/libmojo-"${SLOT}".a

		# Install headers.
		header_dirs+=(
			ipc
			mojo/common
			mojo/edk/embedder
			mojo/edk/system
			mojo/public/c/system
			mojo/public/cpp/bindings
			mojo/public/cpp/bindings/lib
			mojo/public/cpp/system
		)
		gen_header_dirs+=(
			mojo/common
			mojo/public/interfaces/bindings
		)

		# Install libmojo.pc.
		insinto /usr/$(get_libdir)/pkgconfig
		doins "${OUT}"/obj/libchrome/libmojo-"${SLOT}".pc

		# Install generate_mojom_bindings.
		# TODO(hidehiko): Clean up tools' install directory.
		insinto /usr/src/libmojo-"${SLOT}"/mojo
		doins -r mojo/public/tools/bindings/*
		doins build/gn_helpers.py
		doins -r build/android/gyp/util
		doins -r build/android/pylib
		doins -r third_party/catapult/devil/devil

		insinto /usr/src/libmojo-"${SLOT}"/third_party
		doins -r third_party/catapult
		doins -r third_party/jinja2
		doins -r third_party/markupsafe
		doins -r third_party/ply

		# Mark scripts executable.
		fperms +x \
			/usr/src/libmojo-"${SLOT}"/mojo/generate_type_mappings.py \
			/usr/src/libmojo-"${SLOT}"/mojo/mojom_bindings_generator.py
	fi

	# Install header files.
	local d
	for d in "${header_dirs[@]}" ; do
		insinto /usr/include/base-"${SLOT}"/"${d}"
		doins "${d}"/*.h
	done
	for d in "${gen_header_dirs[@]}"; do
		insinto /usr/include/base-"${SLOT}"/"${d}"
		doins "${OUT}"/gen/include/"${d}"/*.h
	done
}
