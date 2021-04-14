# Copyright (c) 2012 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT=("af20090117df3004845d7f4592fa18d5e8958263" "5a61a46f84e245204991b8a897747644c3549d5f")
CROS_WORKON_TREE=("9976af31dc0b049a3e9a733c7ee093c37869829c" "dcde81930066b3c47b6d08068c7abcc1a115e42d")
CROS_WORKON_PROJECT=(
	"chromiumos/third_party/autotest"
	"chromiumos/platform/fw-testing-configs"
)
CROS_WORKON_LOCALNAME=(
	"third_party/autotest/files"
	"third_party/autotest/files/server/cros/faft/fw-testing-configs"
)
CROS_WORKON_DESTDIR=(
	"${S}"
	"${S}/server/cros/faft/fw-testing-configs"
)

inherit cros-workon cros-constants

DESCRIPTION="Autotest scripts and tools"
HOMEPAGE="https://chromium.googlesource.com/chromiumos/third_party/autotest/"
SRC_URI=""
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="*"

RDEPEND="
	!<chromeos-base/autotest-chrome-0.0.1-r1788
	!<chromeos-base/autotest-tests-0.0.1-r3291
	!<chromeos-base/autotest-deps-0.0.2
	virtual/autotest-libs
	virtual/autotest-assistant-libs
"

# We don't want Python on the base image, however, there're several base
# chromeos dependent ebuilds that depend on this ebuild.
DEPEND="${RDEPEND}"

# Ensure the configures run by autotest pick up the right config.site
export CONFIG_SITE=/usr/share/config.site

AUTOTEST_WORK="${WORKDIR}/autotest-work"

src_prepare() {
	mkdir -p "${AUTOTEST_WORK}/client"
	mkdir -p "${AUTOTEST_WORK}/server"
	cp -fpu "${S}"/client/* "${AUTOTEST_WORK}/client" &>/dev/null
	cp -fpru "${S}"/client/{bin,common_lib,tools} "${AUTOTEST_WORK}/client"
	cp -fpu "${S}"/server/* "${AUTOTEST_WORK}/server" &>/dev/null
	cp -fpru "${S}"/server/{bin,control_segments,hosts,lib} "${AUTOTEST_WORK}/server"
	cp -fpru "${S}"/{tko,utils,site_utils,test_suites,frontend} "${AUTOTEST_WORK}"

	# cros directory is not from autotest upstream but cros project specific.
	cp -fpru "${S}"/client/cros "${AUTOTEST_WORK}/client"

	cp -fpru "${S}"/server/cros "${AUTOTEST_WORK}/server"

	# Pre-create test directories.
	local test_dirs="
		client/tests client/site_tests
		client/config client/deps client/profilers
		server/tests server/site_tests packages"
	local dir
	for dir in ${test_dirs}; do
		mkdir "${AUTOTEST_WORK}/${dir}"
		touch "${AUTOTEST_WORK}/${dir}"/.keep
	done
	touch "${AUTOTEST_WORK}/client/profilers/__init__.py"

	# Symlinks are needed for new setup_modules
	# delete the top level symlink beforehand (if it exists).
	find "${AUTOTEST_WORK}" -name "autotest_lib" -delete \
		|| echo "Top level symlink did not exist!"

	# Create the top level symlink (want autotest_lib --> .)
	ln -s . "${AUTOTEST_WORK}/autotest_lib" \
		|| die "Could not create autotest_lib symlink"

	sed "/^enable_server_prebuild/d" "${S}/global_config.ini" > \
		"${AUTOTEST_WORK}/global_config.ini"
	default
}

src_install() {
	insinto ${AUTOTEST_BASE}
	doins -r "${AUTOTEST_WORK}"/*

	# base __init__.py
	touch "${D}"${AUTOTEST_BASE}/__init__.py

	# TODO: This should be more selective
	chmod -R a+x "${D}"${AUTOTEST_BASE}

	# setup stuff needed for read/write operation
	chmod a+wx "${D}${AUTOTEST_BASE}/packages"

	dodir "${AUTOTEST_BASE}/client/packages"
	chmod a+wx "${D}${AUTOTEST_BASE}/client/packages"

	dodir "${AUTOTEST_BASE}/server/tmp"
	chmod a+wx "${D}${AUTOTEST_BASE}/server/tmp"

	# Set up symlinks so that debug info works for autotests.
	dodir /usr/lib/debug${AUTOTEST_BASE}/
	dosym client/site_tests /usr/lib/debug${AUTOTEST_BASE}/tests

	# Punt any nested .git dirs.
	find "${D}" -name .git -exec rm -rf {} +
}

src_test() {
	# Run the autotest unit tests.
	./utils/unittest_suite.py --debug || die "Autotest unit tests failed."
}

# Packages client.
pkg_postinst() {
	local root_autotest_dir="${ROOT}${AUTOTEST_BASE}"
	flock "${root_autotest_dir}/packages" \
			-c "PYTHONDONTWRITEBYTECODE=1 ${root_autotest_dir}/utils/packager.py \
				-r ${root_autotest_dir}/packages --client -a upload"
}
