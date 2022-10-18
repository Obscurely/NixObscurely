# modules/dev/rust.nix --- https://rust-lang.org
#
# Rust: the love of my life!

{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let devCfg = config.modules.dev;
    cfg = devCfg.rust;
in {
  options.modules.dev.rust = {
    enable = mkBoolOpt false;
    xdg.enable = mkBoolOpt devCfg.xdg.enable;
  };

  config = mkMerge [
    (mkIf cfg.enable {
      user.packages = [ 
        pkgs.rustup
        pkgs.rust-analyzer
        pkgs.taplo-cli
        pkgs.llvmPackages_latest.llvm
        pkgs.llvmPackages_latest.bintools
        pkgs.zlib.out
        pkgs.xorriso
        pkgs.grub2
        pkgs.llvmPackages_latest.lld
      ];

      env.PATH = [ "$(${pkgs.yarn}/bin/yarn global bin)" ];
      environment.shellAliases = {
        rs  = "rustc";
        rsp = "rustup";
        ca  = "cargo";
      };
    })

    (mkIf cfg.xdg.enable {
      env.RUSTUP_HOME = "$XDG_DATA_HOME/rustup";
      env.CARGO_HOME = "$XDG_DATA_HOME/cargo";
      env.PATH = [ "$CARGO_HOME/bin" ];
    })
  ];
}
