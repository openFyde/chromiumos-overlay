# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

DESCRIPTION="Ebuild for Android toolchain (compilers, linker, libraries, headers)."

# The source tarball contains files collected from the sources below.
#
#   # from ab/4842646
#   cheets_arm-target_files-4842646.zip
#   cheets_x86_64-target_files-4842646.zip
#
#   # from 'repo.prop' in cheets_x86_64-target_files-4842646.zip
#   platform/bionic                                                 a7ca05bc94d9e2af01ec4f9f22db893682f27f22
#   platform/external/expat                                         452cd40d64fa13d3cf2054b8fca96fdf34c57f8e
#   platform/external/libcxx                                        79a397804f08fd80a51e7b6c0b7d6d7880a530ea
#   platform/external/zlib                                          cec8538e6162907d587c5229b81fc6a025cc1236
#   platform/frameworks/native                                      0f6fb0ed6b28d4b56dd44a3e6e44bab2276ffaff
#   platform/hardware/libhardware                                   ac9fb578b1d3b2b60e5522efc04f34aa33461a42
#   platform/prebuilts/clang/host/linux-x86                         42541fcf245ae2f4abead994b65603a02ffddea0
#   platform/prebuilts/gcc/linux-x86/arm/arm-linux-androideabi-4.9  0390252b6bcc6217966ade31d07f8b12f6f78f89
#   platform/prebuilts/gcc/linux-x86/x86/x86_64-linux-android-4.9   54c4ed4b1a910bcc8e37196acb7fa85e872de9e4
#   platform/prebuilts/ndk                                          f7e665a1af37619e136cb2b998c076e5316fe937
#   platform/system/core                                            7c046ddf10cb1562b12cfc231d9714b3db36099d
#
SRC_URI="http://commondatastorage.googleapis.com/chromeos-localmirror/distfiles/${P}.tar.gz"

LICENSE="GPL-3 LGPL-3 GPL-3 libgcc libstdc++ gcc-runtime-library-exception-3.1 FDL-1.2 UoI-NCSA"
SLOT="0"
KEYWORDS="-* amd64"
IUSE=""

S=${WORKDIR}
INSTALL_DIR="/opt/android-n"


# These prebuilts are already properly stripped.
RESTRICT="strip"
QA_PREBUILT="*"

src_install() {
	dodir ${INSTALL_DIR}
	cp -pPR * "${D}/${INSTALL_DIR}/" || die
}
