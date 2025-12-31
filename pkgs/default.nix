{ pkgs ? import <nixpkgs> { } }:

let
  lib = import ./lib.nix { inherit (pkgs) lib; };

  # Base library that all bindings depend on
  bitcoinkernel = pkgs.callPackage ./bitcoinkernel { };

  # Language bindings
  bitcoinkernel-jdk = pkgs.callPackage ./java {
    inherit bitcoinkernel;
  };

  go-bitcoinkernel = pkgs.callPackage ./go {
    inherit bitcoinkernel;
  };

  rust-bitcoinkernel = pkgs.callPackage ./rust {
    inherit bitcoinkernel;
  };

  py-bitcoinkernel = pkgs.python3Packages.callPackage ./python {
    inherit bitcoinkernel;
  };

  bitcoinkernel-dotnet = pkgs.callPackage ./dotnet {
    inherit bitcoinkernel;
  };

in
{
  # Export all packages
  inherit
    bitcoinkernel
    bitcoinkernel-jdk
    go-bitcoinkernel
    rust-bitcoinkernel
    py-bitcoinkernel
    bitcoinkernel-dotnet
    lib;
}
