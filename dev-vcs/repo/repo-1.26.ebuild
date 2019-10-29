# Copyright 2014 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

# NB: The $PV tracks the *repo launcher version*, not the last signed release
# of the repo project.  They are confusingly different.

EAPI="7"

PYTHON_COMPAT=( python3_{6,7} )
inherit python-single-r1

DESCRIPTION="Tool for managing many Git repositories and integrating with Gerrit"
HOMEPAGE="https://gerrit.googlesource.com/git-repo"
SRC_URI="gs://git-repo-downloads/${P}"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
IUSE=""

# The git-repo-downloads bucket is controlled by us.
RESTRICT="nomirror"

S=${WORKDIR}

src_install() {
	newbin "${DISTDIR}/${P}" repo
}
