# Copyright 2012 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cros-constants

DESCRIPTION="Chrome OS Fonts (meta package)"
HOMEPAGE="http://src.chromium.org"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="*"
IUSE="cros_host extra_japanese_fonts internal"

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
		chromeos-base/monotype-fonts:=
		>=chromeos-base/google-sans-fonts-3.0.0:=
	)
	media-fonts/croscorefonts:=
	media-fonts/crosextrafonts:=
	media-fonts/crosextrafonts-carlito:=
	media-fonts/noto-cjk:=
	media-fonts/notofonts:=
	media-fonts/ko-nanumfonts:=
	media-fonts/lohitfonts-cros:=
	media-fonts/robotofonts:=
	media-fonts/tibt-jomolhari:=
	media-libs/fontconfig:=
	!cros_host? ( sys-libs/gcc-libs:= )
	cros_host? ( sys-libs/glibc:= )
	extra_japanese_fonts? (
		media-fonts/ipaex
		media-fonts/morisawa-ud-fonts
	)
	"
RDEPEND="${DEPEND}"

S=${WORKDIR}

# When cross-compiling, the generated font caches need to be compatible with
# the architecture on which they will be used, so we run the target fc-cache
# through platform2_test.py (and QEMU).
generate_font_cache() {
	local out_path="${WORKDIR}/out"
	local conf_path="${WORKDIR}/fonts.conf"
	# Strip the ${SYSROOT} prefix.
	local sysroot_out_path="${out_path/#${SYSROOT}/}"
	local sysroot_conf_path="${conf_path/#${SYSROOT}/}"

	mkdir -p "${out_path}" || die

	# fc-cache only supports redirecting cache output based on its config
	# files. Rewrite one to point into ${WORKDIR} on the fly. i.e., replace:
	#   <cachedir>/original/etc/cache/path/</cachedir>
	# with:
	#   <cachedir>${out_path}</cachedir>
	sed '/<cachedir>/ s:<cachedir>\(.*\)<\/cachedir>:<cachedir>'"${sysroot_out_path}"'<\/cachedir>:' \
		"${SYSROOT}"/etc/fonts/fonts.conf > "${conf_path}" || die

	# Per https://reproducible-builds.org/specs/source-date-epoch/, this
	# should be the last modification time of the source (date +%s). In
	# practice, we just need it to be older than the timestamp of anyone
	# building this package, and greater than 0 (fontconfig ignores 0
	# values).
	local TIMESTAMP=1
	if [[ "${ARCH}" == "amd64" ]]; then
		# Special-case for amd64: the target ISA may not match our
		# build host (so we can't run natively;
		# https://crbug.com/856686), and we may not have QEMU support
		# for the full ISA either. Just run the SDK binary instead.
		FONTCONFIG_FILE="${conf_path}" \
		SOURCE_DATE_EPOCH="${TIMESTAMP}" \
			/usr/bin/fc-cache -f -v --sysroot "${SYSROOT:-/}" || die
	else
		"${CHROOT_SOURCE_ROOT}"/src/platform2/common-mk/platform2_test.py \
			--env FONTCONFIG_FILE="${sysroot_conf_path}" \
			--env SOURCE_DATE_EPOCH="${TIMESTAMP}" \
			--sysroot "${SYSROOT}" \
			-- /usr/bin/fc-cache -f -v || die
	fi
}

# Determine whether $1 is an empty directory.
emptydir() {
	[[ -z "$(find "$1" -mindepth 1 -maxdepth 1 '!' -name .uuid)" ]]
}

# TODO(cjmcdonald): crbug/913317 These .uuid files need to exist when fc-cache
#                   is run otherwise fontconfig tries to write them to the font
#                   directories and generates portage sandbox violations.
#                   Additionally, the .uuid files need to be installed as part
#                   of this package so that they exist when this package is
#                   installed as a binpkg. Remove this section once fontconfig
#                   no longer uses these .uuid files.
pkg_setup() {
	local fontdir fontname uuid
	while read -r -d $'\0' fontname; do
		fontdir="${SYSROOT}/usr/share/fonts/${fontname}"
		uuid="${fontdir}/.uuid"
		if emptydir "${fontdir}"; then
			# Clean up old entries.
			rm -fv "${uuid}"
			rmdir -v "${fontdir}"
		else
			uuidgen --sha1 -n @dns -N "$(usev cros_host)${fontname}" > "${uuid}" || die
		fi
	done < <(find "${SYSROOT}"/usr/share/fonts/ -depth -mindepth 1 -type d -printf '%P\0')
}

src_compile() {
	generate_font_cache
}

src_install() {
	insinto /usr/share/cache/fontconfig
	doins "${WORKDIR}"/out/*

	local fontdir fontname
	while read -r -d $'\0' fontname; do
		# If the fontdir is empty, don't generate.
		if ! emptydir "${SYSROOT}/usr/share/fonts/${fontname}"; then
			insinto "/usr/share/fonts/${fontname}"
			(uuidgen --sha1 -n @dns -N "$(usev cros_host)${fontname}" || die) | \
				newins - .uuid
		fi
	done < <(find "${SYSROOT}"/usr/share/fonts/ -mindepth 1 -type d -printf '%P\0')
}
