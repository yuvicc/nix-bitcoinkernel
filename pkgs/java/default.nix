{ lib
, stdenv
, fetchFromGitHub
, jdk
, gradle
, bitcoinkernel
, cmake
, boost
, makeWrapper
}:

stdenv.mkDerivation rec {
  pname = "bitcoinkernel-jdk";
  version = "unstable-2026-01-01";

  src = fetchFromGitHub {
    owner = "yuvicc";
    repo = "bitcoinkernel-jdk";
    rev = "6e0e74716ddb0402e7d1a07cc6f06f0c9a33c8b1";
    sha256 = "lnh4hDZC6/VzpYug+zbe9ekD0P05mvtL008rZTMwW3U=";
    fetchSubmodules = true; # Bitcoin Core is included as submodule
  };

  nativeBuildInputs = [
    jdk
    gradle
    cmake
    makeWrapper
  ];

  buildInputs = [
    boost
  ];

  dontUseCmakeConfigure = true;

  mangle_dylib = false;

  gradleFlags = [
    "--no-daemon"
    "--info"
  ];

  configurePhase = ''
    runHook preConfigure

    # Set up Gradle home
    export GRADLE_USER_HOME=$TMPDIR/gradle
    mkdir -p $GRADLE_USER_HOME

    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild

    # Build using gradle wrapper
    ./gradlew build ${toString gradleFlags}

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib
    mkdir -p $out/share/java

    cp -r build/libs/*.jar $out/lib/

    runHook postInstall
  '';

  meta = with lib; {
    description = "Java/JDK FFM wrapper for Bitcoin Core's validation engine via libbitcoinkernel";
    homepage = "https://github.com/yuvicc/bitcoinkernel-jdk";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = [ ];
  };
}
