# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_{6..9} )
inherit distutils-r1

DESCRIPTION="High-performance RPC framework (python libraries)"
HOMEPAGE="https://grpc.io"
SRC_URI="mirror://pypi/${PN::1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="*"

RDEPEND=">=dev-libs/openssl-1.0.2:0=[-bindist]
	dev-python/cython[${PYTHON_USEDEP}]
	dev-python/protobuf-python[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
	net-dns/c-ares:=
	!<net-libs/grpc-1.16.0[python]
	sys-libs/zlib:=
"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
"

PATCHES=(
	"${FILESDIR}"/use-sysroot-env-var.patch
	"${FILESDIR}"/grpc-1.22.1-glibc-2.30-compat.patch
)

python_prepare_all() {
	export GRPC_PYTHON_CFLAGS="${CFLAGS}"
	export GRPC_PYTHON_LDFLAGS="${LDFLAGS}"
	distutils-r1_python_prepare_all
}

python_compile() {
	export GRPC_PYTHON_DISABLE_LIBC_COMPATIBILITY=1
	export GRPC_PYTHON_BUILD_SYSTEM_CARES=1
	export GRPC_PYTHON_BUILD_SYSTEM_OPENSSL=1
	export GRPC_PYTHON_BUILD_SYSTEM_ZLIB=1
	export GRPC_PYTHON_BUILD_WITH_CYTHON=1
	distutils-r1_python_compile
}
