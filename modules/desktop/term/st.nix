{ config, options, pkgs, lib, inputs, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop.term.st;
in {
  options.modules.desktop.term.st = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    # xst-256color isn't supported over ssh, so revert to a known one
    modules.shell.zsh.rcInit = ''
      [ "$TERM" = xst-256color ] && export TERM=xterm-256color
    '';

    user.packages = [
      inputs.st.packages.POSIX.st-snazzy # st + nice-to-have extensions
    ];
  };
}
