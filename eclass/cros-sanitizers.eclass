# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2.

# @ECLASS: cros-sanitizers.eclass
# @MAINTAINER:
# ChromeOS toolchain team <chromeos-toolchain@google.com>
# @DESCRIPTION:
# Ebuild helper functions for sanitizer builds on Chrome OS.

if [[ -z ${_CROS_SANITIZER_ECLASS} ]]; then
_CROS_SANITIZER_ECLASS=1

inherit flag-o-matic toolchain-funcs

IUSE="coverage msan ubsan"

# @FUNCTION: coverage-setup-env
# @DESCRIPTION:
# Build a package with coverage flags.
coverage-setup-env() {
	use coverage || return 0
	append-flags -fprofile-instr-generate -fcoverage-mapping
	append-ldflags -fprofile-instr-generate -fcoverage-mapping
}

# @FUNCTION: msan-setup-env
# @DESCRIPTION:
# Build a package with memory sanitizer flags.
msan-setup-env() {
	use msan || return 0
	append-flags "-fsanitize=memory"
	append-ldflags "-fsanitize=memory"
}

# @FUNCTION: ubsan-setup-env
# @DESCRIPTION:
# Build a package with undefined behavior sanitizer flags.
ubsan-setup-env() {
	use ubsan || return 0
	# TODO: Find a safe subset of ubsan flags that can be used to build packages.
#	append-flags "-fsanitize=undefined"
#	append-ldflags "-fsanitize=undefined"
}

fi
