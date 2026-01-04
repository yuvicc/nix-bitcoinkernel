{ pkgs ? import <nixpkgs> { } }:

let
  bitcoinkernelPkgs = import ../pkgs { inherit pkgs; };
in
pkgs.mkShell {
  name = "bitcoinkernel-go-dev";

  buildInputs = with pkgs; [
    # Go toolchain
    go
    gopls
    gotools

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
    echo "Bitcoin Kernel Go Development Environment"
    echo "========================================"
    echo "Go Version: $(go version)"
    echo ""
    echo "Available packages:"
    echo "  - bitcoinkernel: ${bitcoinkernelPkgs.bitcoinkernel}"
    echo ""
    echo "To build go-bitcoinkernel:"
    echo "  go build"
    echo ""
    echo "To run tests:"
    echo "  go test ./..."
  '';

  # Set up environment variables
  BITCOINKERNEL_LIB_DIR = "${bitcoinkernelPkgs.bitcoinkernel}/lib";
  BITCOINKERNEL_INCLUDE_DIR = "${bitcoinkernelPkgs.bitcoinkernel}/include";
  PKG_CONFIG_PATH = "${bitcoinkernelPkgs.bitcoinkernel}/lib/pkgconfig";
  CGO_ENABLED = "1";
  LD_LIBRARY_PATH = "${bitcoinkernelPkgs.bitcoinkernel}/lib";
}
