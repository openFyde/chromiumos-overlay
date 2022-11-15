# Copyright 2022 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v3

EAPI=7

inherit cros-workon dlc

DESCRIPTION='ScreenAI is a binary to provide AI based models to improve
assistive technologies. The binary is written in C++ and is currently used by
ReadAnything and PdfOcr services on Chrome OS.'
HOMEPAGE=""
SRC_URI="gs://chromeos-localmirror/distfiles/${PN}-0.0.tar.xz"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="~*"
IUSE="dlc"
REQUIRED_USE="dlc"

# "cros_workon info" expects these variables to be set, so use the standard
# empty project.
CROS_WORKON_PROJECT="chromiumos/infra/build/empty-project"
CROS_WORKON_LOCALNAME="../platform/empty-project"

# DLC variables.
# 4KB * 5773 = ~23 MB
DLC_PREALLOC_BLOCKS="5773"
DLC_PRELOAD=false
DLC_SCALED=true

S="${WORKDIR}"
src_unpack() {
  local archive="${SRC_URI##*/}"
  unpack "${archive}"
}

src_install() {
  # Install binary.
  insinto "$(dlc_add_path /)"
  doins libchromescreenai.so

  # Install Main Content Extraction model files.
  doins screen2x_config.pbtxt screen2x_model.tflite

  # Install Layout Extraction model files.
  # We need to put Layout Extraction model files in the same directory
  # structure as their Google3 locations. This requierment will be removed
  # after we update the file handling so that the files would be loaded in
  # Chrome and passed to the binary.
  doins taser_tflite_latinscreen_scriptid_mobile_engine_ti.binarypb
  doins taser_tflite_latinscreen_scriptid_mobile_recognizer.binarypb
  insinto "$(dlc_add_path /taser)"
  doins taser/rpn_text_detection_tflite_screen_mobile.binarypb
  doins taser/taser_page_layout_analysis_ti_mobile.binarypb
  doins taser/taser_script_identification_tflite_mobile.binarypb
  insinto "$(dlc_add_path /taser/segmenter)"
  doins taser/segmenter/tflite_lstm_recognizer_latin_0.3.class_lst
  doins taser/segmenter/tflite_screen_recognizer_latin.bincfg
  doins taser/segmenter/tflite_screen_recognizer_latin.conv_model
  doins taser/segmenter/tflite_script_detector_0.3.bincfg
  doins taser/segmenter/tflite_script_detector_0.3.conv_model
  doins taser/segmenter/tflite_script_detector_0.3.lstm_model
  insinto "$(dlc_add_path /taser/detector)"
  doins taser/detector/region_proposal_text_detector_tflite_screen.bincfg
  doins \
    taser/detector/rpn_text_detector_mobile_space_to_depth_quantized_v2.tflite

  dlc_src_install
}
