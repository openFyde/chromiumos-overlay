# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

# This ebuild only cares about its own FILESDIR and ebuild file, so it tracks
# the canonical empty project.
CROS_WORKON_PROJECT="chromiumos/infra/build/empty-project"
CROS_WORKON_LOCALNAME="platform/empty-project"

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
	arc-launched-32bit-abi
	arc_uses_cros_video_decoder
	arcpp
	arcvm
	arm
	arm64
	asan
	betty
	biod
	borealis_host
	cdm_factory_daemon
	cert_provision
	cheets_user
	cheets_user_64
	cheets_userdebug
	cheets_userdebug_64
	chrome_internal
	chrome_media
	chromeless_tty
	containers
	coresched
	cr50_onboard
	crosvm-gpu
	cups
	diagnostics
	disable_cros_video_decoder
	dptf
	elm-kernelnext
	direncription_allow_v2
	+display_backlight
	dlc
	dlc_test
	+drivefs
	drm_atomic
	elm
	fizz
	force_breakpad
	fwupd
	gboard_decoder
	grunt
	hana
	hana-kernelnext
	houdini
	houdini64
	iioservice
	internal
	+internal_mic
	+internal_speaker
	iwlwifi_rescan
	kernel-3_18
	kernel-4_4
	kernel-4_14
	kernel-4_19
	kernel-5_4
	kernel-5_10
	kernel-upstream
	kukui
	kvm_host
	kvm_transition
	lxc
	manatee
	mbo
	memd
	ml_benchmark_drivers
	ml_service
	moblab
	mocktpm
	msan
	+nacl
	ndk_translation
	ndk_translation64
	nnapi
	nvme
	nyan_kitty
	ocr
	octopus
	ondevice_handwriting
	pita
	racc
	rialto
	rk3399
	sata
	selinux
	selinux_experimental
	sirenia
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
	v4l2_codec
	vaapi
	veyron_mickey
	veyron_rialto
	video_cards_amdgpu
	video_cards_intel
	virtio_gpu
	vulkan
	watchdog
	wifi_hostap_test
	wilco
	+wired_8021x
	+wpa3_sae
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
