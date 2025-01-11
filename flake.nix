{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs =
    { self, nixpkgs }:
    {
      devShells.x86_64-linux.default =
        let
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
        in
        pkgs.mkShell {
          env = {
            ARCH = "arm64";
            CROSS_COMPILE = "aarch64-unknown-linux-gnu-";
            LLVM = "1";
            PKG_CONFIG_PATH = "${pkgs.ncurses.dev}/lib/pkgconfig";
            # KCFLAGS = "-I${pkgs.llvmPackages.clang}/resource-root/include -Wno-everything -march=armv8-a+crypto -Wno-error=unused-command-line-argument";
          };
          packages = builtins.attrValues {
            inherit (pkgs)
              bc
              bison
              flex
              gnumake
              ncurses
              openssl
              pkg-config
              ;
            inherit (pkgs.llvmPackages)
              bintools-unwrapped
              clang
              stdenv
              ;
          };
        };
    };
}
