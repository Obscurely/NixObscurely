# modules/desktop/media/youtube.nix
#
# Runtime deps for the private terminal-only YouTube workflow (the `yt` suite lives in bin/, on PATH
# via $DOTFILES_BIN). API-free: yt-dlp (fetch/meta/comments) + a custom python RSS feed (bin/yt-feed) +
# mpv (player) + fzf/jq (the yt scripts) + chafa+curl (terminal thumbnails) + ungoogled-chromium (already
# provided by modules.desktop.browsers.chromium — the emergency browser fallback).
# Design + phases: docs/superpowers/specs/2026-08-05-youtube-workflow-overview.md
{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.desktop.media.youtube;
  inherit (config.dotfiles) configDir;
in {
  options.modules.desktop.media.youtube = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      unstable.yt-dlp # freshest yt-dlp (via the `unstable` overlay) — resists YouTube SABR/PO-token breakage
      ffmpeg # yt-dlp merge (VP9+Opus -> mkv) + embed chapters/metadata/thumbnail
      python3 # the unified subscriptions feed (bin/yt-feed: concurrent RSS fetch/parse, stdlib only)
      curl # fetch thumbnails for the fzf previews (chafa renders them)
      fzf # the yt suite's picker
      jq # JSON (comments, metadata)
      chafa # terminal-image thumbnails that work in Alacritty (no native image protocol)
    ];

    # Deploy the git-tracked priority-channel list into ~/.config/yt; `yt subs import` writes the
    # generated `subscriptions` file alongside it (the dir stays writable). Downloads live under
    # /data/youtube (created on demand by `bin/yt`). The `yt` suite itself is in bin/ (on PATH).
    home.configFile."yt/priority.txt".source = "${configDir}/yt/priority.txt";
  };
}
