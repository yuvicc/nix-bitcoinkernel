{ lib, stdenv, bitcoinkernel }:

# Placeholder for py-bitcoinkernel package
# TODO: Implement when ready
stdenv.mkDerivation {
  pname = "py-bitcoinkernel";
  version = "unstable";

  src = builtins.throw "py-bitcoinkernel package is not yet implemented";

  meta = with lib; {
    description = "Python bindings for Bitcoin Core's validation engine (not yet implemented)";
    license = licenses.mit;
    platforms = platforms.unix;
  };
}
