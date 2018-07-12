# Copyright 2018 The Chromium OS Authors. All rights reserved.
# Distributed under the terms of the GNU General Public License v2.

# @ECLASS: cros-fuzzer.eclass
# @MAINTAINER:
# ChromeOS toolchain team <chromeos-toolchain@google.com>

# @DESCRIPTION:
# Ebuild helper functions for fuzzing on Chrome OS.

if [[ -z ${_CROS_FUZZER_ECLASS} ]]; then
_CROS_FUZZER_ECLASS=1

inherit flag-o-matic toolchain-funcs

IUSE="fuzzer"

# @FUNCTION: fuzzer-setup-env
# @DESCRIPTION:
# Build a package with fuzzer coverage flags. Safe to use with packages that
# do not build a fuzzer binary e.g. packages that produce shared libraries etc.
fuzzer-setup-env() {
	use fuzzer || return 0
	append-flags "-fsanitize=fuzzer-no-link"
}

# @FUNCTION: fuzzer-setup-binary
# @DESCRIPTION:
# This function must be called only for ebuilds that only produce
# a fuzzer binary.
fuzzer-setup-binary() {
	use fuzzer || return 0
	fuzzer-setup-env
	append-ldflags "-fsanitize=fuzzer"
}

# @FUNCTION: fuzzer_install
# @DESCRIPTION:
# Installs fuzzer targets in one common location for all fuzzing projects.
# @USAGE: <owners file> <fuzzer binary> [--dict dict_file] [--seed_corpus corpus_path] \
#   [--options options_file] [extra files ...]
fuzzer_install() {
	[[ $# -lt 2 ]] && die "usage: ${FUNCNAME} <OWNERS> <program> [options]" \
		"[extra files...]"
	# Don't do anything without USE="fuzzer"
	! use fuzzer && return 0

	local owners=$1
	local prog=$2
	local name="${prog##*/}"
	shift 2

	# Fuzzer option strings.
	local opt_corpus="seed_corpus"
	local opt_dict="dict"
	local opt_option="options"

	(
		# Install fuzzer program.
		exeinto "/usr/libexec/fuzzers"
		doexe "${prog}"
		# Install owners file.
		insinto "/usr/libexec/fuzzers"
		newins "${owners}" "${name}.owners"

		# Install other fuzzer files (dict, seed corpus etc.) if provided.
		[[ $# -eq 0 ]] && return 0
		# Parse the arguments.
		local opts=$(getopt -o '' -l "${opt_corpus}:,${opt_dict}:,${opt_option}:" -- "$@")
		[[ $? -ne 0 ]] && die "fuzzer_install: Incorrect options: $*"
		eval set -- "${opts}"

		while [[ $# -gt 0 ]]; do
		case "$1" in
			"--${opt_corpus}")
				if [[ -f "$2" ]]; then
					# Do a direct install if seed corpus is a file.
					[[ "$2" != *.zip ]] && die "Not a zip file: $2"
					newins "$2" "${name}_seed_corpus.zip"
				elif [[ -d "$2" ]]; then
					# Zip and install the seed corpus directory.
					pushd "$2" >/dev/null || die
					zip -rj - . | newins - "${name}_seed_corpus.zip"
					popd >/dev/null || die
				else
					die "Invalid seed corpus location $2"
				fi
				shift 2 ;;
			"--${opt_dict}")
				newins "$2" "${name}.dict"
				shift 2 ;;
			"--${opt_option}")
				newins "$2" "${name}.options"
				shift 2 ;;
			--)
				shift ;;
			*)
				doins "$1"
				shift ;;
			esac
		done
	)
}

# @FUNCTION: fuzzer_test
# @DESCRIPTION:
# Runs a fuzzer with a single run and a given seed corpus file or directory.
# @USAGE: <fuzzer binary> <corpus_path>
fuzzer_test() {
	[[ $# -lt 2 ]] && die "usage: ${FUNCNAME} <program> <corpus_path>"

	# Don't do anything without USE="fuzzer"
	! use fuzzer && return 0

	local prog=$1
	local corpus_loc;

	if [[ -f "$2" ]]; then
		[[ "$2" != *.zip ]] && die "Not a zip file: $2"
		# Extract the seed corpus in a temporary location.
		corpus_loc="${T}"/seed_corpus
		unzip "$2" -d "${corpus_loc}"
	elif [[ -d "$2" ]]; then
		corpus_loc="$2"
	else
		die "Invalid seed corpus location $2"
	fi
	"$1" -runs=0 "${corpus_loc}" || die
}

fi
