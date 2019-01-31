#!/usr/bin/env python3

from subprocess import check_output
from pathlib import Path
from typing import Dict
import json

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
        pc_file = parts[-1]
        pc_name = Path(pc_file).stem
        pc_files[pc_name] = attr

    return pc_files

def main() -> None:
    import argparse
    parser = argparse.ArgumentParser()
    parser.add_argument('-o', '--output', type=argparse.FileType('w'), 
                        help="output nix-pkgconfig database file")
    parser.add_argument('-d', '--database', type=str,
                        help="input nix-locate database file")
    args = parser.parse_args()

    pc_files = find_pc_files(nix_locate_db=args.database)
    print(f"Found {len(pc_files)} pc files.")
    json.dump(pc_files, args.output)

if __name__ == '__main__':
    main()
