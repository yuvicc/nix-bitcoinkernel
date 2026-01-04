{ lib, stdenv, bitcoinkernel }:

# Placeholder for bitcoinkernel-dotnet package
# TODO: Implement when ready
stdenv.mkDerivation {
  pname = "bitcoinkernel-dotnet";
  version = "unstable";

  src = builtins.throw "bitcoinkernel-dotnet package is not yet implemented";

  meta = with lib; {
    description = ".NET bindings for Bitcoin Core's validation engine (not yet implemented)";
    license = licenses.mit;
    platforms = platforms.unix;
  };
}
