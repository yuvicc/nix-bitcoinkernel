{ pkgs ? import <nixpkgs> { } }:

let
  bitcoinkernelPkgs = import ../pkgs { inherit pkgs; };
in
pkgs.mkShell {
  name = "bitcoinkernel-python-dev";

  buildInputs = with pkgs; [
    # Python toolchain
    python3
    python3Packages.pip
    python3Packages.setuptools
    python3Packages.wheel
    python3Packages.cffi

    # Build tools
    cmake
    pkg-config

    # Bitcoin kernel library and dependencies
    bitcoinkernelPkgs.bitcoinkernel
    boost
    libevent
    sqlite

    # Development tools
    git
    gh
  ];

  shellHook = ''
    echo "Bitcoin Kernel Python Development Environment"
    echo "============================================"
    echo "Python Version: $(python3 --version)"
    echo ""
    echo "Available packages:"
    echo "  - bitcoinkernel: ${bitcoinkernelPkgs.bitcoinkernel}"
    echo ""
    echo "To build py-bitcoinkernel:"
    echo "  pip install -e ."
    echo ""
    echo "To run tests:"
    echo "  python -m pytest"
  '';

  # Set up environment variables
  BITCOINKERNEL_LIB_DIR = "${bitcoinkernelPkgs.bitcoinkernel}/lib";
  BITCOINKERNEL_INCLUDE_DIR = "${bitcoinkernelPkgs.bitcoinkernel}/include";
  PKG_CONFIG_PATH = "${bitcoinkernelPkgs.bitcoinkernel}/lib/pkgconfig";
  LD_LIBRARY_PATH = "${bitcoinkernelPkgs.bitcoinkernel}/lib";
}
