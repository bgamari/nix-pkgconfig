#!/usr/bin/env python3

import logging
from subprocess import check_output
from pathlib import Path
from typing import Dict
import json
import re

INTERESTING_RE = re.compile('\/nix\/store\/[-a-zA-Z0-9\.]+/lib/pkgconfig/.*\.pc')
EXCLUDED_ATTRS = {
    "emscripten.out" # Conflicts with zlib
}

def find_pc_files(nix_locate_db: str=None) -> Dict[str, str]:
    args = ['nix-locate', '-r', '--top-level', '.*\.pc$']
    if nix_locate_db is not None:
        args += ['-d', nix_locate_db]

    out = check_output(args)
    pc_files = {}
    for line in out.decode('UTF-8').split('\n'):
        parts = line.split()
        if len(parts) == 0:
            continue
        attr = parts[0]
        pc_file = Path(parts[-1])
        pc_name = pc_file.stem
        if is_interesting_pc_file(attr, pc_file):
            logging.debug(f"In {attr}: {pc_name} ({pc_file})")
            pc_files[pc_name] = attr
        else:
            logging.debug(f'Skipped {pc_name} from {attr}.')

    return pc_files

def is_interesting_pc_file(attr: str, pc_file: Path) -> bool:
    if attr in EXCLUDED_ATTRS:
        return False

    if INTERESTING_RE.match(str(pc_file)) is None:
        return False

    return True


def main() -> None:
    import argparse
    parser = argparse.ArgumentParser()
    parser.add_argument('-o', '--output', type=argparse.FileType('w'), 
                        help="output nix-pkgconfig database file")
    parser.add_argument('-d', '--database', type=str,
                        help="input nix-locate database file")
    parser.add_argument('-v', '--verbose', action='store_true',
                        help="produce debug output")
    args = parser.parse_args()

    if args.verbose:
        logging.basicConfig(level=logging.DEBUG)

    pc_files = find_pc_files(nix_locate_db=args.database)
    print(f"Found {len(pc_files)} pc files.")
    json.dump(pc_files, args.output)

if __name__ == '__main__':
    main()
