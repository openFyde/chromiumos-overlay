# Copyright 2019 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

# When the time comes to roll to a new version, download the new gn binary at
# https://chrome-infra-packages.appspot.com/p/gn/gn/linux-amd64/+/
# and run `gn --version` to get the right version number for the ebuild.
# Once you do so, push the gn binary to gs://chromeos-localmirror/distfiles
# and be sure to mark it publicly visible:
#  gsutil cp gn gs://chromeos-localmirror/distfiles/gn-<SHA1>.bin
#  gsutil acl set public-read gs://chromeos-localmirror/distfiles/gn-<SHA1>.bin
#
# Then rename the ebuild file to something that can be recognized as a newer
# version by portage. We used the version number of GN before. However, the
# version numbering system of GN has changed twice so far:
# 1st gen: equal to Chromium version, because GN was part of its repo.
#     (e.g. 523452)
# 2nd gen: 600000 + commit count of the forked GN repository. (e.g. "601523")
# 3rd gen: revision count relative to the initial commit of the GN repository,
#     and the object name of the last commit. (e.g. "1555 (0f3dbca6)"")
#     Since https://gn-review.googlesource.com/c/gn/+/2000/.
# This file is currently named as gn-570036-r<revision>.ebuild because the last
# uprev done during 1st gen was 570036. No uprev happened during 2nd gen. Thus
# this name is assured to be no older than any other versions of this ebuild
# in the past.
#
# After that, update GN_X64_SHA1 below with the SHA1 of the gn binary.
# Finally, run `ebuild <ebuild file name> manifest` to generate the Manifest
# file.
GN_X64_SHA1="fd3ad1f9abaac592975b058fd6cf01b8374748c5"

DESCRIPTION="GN (generate ninja) meta-build system"
HOMEPAGE="https://gn.googlesource.com/gn/"
SRC_URI="http://commondatastorage.googleapis.com/chromeos-localmirror/distfiles/gn-${GN_X64_SHA1}.bin"
RESTRICT="mirror"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="-* amd64"
IUSE=""

# See chromium:386603 for why we download a prebuilt binary instead of
# compiling it ourselves.

S="${WORKDIR}"  # Otherwise emerge fails because $S doesn't exist.

src_install() {
	newbin "${DISTDIR}/${A}" gn
}
