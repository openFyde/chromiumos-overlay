# Copyright 2021 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT="2e5c421c335d5e5750149a486d4b63bc5e158517"
CROS_WORKON_TREE=("e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb" "bdce8a305b6af438503ba12680e7d8526bcc2dfc" "835ea099c8643676eca960bb95a9349559008807" "beaa23ddfa8fcd0c80807667abfa09780522b3ad")
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_LOCALNAME="../platform2"
CROS_WORKON_SUBTREE=".gn camera/build camera/libfs common-mk"
CROS_WORKON_OUTOFTREE_BUILD="1"
CROS_WORKON_INCREMENTAL_BUILD="1"

PLATFORM_SUBDIR="camera/libfs"

inherit cros-camera cros-workon platform

DESCRIPTION="Camera Libraries File System which installs the prebuilt libraries."

IUSE="
	camera_feature_auto_framing
	camera_feature_face_detection
	camera_feature_hdrnet
	camera_feature_portrait_mode
	march_alderlake
	march_armv8
	march_bdver4
	march_corei7
	march_goldmont
	march_silvermont
	march_skylake
	march_tigerlake
	march_tremont
	march_znver1
	ondevice_document_scanner
"

# Auto face framing depends on the face detection feature.
REQUIRED_USE="camera_feature_auto_framing? ( camera_feature_face_detection )"

LOCAL_MIRROR="gs://chromeos-localmirror/distfiles"
PACAKGE_AUTOFRAMING="chromeos-camera-libautoframing-2022.03.04.tbz2"
PACKAGE_DOCUMENT_SCANNING="chromeos-document-scanning-lib-2021.11.10.tar.bz2"
PACAKGE_FACESSD="chromeos-facessd-lib-2021.10.27.tar.bz2"
PACKAGE_GCAM="chromeos-camera-libgcam-2022.02.24.tar.bz2"
PACKAGE_PORTRAIT_PROCESSOR_AMD64="portrait-processor-lib-x86_64-2020.04.06-unstripped.tbz2"
PACKAGE_PORTRAIT_PROCESSOR_ARM="portrait-processor-lib-armv7-2020.04.06-unstripped.tbz2"

SRC_URI="
		camera_feature_auto_framing? (
				${LOCAL_MIRROR}/${PACAKGE_AUTOFRAMING}
		)
		${LOCAL_MIRROR}/${PACKAGE_DOCUMENT_SCANNING}
		${LOCAL_MIRROR}/${PACAKGE_FACESSD}
		camera_feature_hdrnet? (
				${LOCAL_MIRROR}/${PACKAGE_GCAM}
		)
		camera_feature_portrait_mode? (
				amd64? (
						${LOCAL_MIRROR}/${PACKAGE_PORTRAIT_PROCESSOR_AMD64}
				)
				arm? (
						${LOCAL_MIRROR}/${PACKAGE_PORTRAIT_PROCESSOR_ARM}
				)
		)
"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"

RDEPEND="
	!media-libs/cros-camera-document-scanning
	!media-libs/cros-camera-effect-portrait-mode
	!media-libs/cros-camera-facessd
	!media-libs/cros-camera-libautoframing
	!media-libs/cros-camera-libgcam
"

src_unpack() {
	default_src_unpack
	platform_src_unpack
}

install_lib() {
	local lib_src_path="$1"
	local so_files_path="$2"
	shift 2

	local lib_name=$(basename "${lib_src_path}")

	# For building binary, but won't be installed into the image.
	insinto /build/share/cros_camera
	doins "${lib_src_path}"

	# Put into the squashfs image without debug symbols.
	$(tc-getSTRIP) -s "${lib_src_path}" -o "${so_files_path}/${lib_name}"
}

src_install() {
	insinto /etc/init
	doins init/cros-camera-libfs.conf

	local march_path
	if use march_alderlake; then
		march_path="x86_64-alderlake"
	elif use march_armv8; then
		march_path="armv7-armv8-a+crc"
	elif use march_bdver4; then
		march_path="x86_64-bdver4"
	elif use march_corei7; then
		march_path="x86_64-corei7"
	elif use march_goldmont; then
		march_path="x86_64-goldmont"
	elif use march_silvermont; then
		march_path="x86_64-silvermont"
	elif use march_skylake; then
		march_path="x86_64-skylake"
	elif use march_tigerlake; then
		march_path="x86_64-tigerlake"
	elif use march_tremont; then
		march_path="x86_64-tremont"
	elif use march_znver1; then
		march_path="x86_64-znver1"
	elif use amd64; then
		march_path="x86_64"
	elif use arm; then
		march_path="armv7"
	elif use arm64; then
		march_path="arm"
	fi

	local so_files_path="${WORKDIR}/camera_libs"
	mkdir -p "${so_files_path}"

	local camera_g3_libs_path="${WORKDIR}/g3_libs.squash"

	# Move the required .so into the folder to prepare for compression.
	if use camera_feature_auto_framing; then
		install_lib "${WORKDIR}/libautoframing_cros.so" "${so_files_path}"
	fi
	if use ondevice_document_scanner; then
		install_lib "${WORKDIR}/${march_path}/libdocumentscanner.so" "${so_files_path}"
	fi
	install_lib "${WORKDIR}/${march_path}/libfacessd_cros.so" "${so_files_path}"
	if use camera_feature_hdrnet && (use march_skylake || use march_alderlake || use amd64); then
		install_lib "${WORKDIR}/${march_path}/libgcam_cros.so" "${so_files_path}"
	fi
	if use camera_feature_portrait_mode; then
		install_lib "${WORKDIR}/libportrait_cros.so" "${so_files_path}"
	fi

	# Compress the .so files to a single .squash file and install it.
	mksquashfs "${so_files_path}" "${camera_g3_libs_path}" \
			-all-root -noappend -no-recovery -no-exports -exit-on-error \
			-no-progress -4k-align \
			-b 1M \
			-root-mode 0755
	insinto /usr/share/cros-camera
	doins "${camera_g3_libs_path}"
	keepdir /usr/share/cros-camera/libfs

	# For Document Scanning
	insinto /usr/include/chromeos/libdocumentscanner/
	doins "${WORKDIR}"/document_scanner.h

	insinto /usr/include/cros-camera
	doins "${WORKDIR}"/*.h

	# Install model file and anchor file
	insinto /usr/share/cros-camera/ml_models
	doins "${WORKDIR}"/*.pb "${WORKDIR}"/*.tflite
}
