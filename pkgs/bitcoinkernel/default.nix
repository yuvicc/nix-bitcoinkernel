{ lib
, stdenv
, fetchFromGitHub
, cmake
, boost
, libevent
, zeromq
, pkg-config
, sqlite
, python3
}:

stdenv.mkDerivation rec {
  pname = "bitcoinkernel";
  version = "unstable-2026-01-01";

  src = fetchFromGitHub {
    owner = "bitcoin";
    repo = "bitcoin";
    # Use a recent commit from master
    rev = "2bff9ebeff87a06ec6b72ec0e324c2e316f7281f";
    sha256 = "Ek2eJThFJmJ0kGICbq6qOAjnUYnQKf1RJWZwwgPaJ6Q=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    python3
  ];

  buildInputs = [
    boost
    libevent
    sqlite
  ];

  cmakeFlags = [
    "-DBUILD_KERNEL_LIB=ON"
    "-DBUILD_SHARED_LIBS=ON"
    "-DBUILD_UTIL=OFF"
    "-DBUILD_TX=OFF"
    "-DBUILD_TESTS=OFF"
    "-DBUILD_BENCH=OFF"
    "-DBUILD_GUI=OFF"
    "-DENABLE_WALLET=OFF"
    "-DENABLE_IPC=OFF"
  ];

  # Let CMake handle most of the installation, then add headers
  postInstall = ''
    # Ensure headers are in the right place
    mkdir -p $out/include/bitcoinkernel

    # Copy kernel headers if not already installed
    if [ -f ../src/kernel/bitcoinkernel.h ]; then
      cp -a ../src/kernel/bitcoinkernel.h $out/include/bitcoinkernel/ || true
    fi
    if [ -f ../src/kernel/bitcoinkernel_wrapper.h ]; then
      cp -a ../src/kernel/bitcoinkernel_wrapper.h $out/include/bitcoinkernel/ || true
    fi

    # Fix broken paths in pkg-config file
    if [ -f $out/lib/pkgconfig/libbitcoinkernel.pc ]; then
      sed -i "s|libdir=\''${prefix}/.*$|libdir=\''${prefix}/lib|" $out/lib/pkgconfig/libbitcoinkernel.pc
      sed -i "s|includedir=\''${prefix}/.*$|includedir=\''${prefix}/include|" $out/lib/pkgconfig/libbitcoinkernel.pc
    fi
  '';

  meta = with lib; {
    description = "Bitcoin Core's consensus engine as a reusable library";
    homepage = "https://github.com/bitcoin/bitcoin";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = [ ];
  };
}
