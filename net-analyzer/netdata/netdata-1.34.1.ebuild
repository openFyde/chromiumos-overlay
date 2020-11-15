# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{6,7,8,9} )

inherit autotools linux-info python-single-r1 systemd

if [[ ${PV} == *9999 ]] ; then
	EGIT_REPO_URI="https://github.com/netdata/${PN}.git"
	inherit git-r3
else
	SRC_URI="https://github.com/netdata/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="*"
fi

S="${WORKDIR}/${PN}-v${PV}"

DESCRIPTION="Linux real time system monitoring, done right!"
HOMEPAGE="https://github.com/netdata/netdata https://my-netdata.io/"

LICENSE="GPL-3+ MIT BSD"
SLOT="0"
IUSE="test caps +compression cpu_flags_x86_sse2 cups ipmi +jsonc kinesis +lto mongodb mysql nfacct nodejs postgres prometheus +python tor xen"
REQUIRED_USE="
	mysql? ( python )
	python? ( ${PYTHON_REQUIRED_USE} )
	tor? ( python )"

# most unconditional dependencies are for plugins.d/charts.d.plugin:
RDEPEND="
	app-arch/lz4
	app-misc/jq
	>=app-shells/bash-4:0
	|| (
		net-analyzer/openbsd-netcat
		net-analyzer/netcat
	)
	net-misc/curl
	net-misc/wget
	sys-apps/util-linux
	virtual/awk
	caps? ( sys-libs/libcap )
	cups? ( net-print/cups )
	dev-libs/libuv
	compression? ( sys-libs/zlib )
	ipmi? ( sys-libs/freeipmi )
	jsonc? ( dev-libs/json-c:= )
	kinesis? ( dev-libs/aws-sdk-cpp[kinesis] )
	mongodb? ( dev-libs/mongo-c-driver )
	nfacct? (
		net-firewall/nfacct
		net-libs/libmnl
	)
	nodejs? ( net-libs/nodejs )
	prometheus? (
		dev-libs/protobuf:=
		app-arch/snappy
	)
	python? (
		${PYTHON_DEPS}
		$(python_gen_cond_dep 'dev-python/pyyaml[${PYTHON_MULTI_USEDEP}]')
		mysql? (
			|| (
				$(python_gen_cond_dep 'dev-python/mysqlclient[${PYTHON_MULTI_USEDEP}]')
				$(python_gen_cond_dep 'dev-python/mysql-python[${PYTHON_MULTI_USEDEP}]')
			)
		)
		postgres? ( $(python_gen_cond_dep 'dev-python/psycopg:2[${PYTHON_MULTI_USEDEP}]') )
		tor? ( $(python_gen_cond_dep 'net-libs/stem[${PYTHON_MULTI_USEDEP}]') )
	)
	xen? (
		app-emulation/xen-tools
		dev-libs/yajl
	)"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

#FILECAPS=(
#	'cap_dac_read_search,cap_sys_ptrace+ep' 'usr/libexec/netdata/plugins.d/apps.plugin'
#)

pkg_setup() {
	use python && python-single-r1_pkg_setup
	linux-info_pkg_setup
}

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	cros_enable_cxx_exceptions
	# --disable-cloud: https://github.com/netdata/netdata/issues/8961
	econf \
		--prefix="${EPREFIX}"/usr/local \
		--datadir="${EPREFIX}"/usr/local/share \
		--sysconfdir="${EPREFIX}"/usr/local/etc \
		--localstatedir="${EPREFIX}"/var \
		--disable-cloud \
		--disable-ebpf \
		"$(use_enable jsonc)" \
		"$(use_enable cups plugin-cups)" \
		"$(use_enable nfacct plugin-nfacct)" \
		"$(use_enable ipmi plugin-freeipmi)" \
		"$(use_enable kinesis backend-kinesis)" \
		"$(use_enable lto lto)" \
		"$(use_enable mongodb backend-mongodb)" \
		"$(use_enable prometheus backend-prometheus-remote-write)" \
		"$(use_enable xen plugin-xenstat)" \
		"$(use_enable cpu_flags_x86_sse2 x86-sse)" \
		"$(use_with compression zlib)"

}

src_install() {
	default

	rm -rf "${D}/var/cache" || die

	insinto /usr/local/lib/tmpfiles.d/on-demand/
	doins "${FILESDIR}"/tmpfiles.d/netdata.conf

	dobin "${FILESDIR}"/start_netdata.sh
}
