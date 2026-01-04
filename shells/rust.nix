{ pkgs ? import <nixpkgs> { } }:

let
  bitcoinkernelPkgs = import ../pkgs { inherit pkgs; };
in
pkgs.mkShell {
  name = "bitcoinkernel-rust-dev";

  buildInputs = with pkgs; [
    # Rust toolchain
    rustc
    cargo
    rustfmt
    clippy
    rust-analyzer

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
    echo "Bitcoin Kernel Rust Development Environment"
    echo "=========================================="
    echo "Rust Version: $(rustc --version)"
    echo "Cargo Version: $(cargo --version)"
    echo ""
    echo "Available packages:"
    echo "  - bitcoinkernel: ${bitcoinkernelPkgs.bitcoinkernel}"
    echo "  - rust-bitcoinkernel (source): ${bitcoinkernelPkgs.rust-bitcoinkernel}"
    echo ""
    echo "To clone and build rust-bitcoinkernel from source:"
    echo "  git clone https://github.com/sedited/rust-bitcoinkernel"
    echo "  cd rust-bitcoinkernel"
    echo "  cargo build"
    echo ""
    echo "To run tests:"
    echo "  cargo test"
    echo ""
    echo "To run examples:"
    echo "  cargo run --example <example_name>"
  '';

  # Set up environment variables
  BITCOINKERNEL_LIB_DIR = "${bitcoinkernelPkgs.bitcoinkernel}/lib";
  BITCOINKERNEL_INCLUDE_DIR = "${bitcoinkernelPkgs.bitcoinkernel}/include";
  PKG_CONFIG_PATH = "${bitcoinkernelPkgs.bitcoinkernel}/lib/pkgconfig";

  # Ensure Rust can find the library
  LD_LIBRARY_PATH = "${bitcoinkernelPkgs.bitcoinkernel}/lib";
  LIBRARY_PATH = "${bitcoinkernelPkgs.bitcoinkernel}/lib";
}
