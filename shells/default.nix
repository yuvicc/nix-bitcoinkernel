{ pkgs ? import <nixpkgs> { } }:

{
  # Individual development shells for each language
  cpp = import ./cpp.nix { inherit pkgs; };
  java = import ./java.nix { inherit pkgs; };
  go = import ./go.nix { inherit pkgs; };
  rust = import ./rust.nix { inherit pkgs; };
  python = import ./python.nix { inherit pkgs; };
  dotnet = import ./dotnet.nix { inherit pkgs; };

  # Default shell with all tools
  default = pkgs.mkShell {
    name = "bitcoinkernel-dev";

    buildInputs = with pkgs; [
      # All language toolchains
      jdk
      go
      rustc
      cargo
      python3
      dotnetCorePackages.sdk_9_0

      # Build tools
      cmake
      boost
      pkg-config

      # Development tools
      git
      gh
    ];

    shellHook = ''
      echo "Bitcoin Kernel Multi-Language Development Environment"
      echo "====================================================="
      echo ""
      echo "Available development shells:"
      echo "  nix develop .#cpp    - C++ development"
      echo "  nix develop .#java   - Java development (JDK 25+)"
      echo "  nix develop .#go     - Go development with CGO"
      echo "  nix develop .#rust   - Rust development"
      echo "  nix develop .#python - Python development"
      echo "  nix develop .#dotnet - .NET development (9.0+)"
      echo ""
      echo "This default shell includes all language toolchains."
    '';
  };
}
