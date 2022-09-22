# Copyright 2022 The ChromiumOS Authors
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.
"""Utilities used across our automigration scripts.

FIXME(b/240953811): Remove this once our migration is done.
"""

from typing import Optional, Tuple


# bindgen, protobuf-codegen, dbus-codegen all generate code

# Crates to ignore customization in. These are be vetted to ensure that any
# patches/special `src_*` actions are nops.
CUSTOMIZATION_IGNORE_CRATES = {
    # These simply set CROS_RUST_REMOVE_DEV_DEPS=0 if `use test`.
    "clap",
    "itertools",
    "ron",
    "multimap",
    # These just request that prebuilt `.a` files aren't stripped.
    "cortex-m",
    "riscv",
    # The patch for 0.3.11 is obsolete, and 0.3.11 can probably be deleted
    # entirely.
    "pkg-config",
    # This just uses sed to delete useless deps.
    "syn",
}

# Line written into ebuilds which are automigrated.
MIGRATED_CRATE_MARKER = (
    "# Migrated crate. See b/240953811 for more about this migration."
)


def crate_has_customization(ebuild_contents: str) -> bool:
    """Returns whether the crate has customization that we should skip."""
    # CROS_RUST_REMOVE_DEV_DEPS and CROS_RUST_REMOVE_TARGET_CFG are not
    # considered customization, since they're nops as far as rust_crates is
    # concerned.
    for line in ebuild_contents.splitlines():
        if line.startswith("PATCHES="):
            return True
        if line.startswith("src_") or line.startswith("pkg_") and "()" in line:
            return True
    return False


def parse_crate_from_ebuild_stem(ebuild_stem: str) -> Tuple[str, Optional[str]]:
    """Parses the crate's `{name}-{version}` from an ebuild's stem.

    Returns a tuple of
        - `{name}-{version}`
        - An optional revision string.

    Examples:
        >>> parse_crate_from_ebuild_name('foo-1.2.3-r1')
        ('foo-1.2.3', 'r1')
        >>> parse_crate_from_ebuild_name('foo-1.2.3')
        ('foo-1.2.3', None)
    """
    if ebuild_stem.endswith(".ebuild"):
        raise ValueError("I require ebuild stems, not names")

    maybe_crate_and_ver, maybe_rev = ebuild_stem.rsplit("-", 1)
    if maybe_rev.startswith("r"):
        return maybe_crate_and_ver, maybe_rev
    return ebuild_stem, None


def is_leaf_crate(ebuild_contents: str) -> bool:
    """Returns True if the ebuild_contents DEPEND on nothing.

    For our purposes, `dev-rust/third-party-crates-src` counts as "nothing".
    """
    if "\nBDEPEND=" in ebuild_contents:
        # This is weird. Ignore it.
        return False

    if '\nRDEPEND="${DEPEND}"' not in ebuild_contents:
        if "\nRDEPEND=" in ebuild_contents:
            # This is also weird. Ignore it.
            return False

    depend_prefix = "\nDEPEND="
    i = ebuild_contents.find(depend_prefix)
    if i == -1:
        return True

    depend_quote_start = i + len(depend_prefix)
    quote_type = ebuild_contents[depend_quote_start]
    if quote_type not in "\"'":
        return False

    end_quote = ebuild_contents.find(quote_type, depend_quote_start + 1)
    if end_quote == -1:
        # Broken syntax probably?
        return False

    depend_contents = ebuild_contents[
        depend_quote_start + 1 : end_quote
    ].strip()
    if depend_contents not in ("", "dev-rust/third-party-crates-src:="):
        return False

    # As a last resort, ensure that no funny business was happening with
    # what we think is the end quote. All of these are lossy heuristics since
    # we're not actually parsing the file. Should work in most cases; ebuilds
    # are often written without many tricks.
    if ebuild_contents[end_quote - 1] == "\\":
        return False

    i = ebuild_contents.find("\n", end_quote)
    if i == -1:
        i = len(ebuild_contents)
    line_after_end = ebuild_contents[end_quote+1:i]
    # The only thing after the line should be whitespace.
    before_comment = line_after_end.split("#", 1)[0].strip()
    return not before_comment


def is_semver_compatible_upgrade(old: str, new: str) -> bool:
    """Returns true if `new` is semver compatible with `old`."""
    if old == new:
        return True

    def ver_split(ver: str) -> Tuple[str, str]:
        """Splits beta/etc off of `ver`."""
        x = ver.split("_", 1)
        if len(x) == 2:
            return tuple(x)
        return x[0], ""

    old_ver, old_suffix = ver_split(old)
    new_ver, new_suffix = ver_split(new)
    new_maj, new_min, new_patch = (int(x) for x in new_ver.split("."))
    old_maj, old_min, old_patch = (int(x) for x in old_ver.split("."))

    # Major versions are incompatible.
    if new_maj != old_maj:
        return False

    if new_maj == 0:
        # As are minor versions, if major == 0.
        if new_min != old_min:
            return False

    # The versions are compatible in _some_ direction.
    if old_min > new_min:
        return False

    if new_min > old_min:
        return True

    if old_patch > new_patch:
        return False

    if new_patch > old_patch:
        return True

    if new_suffix and not old_suffix:
        return False

    if old_suffix and not new_suffix:
        return True

    return new_suffix >= old_suffix
