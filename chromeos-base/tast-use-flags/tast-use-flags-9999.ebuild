# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

# This ebuild only cares about its own FILESDIR and ebuild file, so it tracks
# the canonical empty project.
CROS_WORKON_PROJECT="chromiumos/infra/build/empty-project"
CROS_WORKON_LOCALNAME="../platform/empty-project"

inherit cros-workon

DESCRIPTION="Text file listing USE flags for Tast test dependencies"

LICENSE="BSD-Google"
# Nothing depends on this package for build info.  All the files are used at
# runtime only by design.
SLOT="0/0"
KEYWORDS="~*"

# NB: Flags listed here are off by default unless prefixed with a '+'.
IUSE="
	amd64
	android-container-pi
	android-vm-pi
	android-vm-rvc
	arc
	arc-camera1
	arc-camera3
	arcpp
	arcvm
	arm
	arm64
	asan
	betty
	biod
	borealis_host
	chrome_internal
	chrome_media
	chromeless_tty
	containers
	cr50_onboard
	crosvm-gpu
	cups
	diagnostics
	disable_cros_video_decoder
	dptf
	elm-kernelnext
	+display_backlight
	dlc
	dlc_test
	+drivefs
	drm_atomic
	elm
	fizz
	force_breakpad
	grunt
	hana
	hana-kernelnext
	houdini
	houdini64
	internal
	+internal_mic
	+internal_speaker
	iwlwifi_rescan
	kernel-3_8
	kernel-3_10
	kernel-3_14
	kernel-3_18
	kernel-4_4
	kernel-4_14
	kernel-4_19
	kernel-5_4
	kukui
	kvm_host
	kvm_transition
	lxc
	memd
	ml_benchmark_drivers
	ml_service
	moblab
	mocktpm
	msan
	ndk_translation
	ndk_translation64
	nnapi
	nyan_kitty
	ocr
	octopus
	pita
	rialto
	rk3399
	selinux
	selinux_experimental
	skate
	smartdim
	snow
	spring
	+storage_wearout_detect
	touchview
	tpm2
	transparent_hugepage
	ubsan
	unibuild
	usbguard
	vaapi
	veyron_mickey
	veyron_rialto
	virtio_gpu
	vulkan
	watchdog
	wifi_hostap_test
	wilco
	+wired_8021x
	zork
"

src_install() {
	# Install a file containing a list of currently-set USE flags.
	local path="${WORKDIR}/tast_use_flags.txt"
	cat <<EOF >"${path}"
# This file is used by the Tast integration testing system to
# determine which software features are present in the system image.
# Don't use it for anything else. Your code will break.
EOF

	# If you need to inspect a new flag, add it to $IUSE at the top of the file.
	local flags=( ${IUSE} )
	local flag
	for flag in "${flags[@]/#[-+]}" ; do
		usev ${flag}
	done | sort -u >>"${path}"

	insinto /etc
	doins "${path}"
}
