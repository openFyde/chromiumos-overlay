# Copyright 2012 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CROS_WORKON_COMMIT=("7f8dd34776a8ec45d4785107584cc2067c009756" "954dc3e2813e17ba54150e2b8eebfb586cda1d67" "e408cdfac39ca38a9e44b77b07214db987c94e0b")
CROS_WORKON_TREE=("80b80c8e308dc122efb2faaba00975694a2fbf28" "484d9363d6de8ec190a8f6d6d8e6580a6cb03532" "4aa34d98c7e124392e3f3c547aab1042ec9862a3")
PYTHON_COMPAT=( python3_{6..9} )

CROS_WORKON_PROJECT=(
	"chromiumos/third_party/autotest"
	"chromiumos/config"
	"chromiumos/platform/fw-testing-configs"
)

CROS_WORKON_LOCALNAME=(
	"third_party/autotest/files"
	"config"
	"third_party/autotest/files/server/cros/faft/fw-testing-configs"
)

CROS_WORKON_SUBTREE=(
	""
	"python"
	""
)

CROS_WORKON_DESTDIR=(
	"${S}"
	"${S}/config"
	"${S}/server/cros/faft/fw-testing-configs"
)

inherit cros-workon cros-constants python-any-r1

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
	python3 ${S}/utils/generate_metadata.py -autotest_path=${S} -output_file="${D}"${AUTOTEST_BASE}/autotest_metadata.pb

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
	python3 ./utils/unittest_suite.py --debug --py_version=3 || die "Autotest unit tests failed in Python 3."

}

# Packages client.
pkg_postinst() {
	local root_autotest_dir="${ROOT}${AUTOTEST_BASE}"
	flock "${root_autotest_dir}/packages" \
			-c "PYTHONDONTWRITEBYTECODE=1 ${root_autotest_dir}/utils/packager.py \
				-r ${root_autotest_dir}/packages --client -a upload"
}
