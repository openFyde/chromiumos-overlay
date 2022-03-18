# Copyright 2015 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CROS_WORKON_COMMIT="c8fd06eaf82cc982a2b4c287cd971b66f799e48f"
CROS_WORKON_TREE="a7f68cef55f958d3a2648d89630c39072a943a37"
CROS_WORKON_PROJECT="chromiumos/platform2"
CROS_WORKON_LOCALNAME="platform2"
CROS_WORKON_DESTDIR="${S}"
CROS_WORKON_OUTOFTREE_BUILD=1
CROS_WORKON_SUBTREE="regions"

PLATFORM_SUBDIR="regions"

inherit cros-workon

DESCRIPTION="Chromium OS Region Data"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/regions/"
LICENSE="BSD-Google"
KEYWORDS="*"

IUSE="cros-debug"

# 'jq' allows command line tools to access the JSON database.
RDEPEND="app-misc/jq"
DEPEND=""

src_unpack() {
	cros-workon_src_unpack
	S+="/regions"
}

src_compile() {
	./regions.py --format=json --output "${WORKDIR}/cros-regions.json" $(usex cros-debug "--include_pseudolocales" "")
}

src_test() {
	./regions_unittest.py
}

src_install() {
	dobin cros_region_data

	insinto /usr/share/misc
	doins "${WORKDIR}/cros-regions.json"
}
