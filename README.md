# nix-bitcoinkernel

Nix packages and development shells for bitcoinkernel (libbitcoinkernel) and its language bindings similar to how [nix-bitcoin](https://github.com/fort-nix/nix-bitcoin) does.

## Overview

This repository provides Nix packages for Bitcoin Core's bitcoinkernel/libbitcoinkernel and its various language bindings. Bitcoinkernel is Bitcoin Core's consensus engine extracted as a reusable library, enabling applications to validate blocks and transactions without running a full Bitcoin node.

## Available Packages

### Core Library
- **bitcoinkernel** - Bitcoin Core's validation engine (C/C++ library)

### Language Bindings
- **bitcoinkernel-jdk** - Java/JDK FFM wrapper
- **rust-bitcoinkernel** - Rust bindings
- **go-bitcoinkernel** - Go bindings (*todo!*)
- **py-bitcoinkernel** - Python wrapper (*todo!*)
- **bitcoinkernel-dotnet** - .NET bindings (*todo!*)

### Development Shells

Enter a development environment for your language of choice (*only cpp and java is available right now*):

```bash
# C/C++ development
nix develop .#cpp

# Java development
nix develop .#java

# Go development
nix develop .#go

# Rust development
nix develop .#rust

# Python development
nix develop .#python

# .NET development
nix develop .#dotnet
```

## Status

This project is experimental and tracks the development of libbitcoinkernel and its bindings. Note that:

- libbitcoinkernel has been merged into Bitcoin Core but has no official release yet
- All language bindings are in active development
- C/C++, JDK and Rust packages are working currently.
- Implement Go, Python and Dotnet bindings packages.

## Contributing

Contributions are welcome! Please feel free to submit issues or pull requests.

## License

This repository follows the licensing of the respective projects:
- Bitcoin Core / libbitcoinkernel: MIT
- Individual bindings: See respective repositories

## References/Links

- [Bitcoin Core](https://github.com/bitcoin/bitcoin)
- [bitcoinkernel-jdk](https://github.com/yuvicc/bitcoinkernel-jdk)
- [go-bitcoinkernel](https://github.com/stringintech/go-bitcoinkernel)
- [rust-bitcoinkernel](https://github.com/sedited/rust-bitcoinkernel)
- [py-bitcoinkernel](https://github.com/stickies-v/py-bitcoinkernel)
- [BitcoinKernel.NET](https://github.com/janb84/BitcoinKernel.NET)
- [nix-bitcoin](https://github.com/fort-nix/nix-bitcoin)
