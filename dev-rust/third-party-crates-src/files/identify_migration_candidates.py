#!/usr/bin/env python3
# Copyright 2022 The ChromiumOS Authors
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.
"""Prints automigration candidates as JSON.

FIXME(b/240953811): Remove this once our migration is done.
"""

import argparse
import collections
import json
import logging
from pathlib import Path
import pprint
import sys
from typing import Dict, Iterable, List

import migration_utils


def get_parser():
    """Constructs our arg parser."""
    parser = argparse.ArgumentParser(
        description=__doc__,
        formatter_class=argparse.RawDescriptionHelpFormatter,
    )
    my_location = Path(__file__).resolve().parent
    dev_rust = my_location.parent.parent
    parser.add_argument("--dev-rust", type=Path, default=dev_rust)
    parser.add_argument(
        "--third-party-crates-ebuild",
        type=Path,
        default=my_location.parent / "third-party-crates-src-9999.ebuild",
    )
    parser.add_argument(
        "--rust-crates-path",
        type=Path,
        default=dev_rust.parent.parent / "rust_crates",
    )
    parser.add_argument(
        "--full-packages-only",
        action="store_true",
        help="If specified, only ebuilds belonging to packages for which "
        "all ebuilds can be migrated are printed.",
    )
    parser.add_argument(
        "--output-file",
        default=Path("/dev/stdout"),
        type=Path,
        help="The listing will be dumped here.",
    )
    return parser


def ebuilds_have_customization(ebuilds: Iterable[str]) -> bool:
    """Returns whether any of the ebuilds in `ebuilds` have customization."""
    return any(
        migration_utils.crate_has_customization(x.read_text(encoding="utf-8"))
        for x in ebuilds
    )


def find_available_rust_crates(rust_crates_path: Path) -> Dict[str, List[str]]:
    """Returns a mapping of crate name -> versions in `rust_crates_path`."""
    result = collections.defaultdict(list)
    for file in (rust_crates_path / "vendor").iterdir():
        if not file.is_dir():
            continue

        # dev-rust has clap-3.0.0_beta2, which shows up in `cargo`'s vendor
        # registry as `clap-3.0.0.beta-2`. Actual version parsing is somewhat
        # complicated, and we only have one instance of this, so handle it in a
        # targeted way.
        crate_name_and_ver = file.name.replace(".beta-", "_beta")
        name, ver = crate_name_and_ver.rsplit("-", 1)
        result[name].append(ver)

    for vers in result.values():
        vers.sort()

    return result


def main(argv: List[str]):
    logging.basicConfig(
        format=">> %(asctime)s: %(levelname)s: %(filename)s:%(lineno)d: "
        "%(message)s",
        level=logging.INFO,
    )

    opts = get_parser().parse_args(argv)
    third_party_crates_ebuild = opts.third_party_crates_ebuild.resolve()
    third_party_crates = third_party_crates_ebuild.parent
    available_rust_crates = find_available_rust_crates(opts.rust_crates_path)

    logging.info("Available crates: %s", available_rust_crates)

    skip_reasons = collections.defaultdict(int)
    dev_rust = opts.dev_rust.resolve()
    candidates = []
    for subdir in dev_rust.iterdir():
        if subdir == third_party_crates or not subdir.is_dir():
            continue

        files = [x for x in subdir.iterdir() if x.suffix == ".ebuild"]
        symlinks_to = set()
        for file in files:
            if file.is_symlink():
                symlinks_to.add(file.resolve())

        if any(x.name.endswith("-9999.ebuild") for x in files):
            logging.info("Skipping %s; it is first-party code.", subdir.name)
            continue

        if subdir.name not in migration_utils.CUSTOMIZATION_IGNORE_CRATES:
            if ebuilds_have_customization(
                x for x in files if not x.is_symlink()
            ):
                logging.info("Skipping %s; it has customization", subdir.name)
                continue

        available_versions = available_rust_crates.get(subdir.name)
        if not available_versions:
            logging.info("Skipping %s; it is not available", subdir.name)
            skip_reasons["unavailable in rust_crates"] += len(files)
            continue

        package_candidates = []
        skipped_any = False
        for ebuild in sorted(files):
            if ebuild in symlinks_to:
                # Assume symlinks from foo.ebuild -> bar.ebuild are all uprevs,
                # so skip updating bar.ebuild.
                logging.info("Skipping %s; it has symlink(s) to it.", ebuild)
                skip_reasons["symlinks"] += 1
                continue

            stem_no_rev, _ = migration_utils.parse_crate_from_ebuild_stem(
                ebuild.stem
            )
            ebuild_ver = stem_no_rev.rsplit("-", 1)[1]

            has_compatible_ver = any(
                migration_utils.is_semver_compatible_upgrade(ebuild_ver, x)
                for x in available_versions
            )
            if not has_compatible_ver:
                logging.info(
                    "Skipping %s; it has no semver-compatible versions",
                    ebuild.stem,
                )
                skip_reasons["no semver-compatible version"] += 1
                skipped_any = True
                continue

            contents = ebuild.read_text(encoding="utf-8")
            if migration_utils.MIGRATED_CRATE_MARKER in contents:
                logging.info("Skipping %s; it is already migrated", ebuild)
                skip_reasons["already migrated"] += 1
                # Don't set skipped_any here: that's used with
                # --full-packages-only, and we don't want an already-migrated
                # package to interfere with that.
                continue

            if not migration_utils.is_leaf_crate(contents):
                logging.info("Skipping %s; it is not a leaf", ebuild)
                skip_reasons["not a leaf"] += 1
                skipped_any = True
                continue

            package_candidates.append(ebuild)

        if skipped_any and opts.full_packages_only:
            continue

        candidates += package_candidates

    logging.info("Skip reasons: %s", pprint.pformat(dict(skip_reasons)))
    candidates.sort()
    with opts.output_file.open("w", encoding="utf-8") as f:
        json.dump(
            # Path()s can't be serialized to json
            [str(x) for x in candidates],
            f,
            indent=2,
            separators=(", ", ": "),
        )


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
