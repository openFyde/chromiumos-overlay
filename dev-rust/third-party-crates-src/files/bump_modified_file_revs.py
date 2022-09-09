#!/usr/bin/env python3
# Copyright 2022 The ChromiumOS Authors
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.
"""Adds r+1 for all modified ebuilds not staged for commit in git.

FIXME(b/240953811): Remove this once our migration is done.
"""

import argparse
import logging
import os
from pathlib import Path
import subprocess
import sys
from typing import Iterable, List

import migration_utils


def determine_modified_files() -> Iterable[Path]:
    # The docstring is very specific, and git status is stable enough for the
    # short time this script will remain alive.
    lines = subprocess.check_output(
        ["git", "status"], encoding="utf-8"
    ).splitlines()

    for line in lines:
        if (
            line
            and line[0].isspace()
            and line.lstrip().startswith("modified: ")
        ):
            yield Path(line.strip().split()[-1])


def main(argv: List[str]):
    logging.basicConfig(
        format=">> %(asctime)s: %(levelname)s: %(filename)s:%(lineno)d: "
        "%(message)s",
        level=logging.INFO,
    )

    parser = argparse.ArgumentParser(
        description=__doc__,
        formatter_class=argparse.RawDescriptionHelpFormatter,
    )
    parser.add_argument("--dry-run", action="store_true")
    parser.add_argument("-C", "--git-dir", type=Path, default=Path("."))
    opts = parser.parse_args(argv)

    os.chdir(opts.git_dir)
    dry_run = opts.dry_run
    renamed_anything = False
    for file in determine_modified_files():
        if file.suffix != ".ebuild" or file.is_symlink():
            continue

        if file.name.endswith("-9999.ebuild"):
            continue

        crate_ver, _ = migration_utils.parse_crate_from_ebuild_stem(file.stem)
        # Assume a symlink is the file we want to bump if one exists && points
        # to x.name.
        symlinks = [
            x
            for x in file.parent.iterdir()
            if x.name.startswith(crate_ver) and x.is_symlink()
        ]
        assert len(symlinks) <= 1, file
        if symlinks:
            rename_file = symlinks[0]
            assert rename_file.resolve() == file.resolve(), rename_file
        else:
            rename_file = file

        rename_ver, rename_rev = migration_utils.parse_crate_from_ebuild_stem(
            rename_file.stem
        )
        if rename_rev:
            new_rev = int(rename_rev[1:]) + 1
        else:
            new_rev = 1
        rename_to = rename_file.parent / f"{rename_ver}-r{new_rev}.ebuild"
        logging.info("Renaming %s => %s", rename_file, rename_to)
        renamed_anything = True
        if not dry_run:
            rename_file.rename(rename_to)

    if renamed_anything:
        if dry_run:
            logging.info("NOTE: Dry-run specified; renames actually skipped")
    else:
        logging.warning("NOTE: No renames found to apply")


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
