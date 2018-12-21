# Copyright 2014 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

# Note: the ${PV} should represent the overall svn rev number of the
# chromium tree that we're extracting from rather than the svn rev of
# the last change actually made to the base subdir.

EAPI="5"

CROS_WORKON_PROJECT=("chromiumos/platform2" "aosp/platform/external/libchrome")
CROS_WORKON_COMMIT=("23b79133514ac2cd986bce21c398fb6658bda248" "780c6a9c0783e0a96830c563ab31ece48eba2374")
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
IUSE="cros_host +crypto +dbus +timers"

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
	)"
DEPEND="${RDEPEND}
	dev-cpp/gtest
	dev-cpp/gmock
"

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

	# Introduce backward compatible ctor for quipper only.
	# TODO(hidehiko): Remove this.
	epatch "${FILESDIR}"/${P}-Add-backward-compatible-WaitableEvent-ctor.patch

	# TODO(sonnysasaka): Remove after libchrome uprev past r616020.
	epatch "${FILESDIR}"/${P}-dbus-Support-UnexportMethod-from-an-exported-object.patch
}

src_install() {
	dolib.so "${OUT}"/lib/libbase*-${SLOT}.so
	dolib.a "${OUT}"/libbase*-${SLOT}.a

	local d header_dirs=(
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

	for d in "${header_dirs[@]}" ; do
		insinto /usr/include/base-${SLOT}/${d}
		doins ${d}/*.h
	done

	insinto /usr/include/base-${SLOT}/base/test
	doins \
		base/test/fuzzed_data_provider.h \
		base/test/simple_test_clock.h \
		base/test/simple_test_tick_clock.h \

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
	doins "${OUT}"/obj/libchrome/libchrome*-${SLOT}.pc
}
