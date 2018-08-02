# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5
CROS_WORKON_COMMIT="49f50b36492ae6bdeb2bc4fe55b5fd1fdc83b411"
CROS_WORKON_TREE=("34bcb6266df551e7744073b28ff1b6aa18023fe2" "a44e222f85f22d1fabeeee88e7ff04b6b895018d")
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_SUBTREE="common-mk ml"

PLATFORM_SUBDIR="ml"

inherit cros-workon platform user

DESCRIPTION="Machine learning service for Chromium OS"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/master/ml"
SRC_URI="gs://chromeos-localmirror/distfiles/mlservice-model-tab_discarder-quantized-20180517.pb
	gs://chromeos-localmirror/distfiles/mlservice-model-tab_discarder-quantized-20180704.tflite"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
IUSE=""

RDEPEND="
	chromeos-base/libbrillo
"

DEPEND="
	${RDEPEND}
	chromeos-base/libmojo
	chromeos-base/system_api
"

src_install() {
	dobin "${OUT}"/ml_service

	insinto /etc/init
	doins init/*.conf

	# Install seccomp policy file.
	insinto /usr/share/policy
	newins "seccomp/ml_service-seccomp-${ARCH}.policy" ml_service-seccomp.policy

	# Install D-Bus configuration file
	insinto /etc/dbus-1/system.d
	doins dbus/org.chromium.MachineLearning.conf

	# Install the ML models.
	insinto /opt/google/chrome/ml_models
	local model
	for model in ${A}; do
		doins "${DISTDIR}/${model}"
	done
}

pkg_preinst() {
	enewuser "ml-service"
	enewgroup "ml-service"
}
