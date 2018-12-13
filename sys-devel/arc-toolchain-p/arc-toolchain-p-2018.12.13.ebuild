# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

DESCRIPTION="Ebuild for Android toolchain (compilers, linker, libraries, headers)."

# The source tarball contains files collected from the sources below.
#
#   # from ab/4822905
#   cheets_arm-target_files-4822905.zip
#   cheets_x86_64-target_files-4822905.zip
#
#   # from 'repo.prop' in cheets_x86_64-target_files-4822905.zip
#   platform/bionic                                                 03cb53a17d47e1a4777672e4ea76afa8e23f1d41
#   platform/external/expat                                         9a9c9b09b900298549ecdbef960fd94c998065e7
#   platform/external/libcxx                                        68aaead27cb9afcf496ec4f2f76832e1af675c3c
#   platform/external/zlib                                          b30b23d7ddb26f452c31fe8b28ebc59e5639ec3f
#   platform/frameworks/native                                      8d656fc140c7660a552c30710b82a42c19e4a5bc
#   platform/hardware/libhardware                                   48e4dc39dfe3d6ec6f9d0eedf7753b2fdff672db
#   platform/prebuilts/clang/host/linux-x86                         1be2ab6257915490176d09db0a7307595f7c3021
#   platform/prebuilts/gcc/linux-x86/arm/arm-linux-androideabi-4.9  75a43d595cbbd637294e0c54d98051fe03e06b83
#   platform/prebuilts/gcc/linux-x86/x86/x86_64-linux-android-4.9   a137b149dc4eecca65e037457b4809da38ea8f77
#   platform/prebuilts/ndk                                          5a5968849d605c124aa30f964a250c3485338d4a
#   platform/system/core                                            ef1ad308a3f0148d155d734912df6af951be0df9
#
SRC_URI="http://commondatastorage.googleapis.com/chromeos-localmirror/distfiles/${P}.tar.gz"

LICENSE="GPL-3 LGPL-3 GPL-3 libgcc libstdc++ gcc-runtime-library-exception-3.1 FDL-1.2 UoI-NCSA"
SLOT="0"
KEYWORDS="-* amd64"
IUSE=""

S="${WORKDIR}"
INSTALL_DIR="/opt/android-p"


# These prebuilts are already properly stripped.
RESTRICT="strip"
QA_PREBUILT="*"

src_install() {
	dodir "${INSTALL_DIR}"
	cp -pPR * "${D}/${INSTALL_DIR}/" || die
}
