# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Low level support for a standard C++ library"
HOMEPAGE="http://libcxxabi.llvm.org/"
SRC_URI=""

# shellcheck disable=SC2034
LLVM_HASH="a58d0af058038595c93de961b725f86997cf8d4a" # r458507
LLVM_NEXT_HASH="db1978b67431ca3462ad8935bf662c15750b8252" # r465103

LICENSE="|| ( UoI-NCSA MIT )"
SLOT="0"
KEYWORDS="*"
if [[ "${PV}" == "9999" ]]; then
	KEYWORDS="~*"
fi
IUSE="+compiler-rt cros_host +libunwind msan llvm-next llvm-tot +static-libs"

RDEPEND=""
DEPEND=""
