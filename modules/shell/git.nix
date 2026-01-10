{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.shell.git;
  inherit (config.dotfiles) configDir;
in {
  options.modules.shell.git = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      git-annex
      unstable.gh
      git-open
      diff-so-fancy
      (mkIf config.modules.shell.gnupg.enable
        git-crypt)
      act
    ];

    home.configFile = {
      "git/config".source = "${configDir}/git/config";
      "git/ignore".source = "${configDir}/git/ignore";
      "git/attributes".source = "${configDir}/git/attributes";
    };

    modules.shell.zsh.rcFiles = ["${configDir}/git/aliases.zsh"];
  };
}
