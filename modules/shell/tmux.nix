{
  config,
  options,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.shell.tmux;
  configDir = config.dotfiles.configDir;
in {
  options.modules.shell.tmux = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    # user.packages = with pkgs; [
    # ];
    programs.tmux.enable = true;

    # home.configFile = {
    #   "dir/file".source = "${configDir}/dir/file";
    # };
  };
}
