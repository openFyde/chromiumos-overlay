# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

# The tarball contains the arc-cache-builder.jar. It is compiled in ARC NYC by
# mmma vendor/google_arc/tools/ArcCacheBuilder/
# Current version 0.2.6 is built from commit
# 458302cad32c717b63ed3ad7fa6466f8c49ce1d5

EAPI="5"

DESCRIPTION="Ebuild which pulls in java library arc-cache-builder.jar"
SRC_URI="gs://chromeos-localmirror/distfiles/${P}.tbz2"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
IUSE=""

S="${WORKDIR}"

src_install() {
	insinto /usr/share/arc-cache-builder
	doins org.chromium.arc.cachebuilder.jar
	dobin "${FILESDIR}/arc_generate_packages_cache"
}
