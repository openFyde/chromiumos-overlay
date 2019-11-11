# Copyright (c) 2012 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

EAPI=4
CROS_WORKON_COMMIT="a1d2b792db21f1146c4d092e47c95ec3b1706727"
CROS_WORKON_TREE="be252f48d01e2521087968094194ccf541ffec56"
CROS_WORKON_PROJECT="chromiumos/third_party/adhd"
CROS_WORKON_LOCALNAME="adhd"
CROS_WORKON_USE_VCSID=1

# Note: Do *NOT* add any more boards to this list.  Files should be installed
# via bsp packages now, or configured via unibuild config settings.
CROS_BOARDS=(
	bolt
	chell
	cid
	daisy
	daisy_skate
	daisy_spring
	falco
	glados
	jecht
	leon
	link
	mccloud
	monroe
	panther
	peppy
	rikku
	stout
	strago
	tidus
	tricky
	veyron_{fievel,jaq,jerry,jerry-kernelnext,mickey,mighty,minnie,minnie-kernelnext,speedy,tiger}
	whirlwind
	wolf
	zako
)

inherit toolchain-funcs autotools cros-fuzzer cros-sanitizers cros-workon cros-board systemd user libchrome-version

DESCRIPTION="Google A/V Daemon"
HOMEPAGE="http://www.chromium.org"
SRC_URI=""
LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
IUSE="asan +cras-apm fuzzer selinux systemd unibuild"

RDEPEND=">=media-libs/alsa-lib-1.0.27
	!<media-libs/alsa-lib-1.1.6-r3
	media-sound/alsa-utils
	media-plugins/alsa-plugins
	media-libs/sbc
	media-libs/speex
	cras-apm? ( media-libs/webrtc-apm )
	dev-libs/iniparser
	>=sys-apps/dbus-1.4.12
	dev-libs/libpthread-stubs
	virtual/udev
	unibuild? ( chromeos-base/chromeos-config )
	!<=chromeos-base/audioconfig-0.0.1-r1
	chromeos-base/chromeos-config-tools
	chromeos-base/metrics
	selinux? ( sys-libs/libselinux )"
DEPEND="${RDEPEND}
	media-libs/ladspa-sdk"

check_format_error() {
	local file
	local files_need_format=()
	einfo "Running format checks for ADHD .c, .cc and .h files"
	while read -r -d $'\0' file; do
		if ! cmp <(clang-format -style=file "${file}") "${file}"
		then
			files_need_format+=( "${file}" )
		fi
	done< <(find . \( -name "*.c" -o -name "*.cc" -o -name "*.h" \) \
		-print0)

	if [[ "${#files_need_format[@]}" != "0" ]]; then
		eerror "The following files have formatting errors:"
		eerror "${files_need_format[*]}"
		eerror "You can run \"clang-format -i -style=file" \
			"${files_need_format[*]}\"" \
			"under chromiumos/src/third_party/adhd to fix them."
		return 1
	fi
	einfo "    All files are well formatted."
	return 0
}

src_prepare() {
	cd cras
	eautoreconf
}

src_configure() {
	sanitizers-setup-env
	if use amd64 ; then
		export FUZZER_LDFLAGS="-fsanitize=fuzzer"
	fi

	cd cras
	# Disable external libraries for fuzzers.
	if use fuzzer ; then
		cros-workon_src_configure \
			$(use_enable cras-apm webrtc-apm) \
			$(use_enable amd64 fuzzer)
	else
		cros-workon_src_configure $(use_enable selinux) \
			$(use_enable cras-apm webrtc-apm) \
			--enable-metrics \
			$(use_enable amd64 fuzzer)
	fi
}

src_compile() {
	local board=$(get_current_board_with_variant)
	emake BOARD=${board} CC="$(tc-getCC)" || die "Unable to build ADHD"
}

src_test() {
	check_format_error || die "Format check failed"
	if ! use x86 && ! use amd64 ; then
		elog "Skipping unit tests on non-x86 platform"
	else
		cd cras
		# This is an ugly hack that happens to work, but should not be copied.
		LD_LIBRARY_PATH="${SYSROOT}/usr/$(get_libdir)" \
		emake check
	fi
}

src_install() {
	local board=$(get_current_board_with_variant)
	# Get board name without variant E.g.
	# get daisy from daisy_spring,
	local board_no_variant=$(get_current_board_no_variant)
	# Search the boards that are relevant to this board. E.g.
	# for daisy_spring, search in this order:
	# daisy_spring, daisy to find the files.
	local board_all=( ${board} ${board_no_variant} )
	emake BOARD=${board} DESTDIR="${D}" SYSTEMD=$(usex systemd) install

	# install alsa config files
	insinto /etc/modprobe.d
	local b
	for b in "${board_all[@]}" ; do
		local alsa_conf=alsa-module-config/alsa-${b}.conf
		if [[ -f ${alsa_conf} ]] ; then
			doins ${alsa_conf}
			break
		fi
	done

	# install alsa patch files
	insinto /lib/firmware
	for b in "${board_all[@]}" ; do
		local alsa_patch=alsa-module-config/${b}_alsa.fw
		if [[ -f ${alsa_patch} ]] ; then
			doins ${alsa_patch}
			break
		fi
	done

	# install ucm config files
	insinto /usr/share/alsa/ucm
	local board_dir
	for board_dir in "${board_all[@]}" ; do
		if [[ -d ucm-config/${board_dir} ]] ; then
			doins -r ucm-config/${board_dir}/*
			break
		fi
	done
	# install common ucm config files.
	doins -r ucm-config/for_all_boards/*

	# install cras config files
	insinto /etc/cras
	for board_dir in "${board_all[@]}" ; do
		if [[ -d cras-config/${board_dir} ]] ; then
			doins -r cras-config/${board_dir}/*
			break
		fi
	done
	# install common cras config files.
	doins -r cras-config/for_all_boards/*

	# install dbus config allowing cras access
	insinto /etc/dbus-1/system.d
	doins dbus-config/org.chromium.cras.conf

	# Install seccomp policy file.
	insinto /usr/share/policy
	newins "seccomp/cras-seccomp-${ARCH}.policy" cras-seccomp.policy

	# Install asound.conf for CRAS alsa plugin
	insinto /etc
	doins "${FILESDIR}"/asound.conf

	# Install fuzzer binary
	fuzzer_install "${S}/OWNERS" cras/src/cras_rclient_message_fuzzer
}

pkg_preinst() {
	enewuser "cras"
	enewgroup "cras"
}
