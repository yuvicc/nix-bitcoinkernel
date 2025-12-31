{ lib }:

rec {
  # Common build inputs for all bitcoinkernel packages
  bitcoinkernelBuildInputs = pkgs: with pkgs; [
    cmake
    boost
    libevent
    zeromq
  ];

  # Common cmake flags for building libbitcoinkernel
  bitcoinkernelCMakeFlags = [
    "-DBUILD_KERNEL_LIB=ON"
    "-DBUILD_SHARED_LIBS=ON"
    "-DBUILD_UTIL=OFF"
    "-DBUILD_TX=OFF"
    "-DBUILD_TESTS=OFF"
    "-DBUILD_BENCH=OFF"
  ];

  # Helper to fetch from a git repository
  fetchGitRepo = { owner, repo, rev, sha256 }:
    builtins.fetchGit {
      url = "https://github.com/${owner}/${repo}";
      inherit rev;
      # Note: Nix flakes will use the lock file for pinning
    };

  # Helper to determine the latest Bitcoin Core commit
  # This can be overridden in individual packages
  defaultBitcoinCoreRev = "master";

  # Common meta attributes for bitcoinkernel packages
  mkBitcoinkernelMeta = { description, homepage, license ? lib.licenses.mit }: {
    inherit description homepage license;
    platforms = lib.platforms.unix;
    maintainers = [ ];
  };
}
