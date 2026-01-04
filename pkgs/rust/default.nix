{ lib
, rustPlatform
, fetchFromGitHub
, cmake
, boost
, libevent
, pkg-config
, sqlite
, python3
, stdenv
, cargo
, rustc
, bitcoinkernel  # Available for reference but not used (rust-bitcoinkernel builds libbitcoinkernel statically)
}:

stdenv.mkDerivation rec {
  pname = "rust-bitcoinkernel";
  version = "unstable-2026-01-01";

  src = fetchFromGitHub {
    owner = "sedited";
    repo = "rust-bitcoinkernel";
    rev = "12d54753d3d1aad7e7086350a924ef3c60da4caf";
    hash = "sha256-RD3SVrB7wypz2J0EEG7Bbh14ecsXhlg17mFF4utFI+g=";
    fetchSubmodules = true; # Bitcoin Core is included as submodule
  };

  # Cargo dependency vendoring - we'll fetch dependencies during build
  cargoDeps = rustPlatform.importCargoLock {
    lockFile = ./Cargo.lock;
  };

  # Add Cargo.lock to the source since the repository doesn't have one committed
  postUnpack = ''
    cp ${./Cargo.lock} source/Cargo.lock
  '';

  # Disable cmake configure - this is a Rust project built with cargo
  dontUseCmakeConfigure = true;

  nativeBuildInputs = [
    cmake
    pkg-config
    python3
    cargo
    rustc
    rustPlatform.cargoSetupHook
    rustPlatform.bindgenHook
  ];

  buildInputs = [
    boost
    libevent
    sqlite
  ];

  # rust-bitcoinkernel builds libbitcoinkernel statically during the build
  # We need to ensure cmake can find the build dependencies
  preBuild = ''
    export CMAKE_PREFIX_PATH=${boost}/lib/cmake/Boost-${boost.version}
  '';

  buildPhase = ''
    runHook preBuild
    cargo build --release --frozen
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib

    # Copy the built library
    find target/release -name "*.so" -o -name "*.a" -o -name "*.rlib" | while read lib; do
      cp "$lib" $out/lib/
    done

    runHook postInstall
  '';

  meta = with lib; {
    description = "Rust bindings for Bitcoin Core's validation engine via libbitcoinkernel";
    homepage = "https://github.com/sedited/rust-bitcoinkernel";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = [ ];
  };
}
