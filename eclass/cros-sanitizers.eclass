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

IUSE="asan coverage fuzzer msan ubsan"

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
	local flags=(
		-fsanitize=alignment,array-bounds,shift,vla-bound
		-fno-sanitize=vptr
		-fno-sanitize-recover=all
	)
	append-flags "${flags[@]}"
	append-ldflags "${flags[@]}"
}

# @FUNCTION: sanitizers-setup-env
# @DESCRIPTION:
# Build a package with required sanitizer flags.
sanitizers-setup-env() {
	asan-setup-env
	coverage-setup-env
	if [[ $(type -t fuzzer-setup-env) == "function" ]] ; then
		# Only run this if we've inherited cros-fuzzer.eclass.
		fuzzer-setup-env
	fi
	msan-setup-env
	ubsan-setup-env
}

# @FUNCTION: use_sanitizers
# @DESCRIPTION:
# Checks whether sanitizers are being used.
# Also returns a true/false value when passed as arguments.
# Usage: use_sanitizers [trueVal] [falseVal]
use_sanitizers() {
	if use asan || use coverage || use fuzzer || use msan || use ubsan; then
		[[ "$#" -eq 2 ]] && echo "$1"
		return 0
	fi

	[[ "$#" -eq 2 ]] && echo "$2"
	return 1
}

fi
