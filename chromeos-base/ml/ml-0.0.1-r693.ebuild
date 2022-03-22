# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="2e5c421c335d5e5750149a486d4b63bc5e158517"
CROS_WORKON_TREE=("beaa23ddfa8fcd0c80807667abfa09780522b3ad" "b54d5d740adeee63f4edd4cbde50372293267272" "fdd0209826719268c01d190ed7bbfa76b177f2f5" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb")
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_PROJECT="chromiumos/platform2"
# TODO(amoylan): Set CROS_WORKON_OUTOFTREE_BUILD=1 after crbug.com/833675.
CROS_WORKON_DESTDIR="${S}/platform2"
CROS_WORKON_SUBTREE="common-mk ml ml_benchmark .gn"

PLATFORM_SUBDIR="ml"

inherit cros-workon platform user

DESCRIPTION="Machine learning service for Chromium OS"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/main/ml"

# Clients of the ML service should place the URIs of their model files into
# MODELS_TO_INSTALL if they are installed into rootfs (built-in models), or
# DOWNLOADABLE_MODELS if they are downloaded via component updater (downloadable
# models).
MODELS_TO_INSTALL=(
	"gs://chromeos-localmirror/distfiles/mlservice-model-test_add-20180914.tflite"
	"gs://chromeos-localmirror/distfiles/mlservice-model-search_ranker-20190923.tflite"
	"gs://chromeos-localmirror/distfiles/mlservice-model-smart_dim-20190521-v3.tflite"
	"gs://chromeos-localmirror/distfiles/mlservice-model-adaptive_charging-20211105.tflite"
)

DOWNLOADABLE_MODELS=(
	"gs://chromeos-localmirror/distfiles/mlservice-model-smart_dim-20200206-downloadable.tflite"
	"gs://chromeos-localmirror/distfiles/mlservice-model-smart_dim-20210201-downloadable.tflite"
)

# Clients that want ml-service to do the feature preprocessing should place the
# URIs of their preprocessor config pb files into PREPROCESSOR_PB_TO_INSTALL.
# Config pb files that are used in unit test should be placed into
# PREPROCESSOR_PB_FOR_TEST.
PREPROCESSOR_PB_TO_INSTALL=(
	"gs://chromeos-localmirror/distfiles/mlservice-model-adaptive_charging-20211105-preprocessor.pb"
)

PREPROCESSOR_PB_FOR_TEST=(
	"gs://chromeos-localmirror/distfiles/mlservice-model-smart_dim-20190521-preprocessor.pb"
)

SRC_URI="
	${DOWNLOADABLE_MODELS[*]}
	${MODELS_TO_INSTALL[*]}
	${PREPROCESSOR_PB_TO_INSTALL[*]}
	${PREPROCESSOR_PB_FOR_TEST[*]}
"

LICENSE="BSD-Google"
KEYWORDS="*"
IUSE="
	dlc
	fuzzer
	internal
	ml_benchmark_drivers
	nnapi
	ondevice_document_scanner
	ondevice_grammar
	ondevice_handwriting
	ondevice_handwriting_dlc
	ondevice_speech
	ondevice_text_suggestions
"

RDEPEND="
	chromeos-base/chrome-icu:=
	>=chromeos-base/metrics-0.0.1-r3152:=
	chromeos-base/minijail:=
	internal? ( ondevice_speech? ( chromeos-soda/libsoda:=[dlc=] ) )
	nnapi? ( chromeos-base/aosp-frameworks-ml-nn )
	media-libs/cros-camera-libfs:=[ondevice_document_scanner=]
	>=dev-libs/libgrammar-0.0.4:=[ondevice_grammar=]
	dev-libs/libhandwriting:=[ondevice_handwriting=,ondevice_handwriting_dlc=]
	>=dev-libs/libsuggest-0.0.9:=[ondevice_text_suggestions=]
	>=dev-libs/libtextclassifier-0.0.1-r79:=
	sci-libs/tensorflow:=
"

DEPEND="
	${RDEPEND}
	chromeos-base/system_api:=[fuzzer?]
	dev-cpp/absl:=
	dev-libs/libutf:=
	dev-libs/marisa-aosp:=
	fuzzer? ( dev-libs/libprotobuf-mutator )
"

# SODA will not be supported on rootfs and only be supported through DLC.
REQUIRED_USE="ondevice_speech? ( dlc )"

src_install() {
	dobin "${OUT}"/ml_service

	# Install upstart configuration.
	insinto /etc/init
	doins init/*.conf

	# Install seccomp policy files.
	insinto /usr/share/policy
	newins "seccomp/ml_service-seccomp-${ARCH}.policy" ml_service-seccomp.policy
	newins "seccomp/ml_service-BuiltinModel-seccomp-${ARCH}.policy" ml_service-BuiltinModel-seccomp.policy
	newins "seccomp/ml_service-DocumentScanner-seccomp-${ARCH}.policy" ml_service-DocumentScanner-seccomp.policy
	newins "seccomp/ml_service-FlatBufferModel-seccomp-${ARCH}.policy" ml_service-FlatBufferModel-seccomp.policy
	newins "seccomp/ml_service-HandwritingModel-seccomp-${ARCH}.policy" ml_service-HandwritingModel-seccomp.policy
	newins "seccomp/ml_service-WebPlatformHandwritingModel-seccomp-${ARCH}.policy" ml_service-WebPlatformHandwritingModel-seccomp.policy
	newins "seccomp/ml_service-SodaModel-seccomp-${ARCH}.policy" ml_service-SodaModel-seccomp.policy
	newins "seccomp/ml_service-TextClassifierModel-seccomp-${ARCH}.policy" ml_service-TextClassifierModel-seccomp.policy
	newins "seccomp/ml_service-GrammarCheckerModel-seccomp-${ARCH}.policy" ml_service-GrammarCheckerModel-seccomp.policy

	# Install D-Bus configuration file.
	insinto /etc/dbus-1/system.d
	doins dbus/org.chromium.MachineLearning.conf

	# Install D-Bus service activation configuration.
	insinto /usr/share/dbus-1/system-services
	doins dbus/org.chromium.MachineLearning.service
	doins dbus/org.chromium.MachineLearning.AdaptiveCharging.service

	# Create distfile array of model filepaths.
	local model_files=( "${MODELS_TO_INSTALL[@]##*/}" "${PREPROCESSOR_PB_TO_INSTALL[@]##*/}" )
	local distfile_array=( "${model_files[@]/#/${DISTDIR}/}" )

	# Install system ML models.
	insinto /opt/google/chrome/ml_models
	doins "${distfile_array[@]}"

	# Install system ML models to fuzzer dir.
	insinto /usr/libexec/fuzzers
	doins "${distfile_array[@]}"

	# Install fuzzer targets.
	for fuzzer in "${OUT}"/*_fuzzer; do
		local fuzzer_component_id="187682"
		platform_fuzzer_install "${S}"/OWNERS "${fuzzer}" \
			--comp "${fuzzer_component_id}"
	done

	if use ml_benchmark_drivers; then
		insinto /usr/local/ml_benchmark/ml_service
		insopts -m0755
		doins "${OUT}"/lib/libml_for_benchmark.so
		insopts -m0644
	fi
}

pkg_preinst() {
	enewuser "ml-service"
	enewgroup "ml-service"
	enewuser "ml-service-dbus"
	enewgroup "ml-service-dbus"
}

platform_pkg_test() {
	# Recreate model dir in the temp directory and copy both
	# MODELS_TO_INSTALL and DOWNLOADABLE_MODELS into it for use in unit
	# tests.
	mkdir "${T}/ml_models" || die
	local all_test_models=(
		"${DOWNLOADABLE_MODELS[@]}"
		"${MODELS_TO_INSTALL[@]}"
		"${PREPROCESSOR_PB_TO_INSTALL[@]}"
		"${PREPROCESSOR_PB_FOR_TEST[@]}"
	)
	local distfile_uri
	for distfile_uri in "${all_test_models[@]}"; do
		cp "${DISTDIR}/${distfile_uri##*/}" "${T}/ml_models" || die
	done

	# The third argument equaling 1 means "run as root". This is needed for
	# multiprocess unit test.
	platform_test "run" "${OUT}/ml_service_test" 1
}
