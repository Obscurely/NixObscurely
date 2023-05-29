# modules/dev/rust.nix --- https://rust-lang.org
#
# Rust: the love of my life!
{
  config,
  options,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.my; let
  devCfg = config.modules.dev;
  cfg = devCfg.rust;
in {
  options.modules.dev.rust = {
    enable = mkBoolOpt false;
    xdg.enable = mkBoolOpt devCfg.xdg.enable;
  };

  config = mkMerge [
    (mkIf cfg.enable {
      user.packages = with pkgs; [
        llvmPackages_latest.llvm
        llvmPackages_latest.bintools
        zlib.out
        xorriso
        grub2
        llvmPackages_latest.lld
        rust-analyzer
        taplo-cli
        rustc
        cargo
        rustfmt
        clippy
        graphviz # this is for neovim rust-tools plugin
        lldb_15 # this if for neovim dap (debugger)
        cargo-audit # audit dependencies in order to scan for supply chain attacks 
        cargo-fuzz # fuzzing tool
        cargo-deny # tool to deny crates based on checks.
      ];

      env.PATH = ["$(${pkgs.yarn}/bin/yarn global bin)"];
      environment.shellAliases = {
        rs = "rustc";
        ca = "cargo";
      };
    })

    (mkIf cfg.xdg.enable {
      env.CARGO_HOME = "$XDG_DATA_HOME/cargo";
      env.PATH = ["$CARGO_HOME/bin"];
    })
  ];
}
