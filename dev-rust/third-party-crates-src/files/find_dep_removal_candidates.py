#!/usr/bin/env python3
# Copyright 2022 The ChromiumOS Authors.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.
"""Uses heuristics to find all dev-rust crates which may be removed.

FIXME(b/240953811): Remove this once our migration is done.
"""

import logging
from pathlib import Path
import sys
from typing import Iterable

import migration_utils


def find_all_fully_migrated_crates(dev_rust: Path) -> Iterable[str]:
    for subdir in dev_rust.iterdir():
        if not subdir.is_dir():
            continue

        found_ebuild = False
        found_unmigrated_ebuild = False
        found_bad_depends = False
        for file in subdir.iterdir():
            if file.is_symlink() or file.suffix != ".ebuild":
                continue

            found_ebuild = True
            text = file.read_text(encoding="utf-8")
            if migration_utils.MIGRATED_CRATE_MARKER not in text:
                found_unmigrated_ebuild = True
                break

            if 'RDEPEND="${DEPEND}"' not in text:
                found_bad_depends = True
                break

            if 'DEPEND="dev-rust/third-party-crates-src:="' not in text:
                found_bad_depends = True
                break

        if not found_ebuild:
            continue

        if found_unmigrated_ebuild or found_bad_depends:
            continue

        yield subdir.name


def main():
    logging.basicConfig(
        format=">> %(asctime)s: %(levelname)s: %(filename)s:%(lineno)d: "
        "%(message)s",
        level=logging.INFO,
    )

    dev_rust = Path(__file__).resolve().parent.parent.parent
    migrated = sorted(find_all_fully_migrated_crates(dev_rust))
    if migrated:
        print("\n".join(migrated))
    else:
        print("No migration candidates found.")


if __name__ == "__main__":
    sys.exit(main())
