# Copyright (c) 2021 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit estack toolchain-funcs

LINUX_V="${PV:0:1}.x"
if [[ ${PV} == *.*.* ]] ; then
	# stable-release series
	LINUX_VER=$(ver_cut 1-2)
	LINUX_PATCH=patch-${PV}.xz
	SRC_URI="https://www.kernel.org/pub/linux/kernel/v${LINUX_V}/${LINUX_PATCH}"
else
	LINUX_VER=${PV}
	SRC_URI=""
fi

LINUX_SOURCES="linux-${LINUX_VER}.tar.xz"
SRC_URI+=" https://www.kernel.org/pub/linux/kernel/v${LINUX_V}/${LINUX_SOURCES}"

HOMEPAGE="https://www.kernel.org/"
DESCRIPTION="Intel processor C-state and P-state reporting tool"

LICENSE="GPL-2"
SLOT="0/0"
KEYWORDS="*"
IUSE="-asan"

RDEPEND="sys-libs/libcap:="

DEPEND="${RDEPEND}"

S_K="${WORKDIR}/linux-${LINUX_VER}"
S="${S_K}/tools/power/x86/turbostat"

PATCHES=(
	"${FILESDIR}/0001-UPSTREAM-tools-power-turbostat-Read-energy_perf_bias.patch"
	"${FILESDIR}/0002-FROMLIST-tools-power-turbostat-Support-Alder-Lake-P.patch"
)

domake() {
	emake DESTDIR="${D}" CC="$(tc-getCC)" "$@"
}

src_unpack() {
	local paths=(
		tools/power/x86/turbostat tools/include
		arch/x86/include/asm
	)
	local p1=(${paths[@]/%/*})

	echo ">>> Unpacking ${LINUX_SOURCES} (${paths[*]}) to ${PWD}"
	tar --wildcards -xpf "${DISTDIR}"/${LINUX_SOURCES} \
		"${paths[@]/#/linux-${LINUX_VER}/}" || die

	if [[ -n "${LINUX_PATCH}" ]] ; then
		eshopts_push -o noglob
		ebegin "Filtering partial source patch"
		xz -d -c "${DISTDIR}/${LINUX_PATCH}" | filterdiff -p1 ${p1[@]/#/-i } \
			> ${P}.patch
		eend $? || die "filterdiff failed"
		eshopts_pop
	fi

}

src_prepare() {
	pushd "${S_K}" >/dev/null || die
	if [[ -n "${LINUX_PATCH}" ]] ; then
		eapply "${WORKDIR}"/${P}.patch
	fi
	eapply ${PATCHES[@]}
	popd
	eapply_user
}

src_compile() {
	domake
}

src_install() {
	domake install
}
