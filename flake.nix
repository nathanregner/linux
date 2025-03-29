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
          # stdenv = pkgs.overrideCC pkgs.clangStdenv (
          #   pkgs.ccacheWrapper.override { inherit (pkgs.clangStdenv) cc; }
          # );
          # stdenv = pkgs.pkgsCross.aarch64-multiplatform.ccacheStdenv;
          # stdenv = pkgs.ccacheStdenv;
          # inherit (pkgs) stdenv;
          # stdenv = (pkgs.pkgsCross.aarch64-multiplatform) stdenv;
          inherit (pkgs.pkgsCross.aarch64-multiplatform) stdenv;
        in
        (pkgs.mkShell.override {
          inherit stdenv;
        })
          {
            env = {
              # ARCH = "arm64";
              # CROSS_COMPILE = "aarch64-unknown-linux-gnu-";
              # LLVM = "1";
              # PKG_CONFIG_PATH = "${pkgs.ncurses.dev}/lib/pkgconfig";
              # KCFLAGS = "-I${pkgs.llvmPackages.clang}/resource-root/include -Wno-everything -march=armv8-a+crypto -Wno-error=unused-command-line-argument";
              # KCFLAGS = "-Wno-everything -Wno-error=unused-command-line-argument";
              ARCH = stdenv.hostPlatform.linuxArch;
              CROSS_COMPILE = stdenv.cc.targetPrefix;
            };
            shellHook = ''
              alias make="make -j$NIX_BUILD_CORES"
            '';
            packages = builtins.attrValues {
              inherit (pkgs)
                bc
                bison
                flex
                ncurses
                openssl
                pkg-config
                stdenv
                ;
              inherit (pkgs.stdenv) cc;
              # inherit (pkgs.pkgsCross.aarch64-multiplatform) stdenv;
              # inherit (pkgs.llvmPackages)
              #   bintools-unwrapped
              #   clang
              #   stdenv
              #   ;
            };
          };
    };
}
