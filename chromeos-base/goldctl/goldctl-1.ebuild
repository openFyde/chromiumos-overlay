# Copyright 2021 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

# When the time comes to roll to a new version, run the following for each architecture:
# $ cipd resolve skia/tools/goldctl/linux-${ARCH} -version latest
# Latest as of 2021-02-12
SRC_URI="
	amd64? ( cipd://skia/tools/goldctl/linux-amd64:lenVc-lo77pTtOxFWjwWnArJLXKHftA-J-nOq_0W8EMC  -> ${P}-amd64.zip )
	x86?   ( cipd://skia/tools/goldctl/linux-386:_oheOO3qRn8agqNyhmJb29X_lyXafQJI-rpkgulmPoYC    -> ${P}-x86.zip )
	arm64? ( cipd://skia/tools/goldctl/linux-arm64:8P-SJvTuK61QSqlvvof_1FheRuyGLlUV-cI1FVpj3wUC  -> ${P}-arm64.zip )
	arm?   ( cipd://skia/tools/goldctl/linux-armv6l:ixteCgOjCaPVbyy39CkDpB_W4x3hbGfzM1lwDyFEqtYC -> ${P}-arm.zip )
"

DESCRIPTION="This command-line tool lets clients upload images to gold"
HOMEPAGE="https://skia.googlesource.com/buildbot/+/HEAD/gold-client/"
RESTRICT="mirror"

LICENSE="BSD-Google"
SLOT="0"
KEYWORDS="*"
IUSE=""

S="${WORKDIR}"

src_install() {
	if [[ ! -e "goldctl" ]]; then
		cat > "goldctl" <<EOF
#!/bin/sh

echo "Goldctl binary is not supported on the architecture ${ARCH}." >&2
exit 1

EOF
	fi
	dobin goldctl
}
