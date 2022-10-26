# Copyright 2022 The ChromiumOS Authors
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.
"""Utilities used across our automigration scripts.

FIXME(b/240953811): Remove this once our migration is done.
"""

import re
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
    "cortex-m-rt",
    "riscv",
    # The patch for 0.3.11 is obsolete, and 0.3.11 can probably be deleted
    # entirely.
    "pkg-config",
    # These just delete useless deps/features.
    "chrono",
    "console",
    "instant",
    "once_cell",
    "rand",
    "syn",
    # This has a patch which has been migrated.
    "ahash",
    "bayer",
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


def _read_quoted_shell_contents(
    contents: str, quote_start: int
) -> Optional[str]:
    """Returns the contents of the quoted data starting at quote_start.

    If this isn't possible, returns None.
    """
    quote_type = contents[quote_start]
    if quote_type not in "\"'":
        return None

    end_quote = contents.find(quote_type, quote_start + 1)
    if end_quote == -1:
        # Broken syntax probably?
        return False

    quoted_contents = contents[quote_start + 1 : end_quote]
    # As a last resort, ensure that no funny business was happening with
    # what we think is the end quote. All of these are lossy heuristics since
    # we're not actually parsing the file. Should work in most cases; ebuilds
    # are often written without many tricks.
    if contents[end_quote - 1] == "\\":
        return None

    # ...And be sure there's nothing tricky after the last quote.
    i = contents.find("\n", end_quote)
    if i == -1:
        i = len(contents)

    end_of_line = contents[end_quote + 1 : i].split("#")[0]
    if end_of_line.strip():
        return None

    return quoted_contents


def _make_unconditional_depend(depend: str) -> str:
    """Turns `DEPEND="foo? ( bar ) baz"` into `"bar baz"`."""
    conditional_re = re.compile(r'\S+\?\s+\(([^)]*)\)', re.MULTILINE)
    return conditional_re.sub(lambda x: x.group(1).strip(), depend)


def is_leaf_crate(ebuild_contents: str) -> bool:
    """Returns True if the ebuild_contents DEPEND on nothing.

    For our purposes, `dev-rust/third-party-crates-src` counts as "nothing".
    """
    if "\nBDEPEND=" in ebuild_contents:
        # This is weird. Ignore it.
        return False

    rdepend_prefix = "\nRDEPEND="
    rdepend_index = ebuild_contents.find(rdepend_prefix)
    if rdepend_index != -1:
        rdepend = _read_quoted_shell_contents(
            ebuild_contents, rdepend_index + len(rdepend_prefix)
        )
        if rdepend is None:
            return False

        rdepend = _make_unconditional_depend(rdepend)
        for piece in rdepend.strip().split():
            # Ignore blockers and DEPEND
            is_safe = piece.startswith("!") or piece in ("${DEPEND}", "$DEPEND")
            if not is_safe:
                return False

    depend_prefix = "\nDEPEND="
    i = ebuild_contents.find(depend_prefix)
    if i == -1:
        return True

    depend = _read_quoted_shell_contents(
        ebuild_contents, i + len(depend_prefix)
    )
    if depend is None:
        return False

    depend = _make_unconditional_depend(depend)
    # Some ebuilds might list this multiple times. Handle that.
    depend_pieces = depend.strip().split()
    return all(x == "dev-rust/third-party-crates-src:=" for x in depend_pieces)


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
