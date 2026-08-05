# modules/desktop/media/youtube.nix
#
# Runtime deps for the private terminal-only YouTube workflow (the `yt` suite lives in bin/, on PATH
# via $DOTFILES_BIN). API-free: newsboat (RSS subs feed) + yt-dlp (fetch/meta/comments) + mpv (player)
# + fzf/jq (the yt scripts) + chafa (terminal-agnostic thumbnails) + ungoogled-chromium (already provided
# by modules.desktop.browsers.chromium — the emergency browser fallback).
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
      newsboat # subscriptions feed (Phase 2)
      fzf # the yt suite's picker
      jq # JSON (comments, metadata)
      chafa # terminal-image thumbnails that work in Alacritty (no native image protocol)
    ];

    # newsboat: deploy config + priority list as single files so the dir stays writable for the
    # generated `urls` (from `yt subs import`) and newsboat's own cache. Downloads live under
    # /data/youtube (created on demand by `bin/yt`). The `yt` suite itself is in bin/ (on PATH).
    home.configFile = {
      "newsboat/config".source = "${configDir}/newsboat/config";
      "newsboat/priority.txt".source = "${configDir}/newsboat/priority.txt";
    };
  };
}
