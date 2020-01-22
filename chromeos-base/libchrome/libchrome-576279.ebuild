# Copyright 2014 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

# Note: the ${PV} should represent the overall svn rev number of the
# chromium tree that we're extracting from rather than the svn rev of
# the last change actually made to the base subdir.

EAPI="5"

CROS_WORKON_PROJECT=("chromiumos/platform2" "aosp/platform/external/libchrome")
CROS_WORKON_COMMIT=("e9a60fb73d814844e3a985dd48302a03a06cca57" "1cedaefedb63833985136e3e6fabfe4326c39657")
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
IUSE="cros_host +crypto +dbus fuzzer +mojo +timers"

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
	dev-libs/re2:=
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
	# epatch "${FILESDIR}"/${P}-Replace-std-unordered_map-with-std-map-for-dbus-Prop.patch
	# epatch "${FILESDIR}"/${P}-dbus-Filter-signal-by-the-sender-we-are-interested-i.patch
	# epatch "${FILESDIR}"/${P}-dbus-Make-MockObjectManager-useful.patch
	# epatch "${FILESDIR}"/${P}-dbus-Don-t-DCHECK-unexpected-message-type-but-ignore.patch
	# epatch "${FILESDIR}"/${P}-Mock-more-methods-of-dbus-Bus-in-dbus-MockBus.patch

	# Cherry pick CLs from upstream.
	# Remove these when the libchrome gets enough new.
	# r576565.
	epatch "${FILESDIR}"/${P}-dbus-Add-TryRegisterFallback.patch

	# r581937.
	epatch "${FILESDIR}"/${P}-dbus-Remove-LOG-ERROR-in-ObjectProxy.patch

	# r582324
	epatch "${FILESDIR}"/${P}-Fix-Wdefaulted-function-deleted-warning-in-MessageLo.patch

	# r583543.
	epatch "${FILESDIR}"/${P}-dbus-Make-Bus-is_connected-mockable.patch

	# This no_destructor.h is taken from r599267.
	epatch "${FILESDIR}"/${P}-Add-base-NoDestructor-T.patch

	# r616020.
	epatch "${FILESDIR}"/${P}-dbus-Support-UnexportMethod-from-an-exported-object.patch

	# r617572 and r626151
	epatch "${FILESDIR}"/${P}-components-timers-fix-fd-leak-in-AlarmTimer.patch
	# epatch "${FILESDIR}"/${P}-Refactor-AlarmTimer-to-report-error-to-the-caller.patch

	# TODO(hidehiko): Remove this patch after libchrome is uprevved
	# to >= r463684.
	epatch "${FILESDIR}"/${P}-Introduce-ValueReferenceAdapter-for-gracef.patch

	# For backward compatibility.
	# TODO(crbug.com/909719): Remove this patch after clients are updated.
	epatch "${FILESDIR}"/${P}-libchrome-Add-EmptyResponseCallback-for-backward-com.patch

	# Undo gn_helper sys.path update.
	epatch "${FILESDIR}"/${P}-libchrome-Unpatch-sys.path-update.patch

	# Introduce stub ConvertableToTraceFormat for task_scheduler.
	epatch "${FILESDIR}"/${P}-libchrome-Introduce-stub-ConvertableToTraceFormat.patch

	# Disable custom memory allocator when asan is used.
	# https://crbug.com/807685
	use_sanitizers && epatch "${FILESDIR}"/${P}-Disable-memory-allocator.patch

	# Disable object lifetime tracking since it cuases memory leaks in
	# sanitizer builds, https://crbug.com/908138
	# TODO
	# epatch "${FILESDIR}"/${P}-Disable-object-tracking.patch

	# Remove this patch after libchrome uprev past r626151.

	# Fix timing issue with dbus::ObjectManager.
	# # TODO(bingxue): Remove after libchrome uprev past r684392.
	epatch "${FILESDIR}"/${P}-Connect-to-NameOwnerChanged-signal-when-setting-call.patch

	# Remove glib dependency.
	# TODO(hidehiko): Fix the config in AOSP libchrome.
	epatch "${FILESDIR}"/${P}-libchrome-Remove-glib-dependency.patch

	# Fix FileDescriptorWatcher leak
	# TODO(fqj): Remove after libchrome past r627021.
	epatch "${FILESDIR}"/${P}-fix-fd-watcher-leak.patch

	# Use correct shebang for these python2-only scripts.
	find "${S}"/mojo/ -name '*.py' \
		-exec sed -i -E '1{ /^#!/ s:(env )?python$:python2: }' {} +

	# Misc fix to build older crypto library.
	epatch "${FILESDIR}"/${P}-libchrome-Update-crypto.patch

	# Enable location source to add function_name
	epatch "${FILESDIR}"/${P}-enable-location-source.patch

	# Backward compatibility (remove all when uprev is done)
	epatch "${FILESDIR}"/${P}-r462023-backward-compatibility.patch

	# Add WaitForServiceToBeAvailable back for MockObjectProxy
	epatch "${FILESDIR}"/${P}-WaitForServiceToBeAvailable.patch

	# TODO(crbug.com/1044363): Remove after uprev >= r586219.
	epatch "${FILESDIR}"/${P}-Fix-TimeDelta.patch
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
		base/test/simple_test_clock.h \
		base/test/simple_test_tick_clock.h \
		base/test/test_mock_time_task_runner.h \
		base/test/test_pending_task.h \

	if use crypto; then
		insinto /usr/include/base-${SLOT}/crypto
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
	doins "${OUT}"/obj/libchrome/libchrome*-"${SLOT}".pc

	# Install libmojo.
	if use mojo; then
		# Install binary.
		dolib.a "${OUT}"/libmojo-"${SLOT}".a

		# Install headers.
		header_dirs+=(
			ipc
			mojo/core/
			mojo/core/embedder
			mojo/core/ports
			mojo/public/c/system
			mojo/public/cpp/bindings
			mojo/public/cpp/bindings/lib
			mojo/public/cpp/platform
			mojo/public/cpp/system
		)
		gen_header_dirs+=(
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

		insinto /usr/src/libmojo-"${SLOT}"/third_party
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
