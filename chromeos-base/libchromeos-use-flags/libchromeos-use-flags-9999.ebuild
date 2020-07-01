# Copyright 2014 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

# This ebuild only cares about its own FILESDIR and ebuild file, so it tracks
# the canonical empty project.
CROS_WORKON_PROJECT="chromiumos/infra/build/empty-project"
CROS_WORKON_LOCALNAME="../platform/empty-project"

inherit cros-workon

DESCRIPTION="Text file listing USE flags for chromeos-base/libchromeos"

LICENSE="BSD-Google"
# Nothing depends on this package for build info.  All the files are used at
# runtime only by design.
SLOT="0/0"
KEYWORDS="~*"

# NB: Flags listed here are off by default unless prefixed with a '+'.
# This list is lengthy since it determines the USE flags that will be written to
# the /etc/ui_use_flags.txt file that's used to generate Chrome's command line.
IUSE="
	allow_consumer_kiosk
	arc
	arc_adb_sideloading
	arc_force_2x_scaling
	arc_native_bridge_64bit_support_experiment
	arc_transition_m_to_n
	arcpp
	arcvm
	asan
	background_blur
	big_little
	biod
	cfm_enabled_device
	cheets
	compupdates
	disable_background_blur
	disable_cros_video_decoder
	disable_explicit_dma_fences
	disable_flash_hw_video_decode
	disable_instant_tethering
	disable_yuv420_biplanar
	drm_atomic
	edge_touch_filtering
	enable_heuristic_palm_detection_filter
	enable_neural_palm_detection_filter
	force_breakpad
	force_crashpad
	gpu_sandbox_allow_sysv_shm
	gpu_sandbox_failures_not_fatal
	gpu_sandbox_start_early
	houdini
	houdini64
	kvm_guest
	kvm_host
	kvm_transition
	lacros
	legacy_keyboard
	legacy_power_button
	moblab
	native_gpu_memory_buffers
	natural_scroll_default
	ndk_translation
	ndk_translation64
	neon
	oobe_skip_postlogin
	oobe_skip_to_login
	opengles
	passive_event_listeners
	pita
	pita-camera
	pita-microphone
	rialto
	scheduler_configuration_performance
	screenshare_sw_codec
	shelf-hotseat
	smartdim
	tablet_form_factor
	touch_centric_device
	touchscreen_wakeup
	touchview
	tpm_fallback
	video_capture_use_gpu_memory_buffer
	virtio_gpu
	webui-tab-strip
	wilco
	+X
"

src_install() {
	# Install a file containing a list of currently-set USE flags that
	# ChromiumCommandBuilder reads at runtime while constructing Chrome's
	# command line.
	local path="${WORKDIR}/ui_use_flags.txt"
	cat <<EOF >"${path}"
# This file is just for libchromeos's ChromiumCommandBuilder class.
# Don't use it for anything else. Your code will break.
EOF

	# If you need to use a new flag, add it to $IUSE at the top of the file.
	local flags=( ${IUSE} )
	local flag
	for flag in "${flags[@]/#[-+]}" ; do
		usev ${flag}
	done | sort -u >>"${path}"

	insinto /etc
	doins "${path}"
}
