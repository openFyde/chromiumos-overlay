#!/usr/bin/env python3
# Copyright 2022 The ChromiumOS Authors
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.
"""Autoremoves packages that conflict with third-party-crates-src.

FIXME(b/240953811): Remove this once our migration is done.
"""

import argparse
import logging
from pathlib import Path
import subprocess
import sys
from typing import List


def get_parser():
    """Gets an argument parser."""
    parser = argparse.ArgumentParser(
        description=__doc__,
        formatter_class=argparse.RawDescriptionHelpFormatter,
    )
    parser.add_argument(
        "--log-file",
        type=Path,
        help="If specified, search this build log of third-party-crates-src "
        "for colliding packages. Otherwise, build third-party-crates-src "
        "automatically and look for issues.",
    )
    return parser


def find_colliding_packages(stdstreams: str):
    i = stdstreams.find("Searching all installed packages for file collisions")
    if i == -1:
        return []

    e = stdstreams.find("When moving files between packages")
    if e == -1:
        return []

    lines_with_packages = [
        x
        for x in stdstreams[i:e].splitlines()
        if x.startswith(" * dev-rust/") and "::" in x
    ]

    colliding_packages = []
    for line in lines_with_packages:
        line = line[len(" * ") :]
        package = line.split(":", 1)[0]
        colliding_packages.append(f"={package}")
    return colliding_packages


def try_build_third_party_crates_src():
    logging.info("Trying to emerge third-party-crates-src...")
    result = subprocess.run(
        ["sudo", "emerge", "dev-rust/third-party-crates-src"],
        check=False,
        encoding="utf-8",
        stdin=subprocess.DEVNULL,
        stdout=subprocess.PIPE,
        stderr=subprocess.STDOUT,
    )
    ok = not result.returncode
    stdstreams = result.stdout
    return ok, stdstreams


def main(argv: List[str]):
    """Main function."""
    logging.basicConfig(
        format=">> %(asctime)s: %(levelname)s: %(filename)s:%(lineno)d: "
        "%(message)s",
        level=logging.INFO,
    )
    opts = get_parser().parse_args(argv)

    if opts.log_file:
        stdstreams = opts.log_file.read_text(encoding="utf-8")
    else:
        ok, stdstreams = try_build_third_party_crates_src()
        if ok:
            logging.info(
                "`emerge third-party-crates-src` seems to have worked; quit."
            )
            return 0

    colliding = find_colliding_packages(stdstreams)
    if not colliding:
        logging.info("No colliding packages found. :(")
        return 0

    logging.info("Found colliding package atoms: %s. Removing...", colliding)
    subprocess.run(
        ["sudo", "emerge", "-C"] + colliding,
        check=True,
    )

    logging.info("OK! Trying to emerge third-party-crates-src again...")
    result = subprocess.run(
        ["sudo", "emerge", "dev-rust/third-party-crates-src"],
        check=False,
    )
    if not result.returncode:
        logging.info("Looks good :)")
        return 0

    logging.error("Failed to emerge it somehow. Giving up.")
    return 1


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
