# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

# The tarball contains the arc-cache-builder.jar. It is compiled in ARC NYC by
# mmma vendor/google_arc/tools/ArcCacheBuilder/
# Current version 0.3.0 is built from commit
# a9f11e7708579323549b361362ce834d07b317af

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
