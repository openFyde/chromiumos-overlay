#!/usr/bin/env python3
# Copyright 2022 The ChromiumOS Authors.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.
"""Identifies instances of crates in DEPENDs, and marks them for removal.

"Mark" here means "Puts >>> beside, so ${USER} can easily grep through and fix
up places. Style-preserving DEPEND parsing is a pain to automate. "Slap >>> in
there and have a user fix it up" is less so. ;)

FIXME(b/240953811): Remove this once our migration is done.
"""

import argparse
import collections
import logging
from pathlib import Path
import pprint
import re
import shlex
import subprocess
import sys
from typing import Dict, Iterable, List

import migration_utils


# The depgraph here should be similar to the host, and this is easier to clear
# of stale packages.
_EQUERY = "equery"


def remove_version(atom: str) -> str:
    """Removes version+revision suffix from `atom`."""
    new_atom, replacements = re.subn(
        r"-(:?(:?\d+)\.)*\d+(:?_beta\d*|_p\d*)*(:?-r\d+)?$", "", atom
    )
    assert replacements, atom
    return new_atom


def remove_term_formatting(term_output: str) -> str:
    """Removes terminal formatting from the given string."""
    formatting = re.compile("\x1b[^m]+m")
    return formatting.sub("", term_output)


def list_ebuild_rdeps(crates: List[str]) -> List[List[str]]:
    """Lists reverse dependencies of an ebuild."""
    # Prefer a single invocation to sidestep equery's startup time.
    # We have to parse terminal output here, since the piped output doesn't
    # handle ebuilds with no dependencies well.
    cmd = [_EQUERY, "--no-pipe", "d", "-a"]
    cmd += (f"dev-rust/{x}" for x in crates)
    output = remove_term_formatting(
        subprocess.check_output(cmd, encoding="utf-8")
    )

    sections = output.split("* These packages depend on")
    assert not sections[0].strip(), sections[0]
    del sections[0]
    assert len(sections) == len(crates)

    results = []
    for crate, section in zip(crates, sections):
        name = f"dev-rust/{crate}:"
        section_name, *lines = section.splitlines()
        assert section_name.lstrip() == name, f"{section_name!r}"
        # Each line is either a dependency or miscellaneous info. Miscellaneous
        # info is indented, or happens after some whitespace is printed after
        # the dep. e.g.,
        #
        # * These packages depend on dev-rust/foo:
        # dev-rust/bar-1.2.3-r1  (misc)
        #                        (more misc)
        results.append(
            [x.split()[0] for x in lines if x and not x[0].isspace()]
        )

    return results


def flag_all_instances(text: str, substr: str, flag: str = ">>> ") -> str:
    result = []
    # We don't want to flag all instances of this _directly_. We want to add
    # flags when we encounter whitespace. Otherwise, we get weird things like:
    # `>=>>> dev-rust/foo:=` when `>>> >=dev-rust/foo:=` would be far cleaner.
    pieces = text.split(substr)
    for piece in pieces[:-1]:
        # Sadly, enumerate(...) isn't reverseable.
        for i in reversed(range(len(piece))):
            c = piece[i]
            if c == '"' or c == "'" or c.isspace():
                result.append(piece[: i + 1])
                result.append(flag)
                result.append(piece[i + 1 :])
                break
        else:
            result.append(piece)
            result.append(flag)

        result.append(substr)
    result.append(pieces[-1])
    return "".join(result)


def flag_dependencies(ebuild: Path, flag_deps: List[str]) -> bool:
    """Flags all dependencies in `ebuild`, exiting if it's cros-workon."""
    ebuild_contents = ebuild.read_text(encoding="utf-8")
    if '\nCROS_WORKON_COMMIT="' in ebuild_contents:
        return False

    for dep in flag_deps:
        ebuild_contents = flag_all_instances(ebuild_contents, dep)
    ebuild.write_text(ebuild_contents, encoding="utf-8")
    return True


def remove_rev(x: str) -> str:
    # Remove revisions, since sometimes we'll have stale ones. Just let this
    # pick things for us.
    return migration_utils.parse_crate_from_ebuild_stem(x)[0]


def find_ebuilds(atoms: Iterable[str]) -> Dict[str, Path]:
    """Resolves atoms to ebuilds in one shot."""
    # Do this in a single invocation, since `equery w` has a long startup time.
    equery_atoms = [
        x[:-5] if x.endswith("-9999") else f"~{remove_rev(x)}" for x in atoms
    ]
    equery_result = subprocess.check_output(
        [_EQUERY, "w"] + equery_atoms, encoding="utf-8"
    ).split()
    result = {}
    for atom, ebuild in zip(atoms, equery_result):
        ebuild = Path(ebuild)
        if atom.endswith("-9999"):
            workon_ebuild_stem = remove_version(ebuild.stem) + "-9999"
            ebuild = ebuild.parent / (workon_ebuild_stem + ".ebuild")
            assert ebuild.exists(), ebuild
        result[atom] = ebuild
    return result


def get_parser():
    """Gets the argument parser."""
    parser = argparse.ArgumentParser(
        description=__doc__,
        formatter_class=argparse.RawDescriptionHelpFormatter,
    )
    parser.add_argument("crate", nargs="+", help="crate to remove")
    parser.add_argument(
        "--base-dir",
        default=Path("~/trunk/src").expanduser(),
        help="The final file listing will be made relative "
        "to this directory. Default: %(default)s",
    )
    return parser


def main(argv: List[str]):
    logging.basicConfig(
        format=">> %(asctime)s: %(levelname)s: %(filename)s:%(lineno)d: "
        "%(message)s",
        level=logging.INFO,
    )

    opts = get_parser().parse_args(argv)
    # Map of atom-versions-of-ebuild-to-update => atom-bases-to-flag.
    deps = collections.defaultdict(list)

    crates = opts.crate
    logging.info("Figuring out reverse dependencies (this can take a while)...")
    raw_rdeps = list_ebuild_rdeps(crates)
    logging.info("All rdeps: %s", pprint.pformat(dict(zip(crates, raw_rdeps))))
    for crate, rdeps in zip(crates, raw_rdeps):
        # Sorting in reverse puts workon rdeps before non-workon rdeps.
        rdeps = sorted(rdeps, reverse=True)
        has_9999 = set()
        for rdep in rdeps:
            no_version = remove_version(rdep)
            if rdep.endswith("-9999"):
                has_9999.add(no_version)
            elif no_version in has_9999:
                # len("Ignore") == len("Adding"), which makes verifying these
                # messages way easier.
                logging.info(
                    "Ignore update for %s; it has a workon ebuild", rdep
                )
                continue
            logging.info("Adding update for %s", rdep)
            deps[rdep].append(f"dev-rust/{crate}")

    logging.info("Mapping dependencies to ebuilds...")
    rdep_ebuilds = find_ebuilds(deps)

    logging.info("Editing ebuilds...")
    seen_ebuilds = set()
    edited_ebuilds = []
    for rdep, flag_deps in deps.items():
        ebuild = rdep_ebuilds[rdep]
        ebuild_resolved = ebuild.resolve()
        if ebuild_resolved in seen_ebuilds:
            logging.debug(
                "Skipping updates for %s; they were already applied.",
                ebuild_resolved,
            )
            continue
        seen_ebuilds.add(ebuild_resolved)

        logging.info("Updating %s deps %s...", ebuild, flag_deps)
        # We may flag a cros-workon ebuild above _if_ we've updated the 9999
        # ebuild already, but that change hasn't yet been applied to the stable
        # ebuild. In that case, ignore the ebuild.
        if flag_dependencies(ebuild, flag_deps):
            edited_ebuilds.append(ebuild)
        else:
            logging.info(
                "Skipped %s update; it seems to be cros-workon", ebuild
            )

    # Printed conveniently so the user can do `$EDITOR ${ebuild[@]}`, even
    # outside of the chroot.

    if opts.base_dir:
        base_dir = Path(opts.base_dir).resolve()
        final_listing = (x.relative_to(base_dir) for x in edited_ebuilds)
    else:
        final_listing = edited_ebuilds

    print(
        "Edited all ebuilds. Full listing:",
        " ".join(shlex.quote(str(x)) for x in final_listing),
    )


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
