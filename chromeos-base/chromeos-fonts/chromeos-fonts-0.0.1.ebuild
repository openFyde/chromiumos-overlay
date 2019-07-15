# Copyright (c) 2012 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=5

DESCRIPTION="Chrome OS Fonts (meta package)"
HOMEPAGE="http://src.chromium.org"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="*"
IUSE="cros_host internal"

# List of font packages used in Chromium OS.  This list is separate
# so that it can be shared between the host in
# chromeos-base/hard-host-depends and the target in
# chromeos-base/chromeos.
#
# The glibc requirement is a bit funky.  For target boards, we make sure it is
# installed before any other package (by way of setup_board), but for the sdk
# board, we don't have that toolchain-specific tweak.  So we end up installing
# these in parallel and the chroot logic for font generation fails.  We can
# drop this when we stop executing the helper in the $ROOT via `chroot` and/or
# `qemu` (e.g. when we do `ROOT=/build/amd64-host/ emerge chromeos-fonts`).
#
# The gcc-libs requirement is a similar situation.  Ultimately this comes down
# to fixing http://crbug.com/205424.
DEPEND="
	internal? (
		chromeos-base/monotype-fonts
		chromeos-base/google-sans-fonts
	)
	media-fonts/croscorefonts
	media-fonts/crosextrafonts
	media-fonts/crosextrafonts-carlito
	media-fonts/noto-cjk
	media-fonts/notofonts
	media-fonts/ko-nanumfonts
	media-fonts/lohitfonts-cros
	media-fonts/robotofonts
	media-fonts/tibt-jomolhari
	media-libs/fontconfig
	!cros_host? ( sys-libs/gcc-libs )
	cros_host? ( sys-libs/glibc )
	"
RDEPEND="${DEPEND}"

S=${WORKDIR}

qemu_run() {
	# Run the emulator to execute command. It needs to be copied
	# temporarily into the sysroot because we chroot to it.
	local qemu=()
	case "${ARCH}" in
		amd64)
			# Note that qemu is not actually run below in this case.
			qemu=( qemu-x86_64 -cpu max )
			;;
		arm)
			qemu=( qemu-arm )
			;;
		arm64)
			qemu=( qemu-aarch64 )
			;;
		mips)
			qemu=( qemu-mipsel )
			;;
		x86)
			qemu=( qemu-i386 -cpu max )
			;;
		*)
			die "Unable to determine QEMU from ARCH."
	esac

	# The following code uses sudo to generate the font-cache.  It is almost
	# always not a good idea to use sudo in your ebuild.  This ebuild is an
	# exception for the following reasons:
	#
	# - fc-cache was designed with the generic linux distribution use case
	#   in mind where package maintainers have no idea what fonts are actually
	#   installed on the system.  As a result fc-cache operates directly on
	#   the target file system and needs permission to modify its cache
	#   directory (/usr/share/cache/fontconfig), which is owned by root.
	# - When cross-compiling, the generated font caches need to be compatible
	#   with the architecture on which they will be used.  To properly do
	#   this, we need to run the architecture appropriate copy of fc-cache,
	#   which may link against other arch-specific libraries, which means
	#   we need to chroot it in the board sysroot and chrooting requires
	#   root permissions.
	#
	# By themselves the above two reasons are not sufficient to justify
	# using sudo in the ebuild.  What makes this OK is that fc-cache takes
	# a really long time when run under qemu for ARM (4 - 7 minutes), which
	# is a very large percentage of the overall time spent in build_image.
	# It doesn't make sense to force each developer to spend a bunch of time
	# generating the exact same font cache on their machine every time they
	# want to build an image.  And even then, we can only do this because
	# chromeos-fonts is a specialized ebuild for chrome os only.
	#
	# All of which is to say: don't use sudo in your ebuild.  You have been
	# warned.  -- chirantan

	cp "/usr/bin/${qemu[0]}" "${ROOT}/tmp" || die
	sudo chroot "${ROOT}" "/tmp/${qemu[0]}" "${qemu[@]:1}" "$@" || die
	rm "${ROOT}/tmp/${qemu[0]}" || die
}

generate_font_cache() {
	# Bind mount over the cache directory so that we don't scribble over the
	# $SYSROOT.  Same warning as above applies: don't use sudo in your ebuild.
	mkdir -p "${WORKDIR}/out"
	if grep -q "${ROOT}/usr/share/cache/fontconfig" /proc/mounts; then
		sudo umount "${ROOT}/usr/share/cache/fontconfig"
	fi
	sudo mount --bind "${WORKDIR}/out" "${ROOT}/usr/share/cache/fontconfig"

	# If we're running directly on the target (e.g. gmerge), we don't need
	# to chroot or use qemu.  Run in a subshell so that we can clean up
	# the bind mount even if fc-cache fails.
	(
		if [[ "${ROOT:-/}" == "/" ]]; then
			sudo /usr/bin/fc-cache -f -v || die
		elif [[ "${ARCH}" == "amd64" ]]; then
			# Uses the host's fc-cache binary to build the font
			# cache on the target.
			sudo /usr/bin/fc-cache --sysroot="${SYSROOT}" -f -v
		else
			qemu_run /usr/bin/fc-cache -f -v
		fi
	)
	local retval=$?

	sudo umount "${ROOT}/usr/share/cache/fontconfig"
	[[ ${retval} == 0 ]] || die "fc-cache failed"
}

# TODO(cjmcdonald): crbug/913317 These .uuid files need to exist when fc-cache
#                   is run otherwise fontconfig tries to write them to the font
#                   directories and generates portage sandbox violations.
#                   Additionally, the .uuid files need to be installed as part
#                   of this package so that they exist when this package is
#                   installed as a binpkg. Remove this section once fontconfig
#                   no longer uses these .uuid files.
pkg_setup() {
	local fontdir fontdirs=( $(cd "${SYSROOT}"/usr/share/fonts; echo */) )
	for fontdir in "${fontdirs[@]}"; do
		uuidgen --sha1 -n @dns -N "$(usev cros_host)${fontdir}" > \
			"${SYSROOT}"/usr/share/fonts/"${fontdir}"/.uuid
	done
}

src_compile() {
	generate_font_cache
}

src_install() {
	insinto /usr/share/cache/fontconfig
	doins "${WORKDIR}"/out/*

	local fontdir fontdirs=( $(cd "${SYSROOT}"/usr/share/fonts; echo */) )
	for fontdir in "${fontdirs[@]}"; do
		insinto "/usr/share/fonts/${fontdir}"
		uuidgen --sha1 -n @dns -N "$(usev cros_host)${fontdir}" | newins - .uuid
	done
}
