# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="7"

inherit autotools bash-completion-r1 eutils multilib multilib-minimal toolchain-funcs udev user

if [[ ${PV} = 9999* ]]; then
	EGIT_REPO_URI="git://anongit.freedesktop.org/systemd/systemd"
	inherit git-r3
else
	SRC_URI="https://github.com/systemd/systemd/archive/v${PV}.tar.gz -> systemd-${PV}.tar.gz"
	KEYWORDS="*"
fi

DESCRIPTION="Linux dynamic and persistent device naming support (aka userspace devfs)"
HOMEPAGE="https://www.freedesktop.org/wiki/Software/systemd"

LICENSE="LGPL-2.1 MIT GPL-2"
SLOT="0"
IUSE="acl +kmod openrc selinux static-libs"

RESTRICT="test"

# Force new make >= -r4 to skip some parallel build issues
BDEPEND="
	dev-util/gperf
	>=dev-util/intltool-0.50
	>=sys-apps/coreutils-8.16
	virtual/pkgconfig
	>=sys-devel/make-3.82-r4
	app-text/docbook-xml-dtd:4.2
	app-text/docbook-xml-dtd:4.5
	app-text/docbook-xsl-stylesheets
	dev-libs/libxslt
"
COMMON_DEPEND=">=sys-apps/util-linux-2.24
	sys-libs/libcap[${MULTILIB_USEDEP}]
	acl? ( sys-apps/acl )
	kmod? ( >=sys-apps/kmod-16 )
	selinux? ( >=sys-libs/libselinux-2.1.9 )
	!<sys-libs/glibc-2.11
	!sys-apps/gentoo-systemd-integration
	!sys-apps/systemd
	abi_x86_32? (
		!<=app-emulation/emul-linux-x86-baselibs-20130224-r7
		!app-emulation/emul-linux-x86-baselibs[-abi_x86_32(-)]
	)"
DEPEND="${COMMON_DEPEND}
	virtual/os-headers
	>=sys-kernel/linux-headers-3.9"
RDEPEND="${COMMON_DEPEND}
	!<sec-policy/selinux-base-2.20120725-r10"
PDEPEND=">=sys-apps/hwids-20140304[udev]
	openrc? ( >=sys-fs/udev-init-scripts-26 )"

S=${WORKDIR}/systemd-${PV}

PATCHES=(
	"${FILESDIR}"/${PN}-225-50-udev-default.rules-set-default-group-for-mediaX.patch
	"${FILESDIR}"/${PN}-225-60-persistent-storage.rules-add-nvme-symlinks.patch
	"${FILESDIR}"/${PN}-225-libudev-util-change-util_replace_whitespace.patch
	"${FILESDIR}"/${PN}-225-udev-event-add-replace_whitespace-param.patch
	"${FILESDIR}"/${PN}-225-udev-rules-perform-whitespace-replacement.patch
	"${FILESDIR}"/${PN}-225-60-persistent-storage.rules-add-nvme-id-model.patch
	"${FILESDIR}"/${PN}-225-udev-rules-all-values-can-contain-escaped-double-quotes-now.patch
	"${FILESDIR}"/${PN}-225-udevadm-trigger-add-settle.patch
	"${FILESDIR}"/${PN}-225-v4l_id-check-mplane-video-capture-and-output-capaili.patch
	"${FILESDIR}"/${PN}-225-udevadm-hwdb-Return-non-zero-exit-code-on-error.patch
	"${FILESDIR}"/${PN}-225-sysmacros.patch
	"${FILESDIR}"/${PN}-225-50-udev-default.rules-set-default-group-for-udmabuf.patch
	"${FILESDIR}"/${PN}-225-50-udev-default.rules-disable-REMOVE_CMD-support.patch
	"${FILESDIR}"/${PN}-225-udev-rules-no-slash-run.patch
	"${FILESDIR}"/${PN}-225-udev-use-interface-before-the-string-that-interface-.patch
	"${FILESDIR}"/${PN}-225-udev-stop-freeing-value-after-using-it-for-setting-s.patch
	"${FILESDIR}"/${PN}-225-workaround-renameat-syscall-wrapper-misdetection.patch
	"${FILESDIR}"/${PN}-225-udevadm-add-ping-option-to-control-command.patch
	"${FILESDIR}"/${PN}-225-fix-joystick-with-mouse-identification.patch
	"${FILESDIR}"/${PN}-225-bypass-v4l_id-query-for-mipi-camera-related-dev.patch
	"${FILESDIR}"/${PN}-225-sd-device-udev-db-handle-properties-with-empty-value.patch
	"${FILESDIR}"/${PN}-225-systemd-size_t.patch
)

check_default_rules() {
	# Make sure there are no sudden changes to upstream rules file
	# (more for my own needs than anything else ...)
	local udev_rules_md5=870fa6b180bb6b9527905da2cf85e170
	MD5=$(md5sum < "${S}"/rules/50-udev-default.rules)
	MD5=${MD5/  -/}
	if [[ ${MD5} != ${udev_rules_md5} ]]; then
		eerror "50-udev-default.rules has been updated, please validate!"
		eerror "md5sum: ${MD5}"
		die "50-udev-default.rules has been updated, please validate!"
	fi
}

src_prepare() {
	if ! [[ ${PV} = 9999* ]]; then
		check_default_rules

		# secure_getenv() disable for non-glibc systems wrt bug #443030
		if ! [[ $(grep -r secure_getenv * | wc -l) -eq 25 ]]; then
			eerror "The line count for secure_getenv() failed, see bug #443030"
			die
		fi
	fi

	default

	cat <<-EOF > "${T}"/40-gentoo.rules
	# Gentoo specific floppy and usb groups
	SUBSYSTEM=="block", KERNEL=="fd[0-9]", GROUP="floppy"
	SUBSYSTEM=="usb", ENV{DEVTYPE}=="usb_device", GROUP="usb"
	EOF

	# change rules back to group uucp instead of dialout for now wrt #454556
	sed -i -e 's/GROUP="dialout"/GROUP="uucp"/' rules/*.rules || die

	# stub out the am_path_libcrypt function
	echo 'AC_DEFUN([AM_PATH_LIBGCRYPT],[:])' > m4/gcrypt.m4

	eautoreconf

	# Restore possibility of running --enable-static wrt #472608
	sed -i \
		-e '/--enable-static is not supported by systemd/s:as_fn_error:echo:' \
		configure || die

	if ! use elibc_glibc; then #443030
		echo '#define secure_getenv(x) NULL' >> config.h.in
		sed -i -e '/error.*secure_getenv/s:.*:#define secure_getenv(x) NULL:' src/shared/missing.h || die
	fi
}

src_configure() {
	cros_optimize_package_for_speed

	# Prevent conflicts with i686 cross toolchain, bug 559726
	tc-export AR CC NM OBJCOPY RANLIB
	multilib-minimal_src_configure
}

multilib_src_configure() {
	tc-export CC #463846
	export cc_cv_CFLAGS__flto=no #502950
	export cc_cv_CFLAGS__Werror_shadow=no #554454

	# Keep sorted by ./configure --help and only pass --disable flags
	# when *required* to avoid external deps or unnecessary compile
	local econf_args
	econf_args=(
		--libdir=/usr/$(get_libdir)
		--docdir=/usr/share/doc/${PF}
		$(multilib_native_use_enable static-libs static)
		--disable-nls
		--disable-dbus
		$(multilib_native_use_enable kmod)
		--disable-xkbcommon
		--disable-seccomp
		$(multilib_native_use_enable selinux)
		--disable-xz
		--disable-lz4
		--disable-pam
		$(multilib_native_use_enable acl)
		--disable-gcrypt
		--disable-audit
		--disable-libcryptsetup
		--disable-qrencode
		--disable-microhttpd
		--disable-gnuefi
		--disable-gnutls
		--disable-libcurl
		--disable-libidn
		--disable-quotacheck
		--disable-logind
		--disable-polkit
		--disable-myhostname
		$(multilib_is_native_abi || echo "--disable-manpages")
		--enable-split-usr
		--without-python
		--with-bashcompletiondir="$(get_bashcompdir)"
		--with-rootprefix=
		$(multilib_is_native_abi && echo "--with-rootlibdir=/$(get_libdir)")
		--disable-elfutils
	)

	if ! multilib_is_native_abi; then
		econf_args+=(
			MOUNT_{CFLAGS,LIBS}=' '
		)
	fi

	ECONF_SOURCE=${S} econf "${econf_args[@]}"
}

multilib_src_compile() {
	echo 'BUILT_SOURCES: $(BUILT_SOURCES)' > "${T}"/Makefile.extra
	emake -f Makefile -f "${T}"/Makefile.extra BUILT_SOURCES

	# Most of the parallel build problems were solved by >=sys-devel/make-3.82-r4,
	# but not everything -- separate building of the binaries as a workaround,
	# which will force internal libraries required for the helpers to be built
	# early enough, like eg. libsystemd-shared.la
	if multilib_is_native_abi; then
		local lib_targets=( libudev.la )
		emake "${lib_targets[@]}"

		local exec_targets=(
			systemd-udevd
			udevadm
		)
		emake "${exec_targets[@]}"

		local helper_targets=(
			ata_id
			cdrom_id
			collect
			scsi_id
			v4l_id
			mtd_probe
		)
		emake "${helper_targets[@]}"

		local man_targets=(
			man/udev.conf.5
			man/systemd.link.5
			man/udev.7
			man/systemd-udevd.service.8
			man/udevadm.8
		)
		emake "${man_targets[@]}"
	else
		local lib_targets=( libudev.la )
		emake "${lib_targets[@]}"
	fi
}

multilib_src_install() {
	if multilib_is_native_abi; then
		local lib_LTLIBRARIES="libudev.la"
		local pkgconfiglib_DATA="src/libudev/libudev.pc"

		local targets=(
			install-libLTLIBRARIES
			install-includeHEADERS
			install-rootbinPROGRAMS
			install-rootlibexecPROGRAMS
			install-udevlibexecPROGRAMS
			install-dist_udevconfDATA
			install-dist_udevrulesDATA
			install-pkgconfiglibDATA
			install-pkgconfigdataDATA
			install-dist_docDATA
			libudev-install-hook
			install-directories-hook
			install-dist_bashcompletionDATA
			install-dist_networkDATA
		)

		# add final values of variables:
		targets+=(
			rootlibexec_PROGRAMS=systemd-udevd
			rootbin_PROGRAMS=udevadm
			lib_LTLIBRARIES="${lib_LTLIBRARIES}"
			pkgconfiglib_DATA="${pkgconfiglib_DATA}"
			pkgconfigdata_DATA="src/udev/udev.pc"
			INSTALL_DIRS='$(sysconfdir)/udev/rules.d $(sysconfdir)/udev/hwdb.d $(sysconfdir)/systemd/network'
			dist_bashcompletion_DATA="shell-completion/bash/udevadm"
			dist_network_DATA="network/99-default.link"
		)
		emake -j1 DESTDIR="${D}" "${targets[@]}"
		doman man/{udev.conf.5,systemd.link.5,udev.7,systemd-udevd.service.8,udevadm.8}
	else
		local lib_LTLIBRARIES="libudev.la"
		local pkgconfiglib_DATA="src/libudev/libudev.pc"
		local include_HEADERS="src/libudev/libudev.h"

		local targets=(
			install-libLTLIBRARIES
			install-includeHEADERS
			install-pkgconfiglibDATA
		)

		targets+=(
			lib_LTLIBRARIES="${lib_LTLIBRARIES}"
			pkgconfiglib_DATA="${pkgconfiglib_DATA}"
			include_HEADERS="${include_HEADERS}"
			)
		emake -j1 DESTDIR="${D}" "${targets[@]}"
	fi

	# Move back to the old path since we filter out */systemd/* from images.
	dodir /sbin
	mv "${ED}"/lib/systemd/systemd-udevd "${ED}"/sbin/udevd || die
}

multilib_src_install_all() {
	dodoc TODO

	find "${D}"/usr -name '*.la' -delete
	rm -f "${D}"/lib/udev/rules.d/99-systemd.rules
	rm -f "${D}"/usr/share/doc/${PF}/{LICENSE.*,GVARIANT-SERIALIZATION,DIFFERENCES,PORTING-DBUS1,sd-shutdown.h}

	# see src_prepare() for content of 40-gentoo.rules
	insinto /lib/udev/rules.d
	doins "${T}"/40-gentoo.rules

	# maintainer note: by not letting the upstream build-sys create the .so
	# link, you also avoid a parallel make problem
	mv "${D}"/usr/share/man/man8/systemd-udevd{.service,}.8
}

pkg_postinst() {
	mkdir -p "${ROOT%/}"/run

	# "losetup -f" is confused if there is an empty /dev/loop/, Bug #338766
	# So try to remove it here (will only work if empty).
	rmdir "${ROOT%/}"/dev/loop 2>/dev/null
	if [[ -d ${ROOT%/}/dev/loop ]]; then
		ewarn "Please make sure your remove /dev/loop,"
		ewarn "else losetup may be confused when looking for unused devices."
	fi

	local fstab="${ROOT%/}"/etc/fstab dev path fstype rest
	while read -r dev path fstype rest; do
		if [[ ${path} == /dev && ${fstype} != devtmpfs ]]; then
			ewarn "You need to edit your /dev line in ${fstab} to have devtmpfs"
			ewarn "filesystem. Otherwise udev won't be able to boot."
			ewarn "See, https://bugs.gentoo.org/453186"
		fi
	done < "${fstab}"

	if [[ -d ${ROOT%/}/usr/lib/udev ]]; then
		ewarn
		ewarn "Please re-emerge all packages on your system which install"
		ewarn "rules and helpers in /usr/lib/udev. They should now be in"
		ewarn "/lib/udev."
		ewarn
		ewarn "One way to do this is to run the following command:"
		ewarn "emerge -av1 \$(qfile -q -S -C /usr/lib/udev)"
		ewarn "Note that qfile can be found in app-portage/portage-utils"
	fi

	local old_cd_rules="${ROOT%/}"/etc/udev/rules.d/70-persistent-cd.rules
	local old_net_rules="${ROOT%/}"/etc/udev/rules.d/70-persistent-net.rules
	for old_rules in "${old_cd_rules}" "${old_net_rules}"; do
		if [[ -f ${old_rules} ]]; then
			ewarn
			ewarn "File ${old_rules} is from old udev installation but if you still use it,"
			ewarn "rename it to something else starting with 70- to silence this deprecation"
			ewarn "warning."
		fi
	done

	# If user has disabled 80-net-name-slot.rules using a empty file or a symlink to /dev/null,
	# do the same for 80-net-setup-link.rules to keep the old behavior
	local net_move=no
	local net_name_slot_sym=no
	local net_rules_path="${ROOT%/}"/etc/udev/rules.d
	local net_name_slot="${net_rules_path}"/80-net-name-slot.rules
	local net_setup_link="${net_rules_path}"/80-net-setup-link.rules
	if [[ ! -e ${net_setup_link} ]]; then
		[[ -f ${net_name_slot} && $(sed -e "/^#/d" -e "/^\W*$/d" ${net_name_slot} | wc -l) == 0 ]] && net_move=yes
		if [[ -L ${net_name_slot} && $(readlink ${net_name_slot}) == /dev/null ]]; then
			net_move=yes
			net_name_slot_sym=yes
		fi
	fi
	if [[ ${net_move} == yes ]]; then
		ebegin "Copying ${net_name_slot} to ${net_setup_link}"

		if [[ ${net_name_slot_sym} == yes ]]; then
			ln -nfs /dev/null "${net_setup_link}"
		else
			cp "${net_name_slot}" "${net_setup_link}"
		fi
		eend $?
	fi

	# https://cgit.freedesktop.org/systemd/systemd/commit/rules/50-udev-default.rules?id=3dff3e00e044e2d53c76fa842b9a4759d4a50e69
	# https://bugs.gentoo.org/246847
	# https://bugs.gentoo.org/514174
	enewgroup input

	# Update hwdb database in case the format is changed by udev version.
	if has_version 'sys-apps/hwids[udev]'; then
		udevadm hwdb --update --root="${ROOT%/}"
		# Only reload when we are not upgrading to avoid potential race w/ incompatible hwdb.bin and the running udevd
		# https://cgit.freedesktop.org/systemd/systemd/commit/?id=1fab57c209035f7e66198343074e9cee06718bda
		[[ -z ${REPLACING_VERSIONS} ]] && udev_reload
	fi
}
