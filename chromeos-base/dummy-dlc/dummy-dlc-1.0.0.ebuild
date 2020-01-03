# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

# This is a dummy DLC used for testing new features in DLC. It does not really
# build anything, it just creates a DLC image with random content.

EAPI=6

inherit dlc

DESCRIPTION="A dummy DLC"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/master/dlcservice"
SRC_URI=""

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
IUSE="dlc"
REQUIRED_USE="dlc"

DLC_NAME="A dummy DLC"
DLC_VERSION="${PV}"
DLC_PREALLOC_BLOCKS="1024"
DLC_ID="dummy-dlc"
DLC_PACKAGE="dummy-package"
DLC_ARTIFACT_DIR="${T}/artifacts"
DLC_PRELOAD=true

src_unpack() {
	# Because we are not pulling in any sources, we need to have an empty
	# source directory to satisy the build success.
	S="${WORKDIR}"
}

src_install() {
	# Create a few files with random content. The contents of these files
	# are not important. We added this randomness so by each emerge a new
	# image is generated that has a different hash, size, etc and that can
	# be reflected in the DLC manifest in rootfs. This way we can catch
	# problems, like, when a DLC image change is not reflected in its rootfs
	# manifest. If the image is always the same, we might not catch problems
	# like that.
	mkdir -p "${DLC_ARTIFACT_DIR}" || die

	# To reproduce the same image file, replace the seed with the target
	# seed value. If the image already exist, the seed value exists in
	# /root/seed after you mount it.
	local seed="${RANDOM}"
	einfo "Using random seed ${seed} to generate the dummy DLC files."
	# We just loaded seed with RANDOM, but we still need to set its value
	# back so we can reliable reproduce the same random sequence again if
	# needed too. Otherwise it is just a no-op. Setting the value of RANDOM
	# acts as setting a seed value for bash's random generator.
	RANDOM="${seed}"
	echo "${seed}" > "${DLC_ARTIFACT_DIR}/seed"

	local n
	for n in {1..3}; do
		local dummy_file="${DLC_ARTIFACT_DIR}/dummy-file-${n}.bin"
		> "${dummy_file}"
		local count=$(( RANDOM % 10000 ))
		printf "%i-${PVR}\n" $(seq 0 "${count}") >> "${dummy_file}"
	done

	dlc_src_install
}
