# Copyright 2022 The ChromiumOS Authors
# Distributed under the terms of the GNU General Public License v2

if [[ -z ${_ECLASS_CROS_RUSTC_DIRECTORIES} ]]; then
_ECLASS_CROS_RUSTC_DIRECTORIES="1"

# Locations where we cache our build/src dirs.
CROS_RUSTC_DIR="${SYSROOT}/var/cache/portage/${CATEGORY}/rust-artifacts"
CROS_RUSTC_BUILD_DIR="${CROS_RUSTC_DIR}/build"
CROS_RUSTC_SRC_DIR="${CROS_RUSTC_DIR}/src"
CROS_RUSTC_LLVM_SRC_DIR="${CROS_RUSTC_DIR}/llvm-project"

fi
