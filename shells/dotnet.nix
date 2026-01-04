{ pkgs ? import <nixpkgs> { } }:

let
  bitcoinkernelPkgs = import ../pkgs { inherit pkgs; };
in
pkgs.mkShell {
  name = "bitcoinkernel-dotnet-dev";

  buildInputs = with pkgs; [
    # .NET toolchain
    dotnetCorePackages.sdk_9_0

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
    echo "Bitcoin Kernel .NET Development Environment"
    echo "=========================================="
    echo ".NET Version: $(dotnet --version)"
    echo ""
    echo "Available packages:"
    echo "  - bitcoinkernel: ${bitcoinkernelPkgs.bitcoinkernel}"
    echo ""
    echo "To build bitcoinkernel-dotnet:"
    echo "  dotnet build"
    echo ""
    echo "To run tests:"
    echo "  dotnet test"
  '';

  # Set up environment variables
  BITCOINKERNEL_LIB_DIR = "${bitcoinkernelPkgs.bitcoinkernel}/lib";
  BITCOINKERNEL_INCLUDE_DIR = "${bitcoinkernelPkgs.bitcoinkernel}/include";
  PKG_CONFIG_PATH = "${bitcoinkernelPkgs.bitcoinkernel}/lib/pkgconfig";
  LD_LIBRARY_PATH = "${bitcoinkernelPkgs.bitcoinkernel}/lib";
  DOTNET_ROOT = "${pkgs.dotnetCorePackages.sdk_9_0}";
}
