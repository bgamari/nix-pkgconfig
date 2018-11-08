#!/usr/bin/env python3

import subprocess
import json

def main():
    subprocess.check_call(['nix', 'run', 'nixpkgs.nix-index', '-c', 'nix-index'])
    out = subprocess.check_output(['nix', 'run', 'nixpkgs.nix-index', '-c', 'nix-locate', '-1', '*.pc'])
    # TODO

if __name__ == '__main__':
    main()
