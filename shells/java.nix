{ pkgs ? import <nixpkgs> { } }:

let
  bitcoinkernelPkgs = import ../pkgs { inherit pkgs; };
in
pkgs.mkShell {
  name = "bitcoinkernel-java-dev";

  buildInputs = with pkgs; [
    jdk
    gradle
    maven

    # Build tools
    cmake
    boost
    pkg-config

    # Bitcoin kernel library
    bitcoinkernelPkgs.bitcoinkernel

    # Development tools
    git
    gh
  ];

  shellHook = ''
    echo "Bitcoin Kernel Java Development Environment"
    echo "==========================================="
    echo "JDK Version: $(java -version 2>&1 | head -n 1)"
    echo "Gradle Version: $(gradle --version | grep Gradle)"
    echo ""
    echo "Available packages:"
    echo "  - bitcoinkernel: ${bitcoinkernelPkgs.bitcoinkernel}"
    echo ""
    echo "To build bitcoinkernel-jdk:"
    echo "  ./gradlew build"
    echo ""
    echo "To run examples:"
    echo "  ./gradlew run"
  '';

  # Set up environment variables
  BITCOINKERNEL_LIB_DIR = "${bitcoinkernelPkgs.bitcoinkernel}/lib";
  BITCOINKERNEL_INCLUDE_DIR = "${bitcoinkernelPkgs.bitcoinkernel}/include";
  JAVA_HOME = "${pkgs.jdk}";
}
