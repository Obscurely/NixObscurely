# modules/browser/librewolf.nix --- https://librewolf.net/
#
# A custom version of Firefox, focused on privacy, security and freedom.

{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop.browsers.librewolf;
    configDir = config.dotfiles.configDir;
in {
  options.modules.desktop.browsers.librewolf = with types; {
    enable = mkBoolOpt false;
    profileName = mkOpt types.str config.user.name;

    settings = mkOpt' (attrsOf (oneOf [ bool int str ])) {} ''
      Librewolf preferences to set in <filename>user.js</filename>
    '';
    extraConfig = mkOpt' lines "" ''
      Extra lines to add to <filename>user.js</filename>
    '';

    userChrome  = mkOpt' lines "" "CSS Styles for Librewolf's interface";
    userContent = mkOpt' lines "" "Global CSS Styles for websites";
  };

  config = mkIf cfg.enable (mkMerge [
    {
      user.packages = with pkgs; [
        unstable.librewolf
        (makeDesktopItem {
          name = "librewolf-private";
          desktopName = "Librewolf (Private)";
          genericName = "Open a private Librewolf window";
          icon = "librewolf";
          exec = "${unstable.librewolf}/bin/librewolf --private-window";
          categories = [ "Network" ];
        })
      ];

      # Prevent auto-creation of ~/Desktop. The trailing slash is necessary; see
      # https://bugzilla.mozilla.org/show_bug.cgi?id=1082717
      env.XDG_DESKTOP_DIR = "$HOME/";

      modules.desktop.browsers.librewolf.settings = {
        # Default to dark theme in DevTools panel
        "devtools.theme" = "dark";
        # Set browser to dark theme
        "extensions.activeThemeID" = "firefox-compact-dark@mozilla.org";
        # Set browser font to Roboto
        "font.name.serif.x-western" = "Roboto";
        "font.size.variable.x-western" = 18;
        # Enable ETP for decent security (makes librewolf containers and many
        # common security/privacy add-ons redundant).
        "browser.contentblocking.category" = "strict";
        "privacy.donottrackheader.enabled" = true;
        "privacy.donottrackheader.value" = 1;
        "privacy.purge_trackers.enabled" = true;
        # Your customized toolbar settings are stored in
        # 'browser.uiCustomization.state'. This tells librewolf to sync it between
        # machines. WARNING: This may not work across OSes. Since I use NixOS on
        # all the machines I use Librewolf on, this is no concern to me.
        "services.sync.prefs.sync.browser.uiCustomization.state" = true;
        # Enable userContent.css and userChrome.css for our theme modules
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        # Stop creating ~/Downloads!
        "browser.download.dir" = "${config.user.home}/Downloads";
        # Don't use the built-in password manager. A nixos user is more likely
        # using an external one (you are using one, right?).
        "signon.rememberSignons" = false;
        # Do not check if Librewolf is the default browser
        "browser.shell.checkDefaultBrowser" = false;
        # Disable the "new tab page" feature and show a blank tab instead
        # https://wiki.mozilla.org/Privacy/Reviews/New_Tab
        # https://support.mozilla.org/en-US/kb/new-tab-page-show-hide-and-customize-top-sites#w_how-do-i-turn-the-new-tab-page-off
        "browser.newtabpage.enabled" = false;
        "browser.newtab.url" = "about:blank";
        # Disable Activity Stream
        # https://wiki.mozilla.org/Librewolf/Activity_Stream
        "browser.newtabpage.activity-stream.enabled" = false;
        "browser.newtabpage.activity-stream.telemetry" = false;
        # Disable new tab tile ads & preload
        # http://www.thewindowsclub.com/disable-remove-ad-tiles-from-firefox
        # http://forums.mozillazine.org/viewtopic.php?p=13876331#p13876331
        # https://wiki.mozilla.org/Tiles/Technical_Documentation#Ping
        # https://gecko.readthedocs.org/en/latest/browser/browser/DirectoryLinksProvider.html#browser-newtabpage-directory-source
        # https://gecko.readthedocs.org/en/latest/browser/browser/DirectoryLinksProvider.html#browser-newtabpage-directory-ping
        "browser.newtabpage.enhanced" = false;
        "browser.newtabpage.introShown" = true;
        "browser.newtab.preload" = false;
        "browser.newtabpage.directory.ping" = "";
        "browser.newtabpage.directory.source" = "data:text/plain,{}";
        # Reduce search engine noise in the urlbar's completion window. The
        # shortcuts and suggestions will still work, but Librewolf won't clutter
        # its UI with reminders that they exist.
        "browser.urlbar.suggest.searches" = false;
        "browser.urlbar.shortcuts.bookmarks" = false;
        "browser.urlbar.shortcuts.history" = false;
        "browser.urlbar.shortcuts.tabs" = false;
        "browser.urlbar.showSearchSuggestionsFirst" = false;
        "browser.urlbar.speculativeConnect.enabled" = false;
        # https://bugzilla.mozilla.org/1642623
        "browser.urlbar.dnsResolveSingleWordsAfterSearch" = 0;
        # https://blog.mozilla.org/data/2021/09/15/data-and-firefox-suggest/
        "browser.urlbar.suggest.quicksuggest.nonsponsored" = false;
        "browser.urlbar.suggest.quicksuggest.sponsored" = false;
        # Show whole URL in address bar
        "browser.urlbar.trimURLs" = false;
        # Disable some not so useful functionality.
        "browser.disableResetPrompt" = true;       # "Looks like you haven't started Librewolf in a while."
        "browser.onboarding.enabled" = false;      # "New to Librewolf? Let's get started!" tour
        "browser.aboutConfig.showWarning" = false; # Warning when opening about:config
        "media.videocontrols.picture-in-picture.video-toggle.enabled" = false;
        "extensions.pocket.enabled" = false;
        "extensions.shield-recipe-client.enabled" = false;
        "reader.parse-on-load.enabled" = false;  # "reader view"

        # Security-oriented defaults
        "security.family_safety.mode" = 0;
        # https://blog.mozilla.org/security/2016/10/18/phasing-out-sha-1-on-the-public-web/
        "security.pki.sha1_enforcement_level" = 1;
        # https://github.com/tlswg/tls13-spec/issues/1001
        "security.tls.enable_0rtt_data" = false;
        # Use Mozilla geolocation service instead of Google if given permission
        "geo.provider.network.url" = "https://location.services.mozilla.com/v1/geolocate?key=%MOZILLA_API_KEY%";
        "geo.provider.use_gpsd" = false;
        # https://support.mozilla.org/en-US/kb/extension-recommendations
        "browser.newtabpage.activity-stream.asrouter.userprefs.cfr" = false;
        "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.addons" = false;
        "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.features" = false;
        "extensions.htmlaboutaddons.recommendations.enabled" = false;
        "extensions.htmlaboutaddons.discover.enabled" = false;
        "extensions.getAddons.showPane" = false;  # uses Google Analytics
        "browser.discovery.enabled" = false;
        # Reduce File IO / SSD abuse
        # Otherwise, Librewolf bombards the HD with writes. Not so nice for SSDs.
        # This forces it to write every 30 minutes, rather than 15 seconds.
        "browser.sessionstore.interval" = "1800000";
        # Disable battery API
        # https://developer.mozilla.org/en-US/docs/Web/API/BatteryManager
        # https://bugzilla.mozilla.org/show_bug.cgi?id=1313580
        "dom.battery.enabled" = false;
        # Disable "beacon" asynchronous HTTP transfers (used for analytics)
        # https://developer.mozilla.org/en-US/docs/Web/API/navigator.sendBeacon
        "beacon.enabled" = false;
        # Disable pinging URIs specified in HTML <a> ping= attributes
        # http://kb.mozillazine.org/Browser.send_pings
        "browser.send_pings" = false;
        # Disable gamepad API to prevent USB device enumeration
        # https://www.w3.org/TR/gamepad/
        # https://trac.torproject.org/projects/tor/ticket/13023
        "dom.gamepad.enabled" = false;
        # Don't try to guess domain names when entering an invalid domain name in URL bar
        # http://www-archive.mozilla.org/docs/end-user/domain-guessing.html
        "browser.fixup.alternate.enabled" = false;
        # Disable telemetry
        # https://wiki.mozilla.org/Platform/Features/Telemetry
        # https://wiki.mozilla.org/Privacy/Reviews/Telemetry
        # https://wiki.mozilla.org/Telemetry
        # https://www.mozilla.org/en-US/legal/privacy/firefox.html#telemetry
        # https://support.mozilla.org/t5/Firefox-crashes/Mozilla-Crash-Reporter/ta-p/1715
        # https://wiki.mozilla.org/Security/Reviews/Firefox6/ReviewNotes/telemetry
        # https://gecko.readthedocs.io/en/latest/browser/experiments/experiments/manifest.html
        # https://wiki.mozilla.org/Telemetry/Experiments
        # https://support.mozilla.org/en-US/questions/1197144
        # https://firefox-source-docs.mozilla.org/toolkit/components/telemetry/telemetry/internals/preferences.html#id1
        "toolkit.telemetry.unified" = false;
        "toolkit.telemetry.enabled" = false;
        "toolkit.telemetry.server" = "data:,";
        "toolkit.telemetry.archive.enabled" = false;
        "toolkit.telemetry.coverage.opt-out" = true;
        "toolkit.coverage.opt-out" = true;
        "toolkit.coverage.endpoint.base" = "";
        "experiments.supported" = false;
        "experiments.enabled" = false;
        "experiments.manifest.uri" = "";
        "browser.ping-centre.telemetry" = false;
        # https://mozilla.github.io/normandy/
        "app.normandy.enabled" = false;
        "app.normandy.api_url" = "";
        "app.shield.optoutstudies.enabled" = false;
        # Disable health reports (basically more telemetry)
        # https://support.mozilla.org/en-US/kb/firefox-health-report-understand-your-browser-perf
        # https://gecko.readthedocs.org/en/latest/toolkit/components/telemetry/telemetry/preferences.html
        "datareporting.healthreport.uploadEnabled" = false;
        "datareporting.healthreport.service.enabled" = false;
        "datareporting.policy.dataSubmissionEnabled" = false;
        # Disable proxy
        "network.proxy.type" = 0;

        # Disable crash reports
        "breakpad.reportURL" = "";
        "browser.tabs.crashReporting.sendReport" = false;
        "browser.crashReports.unsubmittedCheck.autoSubmit2" = false;  # don't submit backlogged reports

        # Disable Form autofill
        # https://wiki.mozilla.org/Firefox/Features/Form_Autofill
        "browser.formfill.enable" = false;
        "extensions.formautofill.addresses.enabled" = false;
        "extensions.formautofill.available" = "off";
        "extensions.formautofill.creditCards.available" = false;
        "extensions.formautofill.creditCards.enabled" = false;
        "extensions.formautofill.heuristics.enabled" = false;

        # Disable first run intro
        "app.normandy.first_run" = false;

        # Disable smooth scrolling (hate this feature on web browsers)
        "general.smoothScroll" = false;

        # Disable tailored performance settings and enable hw accel
        "browser.preferences.defaultPerformanceSettings.enabled" = false;
        "layers.acceleration.disabled" = false;

        # Set homepage to selfhosted Bento and new tab to homepage
        "browser.startup.homepage" = "https://start.server.com/";

        # Disable search suggestions
        "browser.urlbar.suggest.history" = false;
        "browser.urlbar.suggest.bookmark" = false;
        "browser.urlbar.suggest.openpage" = false;
        "browser.urlbar.suggest.topsites" = false;

        # Default permissions
        "permissions.default.geo" = 2;
        "permissions.default.camera" = 2;
        "permissions.default.microphone" = 2;
        "permissions.default.desktop-notification" = 2;
        "permissions.default.xr" = 2;

        # Disable middle click paste, just don't like the option
        "middlemouse.paste" = false;

        # Disable ipv6 since my ISP doesn't use it
        "network.dns.disableIPv6" = true;

        # Set cookie behaviour
        "network.cookie.cookieBehavior" = 5;

        # Disable drm
        "media.eme.enabled" = false;

        # Other privacy focused settings
        "accessibility.force_disabled" = 1;
        "accessibility.typeaheadfind.flashBar" = 0;
        "browser.search.suggest.enabled" = false;
        "browser.search.update" = false;
        "privacy.trackingprotection.enabled" = true;
        "privacy.trackingprotection.socialtracking.enabled" = true;
        "places.history.enabled" = false;
        "privacy.history.custom" = true;
        "privacy.cpd.history" = true;
        "dom.security.https_only_mode" = true;
        "dom.security.https_only_mode_ever_enabled" = true;
        "layout.spellcheckDefault" = 0;
        "dom.event.clipboardevents.enabled" = false;
        "browser.safebrowsing.phishing.enabled" = false;
        "browser.safebrowsing.malware.enabled" = false;
        "network.http.sendRefererHeader" = 0; # Might break some sites such as WordPress
        "security.pki.crlite_mode" = 2; # advance ssl certificate check
        "network.http.referer.XOriginPolicy" = 2; # send hostnames when there is a full match
        "privacy.clearOnShutdown.cache" = true; # clear cache on shutdown
        "privacy.clearOnShutdown.history" = true;
        "privacy.clearOnShutdown.downloads" = true;
        "privacy.clearOnShutdown.formdata" = true;
        "privacy.clearOnShutdown.sessions" = true;
        "privacy.clearOnShutdown.cookies" = false; # don't clear so we stay logged in
        "privacy.clearOnShutdown.offlineApps" = false; # don't clear so we stay logged in

        # Performance
        "network.dns.disablePrefetch" = true;
        "network.prefetch-next" = false;

        # Mitigate fingerprinting
        "media.peerconnection.enabled " = false;
        "geo.enabled" = false;
        "privacy.firstparty.isolate" = true;
        "media.navigator.enabled" = false; # this block websites from getting your camera and mic status

        # Security
        "browser.download.always_ask_before_handling_new_types" = true; # chose with what to open new file types

        # Misc
        "dom.event.contextmenu.enabled" = false; # don't allow websites to mess with context menu
        "network.IDN_show_punycode" = true;
        "dom.security.https_only_mode_send_http_background_request" = false; # disable https timeout

        # Extensions
        browser.policies.runOncePerModification.extensionsInstall = ["https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi" "https://addons.mozilla.org/firefox/downloads/latest/cookie-autodelete/latest.xpi" "https://addons.mozilla.org/firefox/downloads/latest/decentraleyes/latest.xpi" "https://addons.mozilla.org/firefox/downloads/latest/privacy-badger17/latest.xpi" "https://addons.mozilla.org/firefox/downloads/latest/uaswitcher/latest.xpi"];
      };

      # Use a stable profile name so we can target it in themes
      home.file = let cfgPath = ".librewolf"; in {
        "${cfgPath}/profiles.ini".text = ''
          [Profile0]
          Name=default
          IsRelative=1
          Path=${cfg.profileName}.default
          Default=1

          [General]
          StartWithLastProfile=1
          Version=2
        '';

        "${cfgPath}/${cfg.profileName}.default/user.js" =
          mkIf (cfg.settings != {} || cfg.extraConfig != "") {
            text = ''
              ${concatStrings (mapAttrsToList (name: value: ''
                user_pref("${name}", ${builtins.toJSON value});
              '') cfg.settings)}
              ${cfg.extraConfig}
            '';
          };

        "${cfgPath}/${cfg.profileName}.default/chrome/userChrome.css" =
          mkIf (cfg.userChrome != "") {
            text = cfg.userChrome;
          };

        "${cfgPath}/${cfg.profileName}.default/chrome/userContent.css" =
          mkIf (cfg.userContent != "") {
            text = cfg.userContent;
          };

        "${cfgPath}/${cfg.profileName}.default/extension-settings.json" = {
            source = "${configDir}/librewolf/extension-settings.json";
          };
        "${cfgPath}/${cfg.profileName}.default/extension-preferences.json" = {
            source = "${configDir}/librewolf/extension-preferences.json";
          };
      };
    }
  ]);
}
