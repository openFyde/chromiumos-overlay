# Copyright 2020 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT=("86bcf17f5d3fce2ea2e6f4d21ef7ca3b5a393ed2" "3b6aa2b3f62f5907434edf316e5e60f39592a4a5")
CROS_WORKON_TREE=("2b7b46ab1083cdcc8b17bd7f5b05ddff336b0559" "e7dba8c91c1f3257c34d4a7ffff0ea2537aeb6bb" "d667f81f59324c5e27302f538e5296d349c0a7f3")
CROS_WORKON_LOCALNAME=("../platform2" "libtextclassifier")
CROS_WORKON_PROJECT=("chromiumos/platform2" "chromiumos/third_party/libtextclassifier")
CROS_WORKON_DESTDIR=("${S}/platform2" "${S}/platform2/libtextclassifier")
CROS_WORKON_SUBTREE=("common-mk .gn" "")

PLATFORM_SUBDIR="libtextclassifier"

inherit cros-workon platform

DESCRIPTION="Library for classifying text"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/third_party/libtextclassifier/"

LICENSE="Apache-2.0"
SLOT="0/${PVR}"
KEYWORDS="*"
IUSE=""

RDEPEND="
	chromeos-base/chrome-icu:=
	dev-libs/flatbuffers:=
	sci-libs/tensorflow:=
	sys-libs/zlib:=
"

DEPEND="
	${RDEPEND}
"

src_install() {
	dolib.a "${OUT}/libtextclassifier.a"

	# Install the header files to /usr/include/libtextclassifier/.
	local header_files=(
		"annotator/annotator.h"
		"annotator/cached-features.h"
		"annotator/contact/contact-engine-dummy.h"
		"annotator/contact/contact-engine.h"
		"annotator/datetime/extractor.h"
		"annotator/datetime/parser.h"
		"annotator/duration/duration.h"
		"annotator/entity-data_generated.h"
		"annotator/feature-processor.h"
		"annotator/installed_app/installed-app-engine-dummy.h"
		"annotator/installed_app/installed-app-engine.h"
		"annotator/knowledge/knowledge-engine-dummy.h"
		"annotator/knowledge/knowledge-engine.h"
		"annotator/model-executor.h"
		"annotator/model_generated.h"
		"annotator/number/number.h"
		"annotator/strip-unpaired-brackets.h"
		"annotator/types.h"
		"annotator/zlib-utils.h"
		"utils/base/config.h"
		"utils/base/integral_types.h"
		"utils/base/logging.h"
		"utils/base/logging_levels.h"
		"utils/base/macros.h"
		"utils/base/port.h"
		"utils/calendar/calendar-common.h"
		"utils/calendar/calendar-icu.h"
		"utils/calendar/calendar.h"
		"utils/codepoint-range.h"
		"utils/codepoint-range_generated.h"
		"utils/container/sorted-strings-table.h"
		"utils/container/string-set.h"
		"utils/flatbuffers.h"
		"utils/flatbuffers_generated.h"
		"utils/i18n/language-tag_generated.h"
		"utils/i18n/locale.h"
		"utils/intents/intent-config_generated.h"
		"utils/memory/mmap.h"
		"utils/normalization_generated.h"
		"utils/resources_generated.h"
		"utils/strings/stringpiece.h"
		"utils/tensor-view.h"
		"utils/tflite-model-executor.h"
		"utils/token-feature-extractor.h"
		"utils/tokenizer.h"
		"utils/tokenizer_generated.h"
		"utils/utf8/unicodetext.h"
		"utils/utf8/unilib-icu.h"
		"utils/utf8/unilib.h"
		"utils/variant.h"
		"utils/zlib/buffer_generated.h"
		"utils/zlib/tclib_zlib.h"
	)
	local f
	for f in "${header_files[@]}"; do
		insinto "/usr/include/libtextclassifier/${f%/*}"
		if [[ "${f}" == *_generated.h ]]; then
			doins "${OUT}/gen/libtextclassifier/${f}"
		else
			doins "${S}/${f}"
		fi
	done
}
