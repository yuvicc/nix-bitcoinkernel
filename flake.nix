{
  description = "Nix packages and development shells for bitcoinkernel and its language bindings";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};

        # Import our packages
        bitcoinkernelPkgs = import ./pkgs { inherit pkgs; };

        # Import our shells
        shells = import ./shells { inherit pkgs; };
      in
      {
        # Expose all packages
        packages = {
          inherit (bitcoinkernelPkgs)
            bitcoinkernel
            bitcoinkernel-jdk
            go-bitcoinkernel
            rust-bitcoinkernel
            py-bitcoinkernel
            bitcoinkernel-dotnet;

          # Default package
          default = bitcoinkernelPkgs.bitcoinkernel;
        };

        # Development shells for each language
        devShells = {
          inherit (shells)
            cpp
            java
            go
            rust
            python
            dotnet;

          # Default shell
          default = shells.default;
        };

        # Expose the package set for overlays
        overlays.default = final: prev: {
          bitcoinkernel = bitcoinkernelPkgs;
        };

        # NixOS module (future enhancement)
        # nixosModules.default = import ./modules;

        # Apps for convenient CLI access
        apps = {
          # Example: nix run .#build-java
          build-java = {
            type = "app";
            program = "${pkgs.writeShellScript "build-java" ''
              echo "Building bitcoinkernel-jdk..."
              nix build .#bitcoinkernel-jdk
            ''}";
          };
        };

        # Formatter for Nix files
        formatter = pkgs.nixpkgs-fmt;

        # Checks for CI/CD
        checks = {
          # We can add build checks here
          # build-bitcoinkernel = bitcoinkernelPkgs.bitcoinkernel;
        };
      }
    ) // {
      # Non-system specific outputs

      # Overlay for use in other flakes
      overlay = final: prev: {
        bitcoinkernel = prev.callPackage ./pkgs { };
      };

      # Templates for new projects
      templates = {
        java = {
          path = ./templates/java;
          description = "Template for Java project using bitcoinkernel-jdk";
        };
        go = {
          path = ./templates/go;
          description = "Template for Go project using go-bitcoinkernel";
        };
        rust = {
          path = ./templates/rust;
          description = "Template for Rust project using rust-bitcoinkernel";
        };
        python = {
          path = ./templates/python;
          description = "Template for Python project using py-bitcoinkernel";
        };
        dotnet = {
          path = ./templates/dotnet;
          description = "Template for .NET project using bitcoinkernel-dotnet";
        };
      };
    };
}
