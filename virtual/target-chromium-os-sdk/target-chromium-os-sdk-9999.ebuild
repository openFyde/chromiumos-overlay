# Copyright 2014 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

# This ebuild only cares about its own FILESDIR and ebuild file, so it tracks
# the canonical empty project.
CROS_WORKON_PROJECT="chromiumos/infra/build/empty-project"
CROS_WORKON_LOCALNAME="../platform/empty-project"

inherit cros-workon

DESCRIPTION="List of packages that are needed inside the Chromium OS SDK"
HOMEPAGE="https://dev.chromium.org/"

LICENSE="metapackage"
SLOT="0"
KEYWORDS="~*"
# Note: Do not utilize USE=internal here.  Update virtual/target-chrome-os-sdk.
IUSE="python_targets_python3_6 python_targets_python3_8"

# Block the old package to force people to clean up.
RDEPEND="
	!chromeos-base/hard-host-depends
	!virtual/hard-host-depends-bsp
"

# Basic utilities
RDEPEND="${RDEPEND}
	app-arch/bzip2
	app-arch/cpio
	app-arch/gcab
	app-arch/gzip
	app-arch/p7zip
	app-arch/tar
	app-shells/bash
	dev-lang/rust-bootstrap
	dev-lang/rust-host
	net-misc/iputils
	net-misc/rsync
	sys-apps/baselayout
	sys-apps/coreutils
	sys-apps/diffutils
	sys-apps/dtc
	sys-apps/file
	sys-apps/findutils
	sys-apps/gawk
	sys-apps/grep
	sys-apps/ripgrep
	sys-apps/sed
	sys-apps/shadow
	sys-apps/texinfo
	sys-apps/util-linux
	sys-apps/which
	sys-devel/autoconf
	sys-devel/autoconf-archive
	sys-devel/automake:1.11
	sys-devel/automake:1.15
	sys-devel/binutils
	sys-devel/bison
	sys-devel/flex
	sys-devel/gcc
	sys-devel/gdb
	sys-devel/gnuconfig
	sys-devel/grit-i18n
	sys-devel/libtool
	sys-devel/m4
	sys-devel/make
	sys-devel/patch
	sys-fs/e2fsprogs
	sys-fs/f2fs-tools
	sys-libs/ncurses
	sys-libs/readline
	sys-libs/zlib
	sys-process/procps
	sys-process/psmisc
	sys-process/time
	virtual/editor
	virtual/libc
	virtual/man
	virtual/os-headers
	virtual/package-manager
	virtual/pager
	virtual/rust
	"

# Needed to run setup crossdev, run build scripts, and make a bootable image.
RDEPEND="${RDEPEND}
	app-arch/lbzip2
	app-arch/lz4
	app-arch/lzop
	app-arch/pigz
	app-arch/pixz
	app-admin/sudo
	app-crypt/efitools
	app-crypt/sbsigntools
	chromeos-base/zephyr-build-tools
	dev-embedded/binman
	dev-embedded/cbootimage
	dev-embedded/tegrarcm
	dev-embedded/u-boot-tools
	dev-util/ccache
	media-gfx/pngcrush
	>=sys-apps/dtc-1.3.0-r5
	sys-boot/bootstub
	sys-boot/grub
	sys-boot/syslinux
	sys-devel/crossdev
	sys-fs/dosfstools
	sys-fs/squashfs-tools
	sys-fs/mtd-utils
	"

# Needed to build Android/ARC userland code.
RDEPEND="${RDEPEND}
	app-misc/jq
	chromeos-base/mk-payload
	sys-devel/aapt
	sys-devel/arc-toolchain-master
	sys-devel/arc-toolchain-p
	sys-devel/arc-toolchain-r
	sys-devel/dex2oatds
	"

# Needed to run 'repo selfupdate'
RDEPEND="${RDEPEND}
	app-crypt/gnupg
	"

# Host dependencies for building cross-compiled packages.
RDEPEND="${RDEPEND}
	app-admin/eselect-opengl
	app-admin/eselect-mesa
	app-arch/cabextract
	app-arch/makeself
	app-arch/rpm2targz
	app-arch/sharutils
	app-arch/unzip
	app-crypt/nss
	app-doc/xmltoman
	app-emulation/qemu
	app-emulation/qemu-binfmt-wrapper
	!app-emulation/qemu-kvm
	!app-emulation/qemu-user
	app-text/asciidoc
	app-text/docbook-xml-dtd:4.2
	app-text/docbook-xml-dtd:4.5
	app-text/docbook-xsl-stylesheets
	app-text/texi2html
	app-text/xmlto
	chromeos-base/google-breakpad
	chromeos-base/chromeos-base
	chromeos-base/chromeos-common-script
	>=chromeos-base/chromeos-config-host-0.0.2-r491
	chromeos-base/chromite-sdk
	chromeos-base/cros-devutils[cros_host]
	chromeos-base/cros-testutils
	chromeos-base/ec-devutils
	chromeos-base/minijail
	chromeos-base/mojo-tools
	dev-db/m17n-db
	dev-go/protobuf
	dev-go/protobuf-legacy-api
	dev-lang/closure-compiler-bin
	dev-lang/nasm
	python_targets_python3_6? ( dev-lang/python:3.6 )
	python_targets_python3_8? ( dev-lang/python:3.8 )
	dev-lang/swig
	dev-lang/tcl
	dev-lang/yasm
	dev-libs/dbus-glib
	dev-libs/flatbuffers
	>=dev-libs/glib-2.26.1
	net-libs/grpc
	dev-libs/libgcrypt
	dev-libs/libxslt
	dev-libs/libyaml
	dev-libs/m17n-lib
	dev-libs/protobuf
	dev-libs/protobuf-c
	dev-libs/wayland
	dev-python/cffi
	dev-python/cherrypy
	dev-python/dbus-python
	dev-python/dpkt
	dev-python/ecdsa
	dev-python/flatbuffers
	dev-python/future
	dev-python/intelhex
	dev-python/kconfiglib
	dev-python/m2crypto
	dev-python/mako
	dev-python/netifaces
	dev-python/pexpect
	dev-python/pillow
	dev-python/psutil
	dev-python/py
	dev-python/pycairo
	dev-python/pycparser
	dev-python/pydbus
	dev-python/pygobject
	dev-python/pyopenssl
	dev-python/pytest
	dev-python/python-evdev
	dev-python/python-magic
	dev-python/pyudev
	dev-python/pyusb
	dev-python/setproctitle
	!dev-python/socksipy
	dev-python/tempita
	dev-python/ws4py
	dev-util/cmake
	dev-util/cmocka
	dev-util/gob
	dev-util/gdbus-codegen
	dev-util/gperf
	dev-util/gtk-doc
	dev-util/hdctools
	>=dev-util/gtk-doc-am-1.13
	>=dev-util/intltool-0.30
	dev-util/pahole
	dev-util/scons
	dev-util/test-services
	dev-util/vulkan-headers
	>=dev-vcs/git-1.7.2
	>=media-libs/freetype-2.2.1
	>=media-libs/lcms-2.6:2
	net-fs/sshfs
	net-libs/rpcsvc-proto
	net-misc/gsutil
	sys-apps/usbutils
	!sys-apps/nih-dbus-tool
	sys-devel/autofdo
	sys-devel/bc
	sys-devel/llvm
	>=sys-libs/glibc-2.27
	sys-libs/libcxx
	sys-libs/llvm-libunwind
	virtual/udev
	sys-libs/libnih
	sys-power/iasl
	sys-apps/kmod[tools]
	x11-apps/mkfontscale
	x11-apps/xkbcomp
	>=x11-misc/util-macros-1.2
	"

# TODO(toolchain): Remove this libxcrypt dep after all packages directly depend
# on it and it is not installed as a system library anymore
RDEPEND="${RDEPEND}
	sys-libs/libxcrypt
	"

# Multiple versions of Bazel are provided for long-term compatibility.
# Slot 0 corresponds to the version packaged by upstream Gentoo, while
# other slots correspond to LTS releases packaged by us.
RDEPEND="${RDEPEND}
	dev-util/bazel:0
	dev-util/bazel:5
	"

# Various fonts are needed in order to generate messages for the
# chromeos-initramfs package.
RDEPEND="${RDEPEND}
	chromeos-base/chromeos-fonts
	"

# Host dependencies for bitmap block (chromeos-bmpblk) to to render messages.
RDEPEND="${RDEPEND}
	gnome-base/librsvg
	"

# Host dependencies for building chromium.
# Intermediate executables built for the host, then run to generate data baked
# into chromium, need these packages to be present in the host environment in
# order to successfully build.
# See: http://codereview.chromium.org/7550002/
RDEPEND="${RDEPEND}
	dev-libs/atk
	dev-libs/glib
	media-libs/fontconfig
	media-libs/freetype
	x11-libs/cairo
	x11-libs/libX11
	x11-libs/libXi
	x11-libs/libXrandr
	x11-libs/libXtst
	x11-libs/pango
	"

# Host dependencies that create usernames/groups we need to pull over to target.
RDEPEND="${RDEPEND}
	sys-apps/dbus
	"

# Host dependencies that are needed by mod_image_for_test.
RDEPEND="${RDEPEND}
	sys-process/lsof
	"

# Useful utilities for developers.
RDEPEND="${RDEPEND}
	app-arch/zip
	app-editors/nano
	app-editors/qemacs
	app-editors/vim
	app-portage/eclass-manpages
	app-portage/gentoolkit
	app-portage/portage-utils
	app-portage/repoman
	app-shells/bash-completion
	x86?   ( dev-go/delve )
	amd64? ( dev-go/delve )
	arm64? ( dev-go/delve )
	dev-go/go-tools
	dev-go/golint
	dev-lang/go
	dev-util/codespell
	dev-util/patchutils
	dev-util/perf
	dev-util/shfmt
	net-analyzer/netperf
	sys-apps/less
	sys-apps/man-pages
	sys-apps/pv
	sys-devel/smatch
	sys-devel/sparse
	"

# Host dependencies used by chromite on build servers
RDEPEND="${RDEPEND}
	dev-python/google-cloud-logging
	dev-python/mysqlclient
	dev-python/pyparsing
	dev-python/virtualenv
	"

# Host dependencies that are needed for unit tests
RDEPEND="${RDEPEND}
	x11-misc/xkeyboard-config
	"

# Host dependencies that are needed to build the autotest server components.
RDEPEND="${RDEPEND}
	dev-util/google-web-toolkit
	"

# Host dependencies that are needed for autotests.
RDEPEND="${RDEPEND}
	dev-python/btsocket
	dev-python/selenium
	sys-apps/iproute2
	sys-apps/net-tools
	"

# Host dependencies that are needed for media applications (ex, mplayer) used in
# factory.
RDEPEND="${RDEPEND}
	media-video/ffmpeg
	"

# Host dependencies that are needed to create and sign images
RDEPEND="${RDEPEND}
	>=chromeos-base/vboot_reference-1.0-r174
	chromeos-base/verity
	!dev-python/ahocorasick
	dev-python/pyahocorasick
	sys-fs/libfat
	"

# Host dependencies that are needed for cros_generate_update_payload.
RDEPEND="${RDEPEND}
	chromeos-base/update_engine-client
	chromeos-base/update_engine
	sys-fs/e2tools
	"

# Host dependencies to run unit tests within the chroot
RDEPEND="${RDEPEND}
	dev-cpp/gflags
	dev-go/mock
	dev-go/test
	"
# Host dependencies to run autotest's unit tests within the chroot.
RDEPEND="${RDEPEND}
	dev-python/httplib2
	dev-python/pyshark
	dev-python/python-dateutil
	dev-python/six
	"

# Host dependencies to scp binaries from the binary component server
RDEPEND="${RDEPEND}
	net-misc/openssh
	net-misc/socat
	net-misc/wget
	"

# Host dependencies for HWID processing
RDEPEND="${RDEPEND}
	dev-python/pyyaml
	"

# Tools for working with compiler generated profile information
# (such as coverage analysis in common.mk)
RDEPEND="${RDEPEND}
	dev-util/lcov
	"

# Host dependencies for building Platform2
RDEPEND="${RDEPEND}
	chromeos-base/chromeos-dbus-bindings
	chromeos-base/sirenia-tools
	dev-rust/bindgen
	dev-rust/cbindgen
	dev-rust/dbus-codegen
	dev-rust/protobuf-codegen
	dev-util/cxxbridge-cmd
	dev-util/meson
	dev-util/ninja
	"

# Host dependencies for building eBPFs.
RDEPEND="${RDEPEND}
	dev-util/bpftool
	"

# Host dependencies for converting sparse into raw images (simg2img).
RDEPEND="${RDEPEND}
	brillo-base/libsparse
	"

# Host dependencies for building Chromium code (libmojo)
RDEPEND="${RDEPEND}
	dev-python/ply
	dev-util/gn
	"

# Uninstall these packages.
RDEPEND="${RDEPEND}
	!net-misc/dhcpcd
	"

# Host dependencies for building/testing factory software
RDEPEND="${RDEPEND}
	dev-libs/closure-library
	dev-libs/closure_linter
	dev-python/autopep8
	dev-python/crcmod
	dev-python/django
	dev-python/jsonrpclib
	dev-python/jsonschema
	dev-python/pycryptodome
	dev-python/python-gnupg
	dev-python/requests
	dev-python/sphinx
	dev-python/twisted
	!dev-python/twisted-core
	!dev-python/twisted-web
	www-servers/nginx
	"

# Host dependencies for running integration tests
RDEPEND="${RDEPEND}
	chromeos-base/tast-cmd
	chromeos-base/tast-remote-tests
	"

# Host dependencies for building harfbuzz
RDEPEND="${RDEPEND}
	dev-util/ragel
	"

# Host dependencies for building chromeos-bootimage
RDEPEND="${RDEPEND}
	sys-apps/coreboot-utils
	"

# Host dependencies for building chromeos-firmware-*
RDEPEND="${RDEPEND}
	chromeos-base/ec-utils
	"

# Host dependencies for the chromeos-ec workflow
RDEPEND="${RDEPEND}
	chromeos-base/chromeos-ec-headers
	dev-libs/libprotobuf-mutator
	dev-libs/openssl
	dev-util/unifdef
	"

# Host dependencies for the AP/EC/GSC firmware release testing workflow
RDEPEND="${RDEPEND}
	sys-firmware/fw-engprod-tools
	"

# Host dependencies for audio topology generation
RDEPEND="${RDEPEND}
	media-sound/alsa-utils"

# Host dependency for dev-libs/boost package
RDEPEND="${RDEPEND}
	dev-util/boost-build"

# Host dependency for managing SELinux
RDEPEND="${RDEPEND}
	chromeos-base/sepolicy-analyze
	sys-apps/checkpolicy
	sys-apps/restorecon
	sys-apps/secilc
	sys-apps/selinux-python"

# Host dependencies that are needed for chromite/bin/cros_generate_android_breakpad_symbols
RDEPEND="${RDEPEND}
	chromeos-base/android-relocation-packer"

# Host dependencies for generating and testing update payloads
RDEPEND="${RDEPEND}
	chromeos-base/update_payload"

# Needed to compile moblab mobmonitor ui
RDEPEND="${RDEPEND}
	net-libs/nodejs"

# Needed to compile img-ddk
RDEPEND="${RDEPEND}
	dev-python/clang-python"

# Moblab's new RPC server backend will use grpc
RDEPEND="${RDEPEND}
	dev-python/grpcio-tools
	net-libs/grpc-web"

# Autotest's new RPC server will use grpc
RDEPEND="${RDEPEND}
	dev-python/grpcio"

# Needed for unit tests of tast-local-tests-cros
RDEPEND="${RDEPEND}
	dev-util/strace"

# Host dependencies for termina_build_image
RDEPEND="${RDEPEND}
	app-misc/fdupes"

# Host dependencies that lets us boost to performance governor
# to speed up builds.  https://crbug.com/1008932
RDEPEND="${RDEPEND}
	sys-power/cpupower"

# Base layout for java that installs cacerts
RDEPEND="${RDEPEND}
	sys-apps/baselayout-java"

# CTS P depends on Java 8 or 9, CTS R depends on Java 9 or later.
# Include android-sdk to contain both JDK8 and JDK11 in the chroot.
RDEPEND="${RDEPEND}
	chromeos-base/android-sdk"

# Needed to optimise Android APKs shipped in demo_mode_resources.
RDEPEND="${RDEPEND}
	sys-devel/zipalign"

# Needed to build IPA interface in libcamera.
RDEPEND="${RDEPEND}
	dev-python/jinja"

# Needed for packages that need older 4.9.2 GCC.
RDEPEND="${RDEPEND}
	sys-devel/gcc-bin"

# Needed to build crosvm without ebuild in chroot.
RDEPEND="${RDEPEND}
	dev-libs/wayland-protocols
	dev-util/wayland-scanner"

# Needed for hps-firmware.
RDEPEND="${RDEPEND}
	chromeos-base/hps-sign-rom
	dev-rust/svd2rust
	sci-electronics/amaranth
	sci-electronics/litescope
	sci-electronics/liteeth
	sci-electronics/litespi
	sci-electronics/litedram
	sci-electronics/nextpnr
	sci-electronics/pythondata-cpu-vexriscv
	sci-electronics/pythondata-misc-tapcfg
	sci-electronics/verilator
	sci-electronics/yosys
	sci-electronics/yosys-f4pga-plugins
	"

# Needed for cvise.
RDEPEND="${RDEPEND}
	dev-python/pebble
	dev-util/cvise"

# Needed for floss project.
RDEPEND="${RDEPEND}
	net-wireless/floss_tools"

# Needed to build cros-camera-hal-qti.
RDEPEND="${RDEPEND}
	dev-perl/XML-Simple"

# Needed for vkbench.
RDEPEND="${RDEPEND}
	dev-util/glslang"

# Needed for federated-service.
RDEPEND="${RDEPEND}
	app-arch/snappy
	media-libs/giflib"

# Needed by starlark config generation
RDEPEND="${RDEPEND}
	dev-go/lucicfg"

# needed for include what you use.
RDEPEND="${RDEPEND}
	dev-util/iwyu"
