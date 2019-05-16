# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

if [[ ${PV} == 9999 ]]; then
	EGIT_REPO_URI="https://github.com/systemd/systemd.git"
	inherit git-r3
else
	SRC_URI="https://github.com/systemd/systemd/archive/v${PV}/${P}.tar.gz -> systemd-${PV}.tar.gz"
	KEYWORDS="*"
fi

inherit bash-completion-r1 linux-info meson multilib-minimal ninja-utils systemd toolchain-funcs udev user

DESCRIPTION="System and service manager for Linux"
HOMEPAGE="https://www.freedesktop.org/wiki/Software/systemd"

LICENSE="GPL-2 LGPL-2.1 public-domain"
SLOT="0/2"
IUSE="-acl -gcrypt gnutls -http -lzma +pcre -qrcode -seccomp -selinux +split-usr ssl"

S="$WORKDIR/systemd-${PV}"

MINKV="3.10"

COMMON_DEPEND=">=sys-apps/util-linux-2.30:0=[${MULTILIB_USEDEP}]
	sys-libs/libcap:0=[${MULTILIB_USEDEP}]
	!<sys-libs/glibc-2.16
	acl? ( sys-apps/acl:0= )
	gcrypt? ( >=dev-libs/libgcrypt-1.4.5:0=[${MULTILIB_USEDEP}] )
	http? (
		>=net-libs/libmicrohttpd-0.9.33:0=
		ssl? ( >=net-libs/gnutls-3.1.4:0= )
	)
	lzma? ( >=app-arch/xz-utils-5.0.5-r1:0=[${MULTILIB_USEDEP}] )
	pcre? ( dev-libs/libpcre2 )
	qrcode? ( media-gfx/qrencode:0= )
	selinux? ( sys-libs/libselinux:0= )"

# baselayout-2.2 has /run
RDEPEND="${COMMON_DEPEND}
	>=sys-apps/baselayout-2.2
	!sys-apps/systemd"

DEPEND="
	>=sys-kernel/linux-headers-${MINKV}
"

# Newer linux-headers needed by ia64, bug #480218
BDEPEND="
	${COMMON_DEPEND}
	app-arch/xz-utils:0
	>=dev-util/meson-0.46
	dev-util/gperf
	>=dev-util/intltool-0.50
	>=sys-apps/coreutils-8.16
	>=sys-kernel/linux-headers-${MINKV}
	virtual/pkgconfig[${MULTILIB_USEDEP}]
"

pkg_pretend() {
	if [[ ${MERGE_TYPE} != buildonly ]]; then
		local CONFIG_CHECK="~EPOLL ~FANOTIFY ~FHANDLE
			~INOTIFY_USER ~PROC_FS ~SIGNALFD ~SYSFS
			~TIMERFD ~UNIX"

		use acl && CONFIG_CHECK+=" ~TMPFS_POSIX_ACL"
		use seccomp && CONFIG_CHECK+=" ~SECCOMP ~SECCOMP_FILTER"

		if kernel_is -lt ${MINKV//./ }; then
			ewarn "Kernel version at least ${MINKV} required"
		fi

		check_extra_config
	fi
}

pkg_setup() {
	:
}

src_unpack() {
	default
	[[ ${PV} != 9999 ]] || git-r3_src_unpack
}

src_prepare() {
	eapply "${FILESDIR}"
	default
}

src_configure() {
	# Prevent conflicts with i686 cross toolchain, bug 559726
	tc-export AR CC NM OBJCOPY RANLIB

	multilib-minimal_src_configure
}

meson_use() {
	usex "$1" true false
}

meson_multilib() {
	if multilib_is_native_abi; then
		echo true
	else
		echo false
	fi
}

meson_multilib_native_use() {
	if multilib_is_native_abi && use "$1"; then
		echo true
	else
		echo false
	fi
}

multilib_src_configure() {
	local myconf=(
		--localstatedir="${EPREFIX}/var"
		-Dbashcompletiondir="$(get_bashcompdir)"
		# make sure we get /bin:/sbin in PATH
		-Dsplit-usr=$(usex split-usr true false)
		# The original gentoo systemd ebuild used the split-usr use flag
		# to control both the rootprefix and the split-usr config
		# options. Chrome OS is a split-usr system, but we want journald
		# to be installed in /usr/.
		-Drootprefix="${EPREFIX}/usr"
		-Defi=false
		-Dima=false
		# Optional components/dependencies
		-Dacl=$(meson_multilib_native_use acl)
		-Dapparmor=false
		-Daudit=false
		-Dlibcryptsetup=false
		-Dlibcurl=false
		-Delfutils=false
		-Dgcrypt=$(meson_use gcrypt)
		-Dgnutls=$(meson_multilib_native_use gnutls)
		-Dgnu-efi=false
		-Dmicrohttpd=$(meson_multilib_native_use http)
		-Dlz4=false
		-Dxz=$(meson_use lzma)
		-Dlibiptc=false
		-Dpam=false
		-Dpcre2=$(meson_multilib_native_use pcre)
		-Dpolkit=false
		-Dqrencode=$(meson_multilib_native_use qrcode)
		-Dseccomp=$(meson_multilib_native_use seccomp)
		-Dselinux=$(meson_multilib_native_use selinux)
		-Dadm-group=false
		-Dwheel-group=false
		-Dlibidn2=false
		-Dlibidn=false
	)

	meson_src_configure "${myconf[@]}"
}

multilib_src_compile() {
	eninja
}

multilib_src_install() {
	DESTDIR="${D}" eninja install
	mv ${D}/usr/$(get_libdir)/pkgconfig/{libsystemd,journald}.pc
}
