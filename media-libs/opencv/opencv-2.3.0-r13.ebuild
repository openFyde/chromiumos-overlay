# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/opencv/opencv-2.3.0.ebuild,v 1.11 2011/11/22 22:38:59 dilfridge Exp $

EAPI="6"

PYTHON_COMPAT=( python2_7 )

inherit toolchain-funcs cmake-utils python-single-r1

MY_P=OpenCV-${PV}

DESCRIPTION="A collection of algorithms and sample code for various computer vision problems"
HOMEPAGE="http://opencv.willowgarage.com"
SRC_URI="mirror://sourceforge/${PN}library/${MY_P}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="*"
IUSE="cuda eigen examples ffmpeg gstreamer gtk ieee1394 jpeg jpeg2k openexr opengl png python qt4 tiff v4l xine"

REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

RDEPEND="
	app-arch/bzip2
	sys-libs/zlib
	cuda? ( >=dev-util/nvidia-cuda-toolkit-4 )
	eigen? ( dev-cpp/eigen:2 )
	ffmpeg? ( virtual/ffmpeg )
	gstreamer? (
		media-libs/gstreamer
		media-libs/gst-plugins-base
	)
	gtk? (
		dev-libs/glib:2
		x11-libs/gtk+:2
	)
	jpeg? ( virtual/jpeg )
	jpeg2k? ( media-libs/jasper )
	ieee1394? ( media-libs/libdc1394 sys-libs/libraw1394 )
	openexr? ( media-libs/openexr )
	png? ( media-libs/libpng )
	python? ( ${PYTHON_DEPS} dev-python/numpy[${PYTHON_USEDEP}] )
	qt4? (
		x11-libs/qt-gui:4
		x11-libs/qt-test:4
		opengl? ( x11-libs/qt-opengl:4 )
	)
	tiff? ( media-libs/tiff )
	v4l? ( >=media-libs/libv4l-0.8.3 )
	xine? ( media-libs/xine-lib )
"
DEPEND="${RDEPEND}
	dev-util/pkgconfig
"

# REQUIRED_USE="opengl? ( qt )"

PATCHES=(
	"${FILESDIR}/${PN}-2.3.0-convert_sets_to_options.patch"
	"${FILESDIR}/${PN}-2.3.0-ffmpeg.patch"
	"${FILESDIR}/${PN}-2.3.0-numpy.patch"
	"${FILESDIR}/${PN}-2.3.0-symlink.patch"
	"${FILESDIR}/${PN}-2.3.0-libpng15.patch"
	"${FILESDIR}/${PN}-2.3.0-manual-change-fps.patch"
	"${FILESDIR}/${PN}-2.3.0-clang-error.patch"
	"${FILESDIR}/${PN}-2.3.0-const-operator.patch"
	"${FILESDIR}/${PN}-2.3.0-narrowing.patch"
	"${FILESDIR}/${PN}-2.3.0-atomic.patch"
	"${FILESDIR}/${PN}-2.3.0-local-iota.patch"
)

CMAKE_BUILD_TYPE="Release"

S=${WORKDIR}/${MY_P}

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

src_prepare() {
	default

	# remove bundled stuff
	rm -rf 3rdparty
	sed -i \
		-e '/add_subdirectory(3rdparty)/ d' \
		CMakeLists.txt || die
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_DOCS=OFF #too much dark magic in cmakelists
		-DBUILD_EXAMPLES=$(usex examples)
		-DINSTALL_C_EXAMPLES=$(usex examples)
		-DWITH_NEW_PYTHON_SUPPORT=$(usex python)
		-DENABLE_SSE=OFF					# these options do nothing but
		-DENABLE_SSE2=OFF					# add params to CFLAGS
		-DENABLE_SSE3=OFF
		-DENABLE_SSSE3=OFF
		-DWITH_IPP=OFF
		-DWITH_1394=$(usex ieee1394)
		-DWITH_EIGEN=$(usex eigen)
		-DWITH_FFMPEG=$(usex ffmpeg)
		-DWITH_GSTREAMER=$(usex gstreamer)
		-DWITH_GTK=$(usex gtk)
		-DWITH_JASPER=$(usex jpeg2k)
		-DWITH_JPEG=$(usex jpeg)
		-DWITH_OPENEXR=$(usex openexr)
		-DWITH_PNG=$(usex png)
		-DWITH_QT=$(usex qt4)
		-DWITH_QT_OPENGL=$(usex opengl)
		-DWITH_TIFF=$(usex tiff)
		-DWITH_V4L=$(usex v4l)
		-DWITH_XINE=$(usex xine)
	)

	if use cuda; then
		if [ "$(gcc-version)" > "4.4" ]; then
			ewarn "CUDA and >=sys-devel/gcc-4.5 do not play well together. Disabling CUDA support."
			mycmakeargs+=( "-DWITH_CUDA=OFF" )
		else
			mycmakeargs+=( "-DWITH_CUDA=ON" )
		fi
	else
		mycmakeargs+=( "-DWITH_CUDA=OFF" )
	fi

	if use python && use examples; then
		mycmakeargs+=( "-DINSTALL_PYTHON_EXAMPLES=ON" )
	else
		mycmakeargs+=( "-DINSTALL_PYTHON_EXAMPLES=OFF" )
	fi

	# Chrome OS cross-compilation fix:
	#
	# Setting root folder and search paths for cross-compilation
	# We force the cmake to use binaries (e.g. compilers, interpreters)
	# in the host but use include/library files in the target.
	mycmakeargs+=( "-DCMAKE_FIND_ROOT_PATH=${ROOT}" )
	mycmakeargs+=( "-DCMAKE_FIND_ROOT_PATH_MODE_PROGRAM=NEVER" )
	mycmakeargs+=( "-DCMAKE_FIND_ROOT_PATH_MODE_LIBRARY=ONLY" )
	mycmakeargs+=( "-DCMAKE_FIND_ROOT_PATH_MODE_INCLUDE=ONLY" )
	tc-export PKG_CONFIG
	sed -i '/^find_program/s:NAMES:& $ENV{PKG_CONFIG}:' OpenCVFindPkgConfig.cmake || die
	# Workaround cmake testing the compiler too soon.
	tc-export CC CXX

	# things we want to be hard off or not yet figured out
	# unicap: https://bugs.gentoo.org/show_bug.cgi?id=175881
	# openni: ???
	mycmakeargs+=(
		"-DUSE_OMIT_FRAME_POINTER=OFF"
		"-DOPENCV_BUILD_3RDPARTY_LIBS=OFF"
		"-DOPENCV_WARNINGS_ARE_ERRORS=OFF"
		"-DBUILD_LATEX_DOCS=OFF"
		"-DENABLE_POWERPC=OFF"
		"-DBUILD_PACKAGE=OFF"
		"-DENABLE_PROFILING=OFF"
		"-DUSE_O2=OFF"
		"-DUSE_O3=OFF"
		"-DUSE_FAST_MATH=OFF"
		"-DENABLE_SSE41=OFF"
		"-DENABLE_SSE42=OFF"
		"-DWITH_PVAPI=OFF"
		"-DWITH_UNICAP=OFF"
		"-DWITH_TBB=OFF"
		"-DWITH_OPENNI=OFF"
	)

	# things we want to be hard enabled not worth useflag
	mycmakeargs+=(
		"-DCMAKE_SKIP_RPATH=ON"
		"-DBUILD_SHARED_LIBS=ON"
		"-DOPENCV_DOC_INSTALL_PATH=${EPREFIX}/usr/share/doc/${PF}"
	)

	# hardcode cuda paths
	mycmakeargs+=(
		"-DCUDA_NPP_LIBRARY_ROOT_DIR=/opt/cuda"
	)

	cmake-utils_src_configure
}
