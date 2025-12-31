{ pkgs ? import <nixpkgs> { } }:

let
  bitcoinkernelPkgs = import ../pkgs { inherit pkgs; };
in
pkgs.mkShell {
  name = "bitcoinkernel-cpp-dev";

  buildInputs = with pkgs; [
    # C++ toolchain
    clang
    llvmPackages.libcxx
    gcc
    gdb
    lldb

    # Build tools
    cmake
    ninja
    gnumake
    pkg-config

    # Bitcoin kernel library and dependencies
    bitcoinkernelPkgs.bitcoinkernel
    boost
    libevent
    sqlite

    # Development tools
    git
    gh
    clang-tools
    ccls
  ];

  shellHook = ''
    echo "Bitcoin Kernel C++ Development Environment"
    echo "=========================================="
    echo "Compiler: $(clang --version | head -n 1)"
    echo "CMake: $(cmake --version | head -n 1)"
    echo ""
    echo "Available packages:"
    echo "  - bitcoinkernel: ${bitcoinkernelPkgs.bitcoinkernel}"
    echo ""
    echo "To compile with libbitcoinkernel:"
    echo "  clang++ -I\$BITCOINKERNEL_INCLUDE_DIR -L\$BITCOINKERNEL_LIB_DIR -lbitcoinkernel your_app.cpp"
    echo ""
    echo "To use with CMake, add to your CMakeLists.txt:"
    echo "  find_package(PkgConfig REQUIRED)"
    echo "  pkg_check_modules(BITCOINKERNEL REQUIRED libbitcoinkernel)"
    echo "  target_link_libraries(your_target \$${BITCOINKERNEL_LIBRARIES})"
  '';

  # Set up environment variables
  BITCOINKERNEL_LIB_DIR = "${bitcoinkernelPkgs.bitcoinkernel}/lib";
  BITCOINKERNEL_INCLUDE_DIR = "${bitcoinkernelPkgs.bitcoinkernel}/include";
  PKG_CONFIG_PATH = "${bitcoinkernelPkgs.bitcoinkernel}/lib/pkgconfig";
}
