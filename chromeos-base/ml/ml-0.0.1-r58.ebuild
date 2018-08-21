# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5
CROS_WORKON_COMMIT="a0f143cc50fb2fef088525e8da2fb8374427ddc8"
CROS_WORKON_TREE=("335c01060e7415af95705bf53ce03552097ba3cd" "eb014a6f664ddd0f38f7e0bc50d14dc0226a05ae" "dc1506ef7c8cfd2c5ffd1809dac05596ec18773c")
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_INCREMENTAL_BUILD=1
CROS_WORKON_SUBTREE="common-mk ml .gn"

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

	# Install upstart configuration.
	insinto /etc/init
	doins init/*.conf

	# Install seccomp policy file.
	insinto /usr/share/policy
	newins "seccomp/ml_service-seccomp-${ARCH}.policy" ml_service-seccomp.policy

	# Install D-Bus configuration file.
	insinto /etc/dbus-1/system.d
	doins dbus/org.chromium.MachineLearning.conf

	# Install D-Bus service activation configuration.
	insinto /usr/share/dbus-1/system-services
	doins dbus/org.chromium.MachineLearning.service

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
