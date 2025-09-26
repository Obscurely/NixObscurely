{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.desktop.browsers.zen;
in {
  options.modules.desktop.browsers.zen = with types; {
    enable = mkBoolOpt false;

    profileName = mkOpt types.str config.user.name;

    settings = mkOpt' (attrsOf (oneOf [bool int str])) {} ''
      Zen preferences to set in <filename>user.js</filename>
    '';
    extraConfig = mkOpt' lines "" ''
      Extra lines to add to <filename>user.js</filename>
    '';
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      inputs.zen-browser.packages."${system}".default
      (makeDesktopItem {
        name = "zen-private";
        desktopName = "Zen Browser (Private)";
        genericName = "Open a private Zen window";
        icon = "zen-beta";
        exec = "${inputs.zen-browser.packages."${system}".default}/bin/zen --private-window";
        categories = ["Network"];
      })
    ];

    # environment variable for hw accel
    environment.variables = {
      MOZ_DISABLE_RDD_SANDBOX = "1";
      ZEN_DISABLE_RDD_SANDBOX = "1"; # in case they changed it
      LIBVA_DRIVER_NAME = "nvidia";
    };

    modules.desktop.browsers.zen.settings = {
      # Default to dark theme in DevTools panel
      "devtools.theme" = "dark";
      # Set browser to dark theme
      "extensions.activeThemeID" = "firefox-compact-dark@mozilla.org";
      # set default perefered color scheme to dark
      "layout.css.prefers-color-scheme.content-override" = 0;
      # Set browser font to Roboto
      "font.name.serif.x-western" = "Roboto";
      "font.name.monospace.x-western" = "FiraCode Nerd Font Mono";
      "font.name.sans-serif.x-western" = "Noto Sans";
      # Fix dpi (I have a high res dispaly 1440p)
      "layout.css.devPixelsPerPx" = "1.2";
      # Enable ETP for decent security (makes zen containers and many
      # common security/privacy add-ons redundant).
      "browser.contentblocking.category" = "strict";
      "privacy.donottrackheader.enabled" = true;
      "privacy.donottrackheader.value" = 1;
      "privacy.purge_trackers.enabled" = true;
      # Stop creating ~/Downloads!
      "browser.download.dir" = "${config.user.home}/Downloads";
      # Don't use the built-in password manager. A nixos user is more likely
      # using an external one (you are using one, right?).
      "signon.rememberSignons" = false;
      # Do not check if zen is the default browser
      "browser.shell.checkDefaultBrowser" = false;
      # Disable the "new tab page" feature and show a blank tab instead
      # https://wiki.mozilla.org/Privacy/Reviews/New_Tab
      # https://support.mozilla.org/en-US/kb/new-tab-page-show-hide-and-customize-top-sites#w_how-do-i-turn-the-new-tab-page-off
      "browser.newtabpage.enabled" = false;
      "browser.newtab.url" = "about:blank";
      # Disable Activity Stream
      # https://wiki.mozilla.org/Firefox/Activity_Stream
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
      # shortcuts and suggestions will still work, but Zen won't clutter
      # its UI with reminders that they exist.
      "browser.urlbar.suggest.searches" = false;
      "browser.urlbar.shortcuts.bookmarks" = false;
      "browser.urlbar.shortcuts.history" = false;
      "browser.urlbar.shortcuts.tabs" = false;
      "browser.urlbar.suggest.engines" = false;
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
      "browser.disableResetPrompt" = true; # "Looks like you haven't started Zen in a while."
      "browser.onboarding.enabled" = false; # "New to Zen? Let's get started!" tour
      "browser.aboutConfig.showWarning" = false; # Warning when opening about:config
      "media.videocontrols.picture-in-picture.video-toggle.enabled" = false;
      "extensions.pocket.enabled" = false;
      "extensions.shield-recipe-client.enabled" = false;
      "reader.parse-on-load.enabled" = false; # "reader view"

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
      "extensions.getAddons.showPane" = false; # uses Google Analytics
      "browser.discovery.enabled" = false;
      # Reduce File IO / SSD abuse
      # Otherwise, Zen bombards the HD with writes. Not so nice for SSDs.
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
      "browser.crashReports.unsubmittedCheck.autoSubmit2" = false; # don't submit backlogged reports

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
      "general.smoothScroll.lines" = false;
      "general.smoothScroll.mouseWheel" = false;
      "general.smoothScroll.msdPhysics.enabled" = false;
      "general.smoothScroll.other" = false;
      "general.smoothScroll.pages" = false;
      "general.smoothScroll.pixels" = false;
      "general.smoothScroll.scrollbars" = false;
      "toolkit.scrollbox.smoothScroll" = false;

      # Disable tailored performance settings and enable hw accel
      "browser.preferences.defaultPerformanceSettings.enabled" = false;
      "layers.acceleration.disabled" = false;
      "layers.acceleration.force-enabled" = true;
      "gfx.x11-egl.force-enabled" = true;
      "media.ffmpeg.enabled" = true;
      "media.rdd-ffmpeg.enabled" = true;
      "media.ffmpeg.vaapi.enabled" = true;
      "media.ffvpx.enabled" = false;
      "media.rdd-vpx.enabled" = false;
      "media.navigator.mediadatadecoder_vpx_enabled" = true;
      "widget.dmabuf.force-enabled" = true;

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

      # Enable ipv6
      "network.dns.disableIPv6" = false;

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
      "dom.event.clipboardevents.enabled" = true; # without it copy and pasting in apps like Trilium doesn't work
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
      "dom.push.enabled" = false; # I don't even know why you would want this.

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

      # Fingerprinting
      "privacy.resistFingerprinting" = true;
      "privacy.resistFingerprinting.block_mozAddonManager" = true;
      "privacy.resistFingerprinting.target_video_res" = 1080;

      # Other options (security related mostly) taken from Librewolf
      "accessibility.warn_on_browsewithcaret" = false;
      "browser.bookmarks.addedImportButton" = true;
      "browser.bookmarks.restore_default_bookmarks" = false;
      "browser.dom.window.dump.enabled" = false;
      "browser.download.save_converter_index" = 0;
      "browser.download.viewableInternally.typeWasRegistered.avif" = true;
      "browser.download.viewableInternally.typeWasRegistered.webp" = true;
      "browser.migration.version" = 150;
      "browser.newtabpage.storageVersion" = 1;
      "browser.pageActions.persistedActions" = "{\"ids\":[\"bookmark\"],\"idsInUrlbar\":[\"bookmark\"],\"idsInUrlbarPreProton\":[],\"version\":1}";
      "browser.pagethumbnails.storage_version" = 3;
      "browser.policies.applied" = true;
      "browser.policies.runOncePerModification.extensionsUninstall" = "[\"google@search.mozilla.org\",\"bing@search.mozilla.org\",\"amazondotcom@search.mozilla.org\",\"ebay@search.mozilla.org\",\"twitter@search.mozilla.org\"]";
      "browser.policies.runOncePerModification.removeSearchEngines" = "[\"Google\",\"Bing\",\"Amazon.com\",\"eBay\",\"Twitter\", \"Wikipedia\"]";
      "browser.policies.runOncePerModification.setDefaultSearchEngine" = "DuckDuckGo";
      "browser.region.network.url" = "";
      "browser.region.update.enabled" = false;
      "browser.safebrowsing.downloads.remote.block_potentially_unwanted" = false;
      "browser.safebrowsing.downloads.remote.block_uncommon" = false;
      "browser.safebrowsing.downloads.remote.enabled" = false;
      "browser.safebrowsing.downloads.remote.url" = "";
      "browser.safebrowsing.provider.google4.dataSharingURL" = "";
      "browser.search.separatePrivateDefault" = false;
      "browser.search.serpEventTelemetryCategorization.regionEnabled" = false;
      "browser.tabs.haveShownCloseAllDuplicateTabsWarning" = true;
      "browser.tabs.inTitlebar" = 0;
      "browser.toolbars.bookmarks.visibility" = "never";
      "browser.translations.panelShown" = true;
      "captivedetect.canonicalURL" = "";
      "datareporting.dau.cachedUsageProfileID" = "beefbeef-beef-beef-beef-beeefbeefbee";
      "devtools.console.stdout.chrome" = false;
      "devtools.debugger.expressions-visible" = true;
      "devtools.debugger.prefs-schema-version" = 11;
      "devtools.debugger.remote-enabled" = false;
      "devtools.everOpened" = true;
      "devtools.netmonitor.msg.visibleColumns" = "[\"data\",\"time\"]";
      "devtools.performance.recording.entries" = 134217728;
      "devtools.performance.recording.features" = "[\"screenshots\",\"js\",\"stackwalk\",\"cpu\",\"processcpu\"]";
      "devtools.performance.recording.threads" = "[\"GeckoMain\",\"Compositor\",\"Renderer\",\"SwComposite\",\"DOM Worker\"]";
      "devtools.responsive.reloadNotification.enabled" = false;
      "devtools.responsive.touchSimulation.enabled" = true;
      "devtools.responsive.userAgent" = "Mozilla/5.0 (iPhone; CPU iPhone OS 14_6 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/14.0.3 Mobile/15E148 Safari/604.1";
      "devtools.responsive.viewport.pixelRatio" = 3;
      "distribution.iniFile.exists.appversion" = "134.0.1";
      "distribution.iniFile.exists.value" = true;
      "distribution.nixos.bookmarksProcessed" = true;
      "doh-rollout.provider-list" = "[{\"UIName\":\"Mozilla Cloudflare\",\"uri\":\"https://mozilla.cloudflare-dns.com/dns-query\"},{\"UIName\":\"Quad9\",\"uri\":\"https://dns.quad9.net/dns-query\"},{\"UIName\":\"Quad9+ECS\",\"uri\":\"https://dns11.quad9.net/dns-query\"}]";
      "dom.forms.autocomplete.formautofill" = true;
      "dom.private-attribution.submission.enabled" = false;
      "extensions.blocklist.pingCountVersion" = -1;
      "extensions.databaseSchema" = 37;
      "extensions.getAddons.databaseSchema" = 6;
      "extensions.pendingOperations" = false;
      "extensions.pictureinpicture.enable_picture_in_picture_overrides" = true;
      "extensions.quarantinedDomains.list" = "autoatendimento.bb.com.br,ibpf.sicredi.com.br,ibpj.sicredi.com.br,internetbanking.caixa.gov.br,www.ib12.bradesco.com.br,www2.bancobrasil.com.br";
      "extensions.systemAddonSet" = "{\"schema\":1,\"addons\":{}}";
      "extensions.ui.dictionary.hidden" = true;
      "extensions.ui.locale.hidden" = true;
      "extensions.ui.plugin.hidden" = false;
      "extensions.ui.sitepermission.hidden" = true;
      "extensions.ui.theme.hidden" = false;
      "extensions.webcompat.enable_shims" = true;
      "extensions.webcompat.perform_injections" = true;
      "extensions.webcompat.perform_ua_overrides" = true;
      "gecko.handlerService.defaultHandlersVersion" = 1;
      "gfx.webrender.all" = true;
      "svg.context-properties.content.enabled" = true;
      "media.hardware-video-decoding.enabled" = true;
      "media.hardware-video-decoding.force-enabled" = true;
      "intl.accept_languages" = "en-US, en";
      "javascript.use_us_english_locale" = true;
      "media.gmp.storage.version.observed" = 1;
      "network.captive-portal-service.enabled" = false;
      "network.connectivity-service.enabled" = false;
      "network.cookie.cookieBehavior.optInPartitioning" = true;
      "network.http.referer.disallowCrossSiteRelaxingDefault.top_navigation" = true;
      "network.http.speculative-parallel-limit" = 0;
      "network.predictor.enabled" = false;
      "network.trr.custom_uri" = "https://dns10.quad9.net/dns-query";
      "pdfjs.enabledCache.state" = true;
      "pdfjs.migrationVersion" = 2;
      "permissions.delegation.enabled" = false;
      "permissions.manager.defaultsUrl" = "";
      "privacy.annotate_channels.strict_list.enabled" = true;
      "privacy.bounceTrackingProtection.hasMigratedUserActivationData" = true;
      "privacy.bounceTrackingProtection.mode" = 1;
      "privacy.clearOnShutdown_v2.cookiesAndStorage" = false;
      "privacy.fingerprintingProtection" = true;
      "privacy.globalprivacycontrol.was_ever_enabled" = true;
      "privacy.purge_trackers.date_in_cookie_database" = "0";
      "privacy.query_stripping.enabled" = true;
      "privacy.query_stripping.enabled.pbmode" = true;
      "privacy.sanitize.pending" = "[{\"id\":\"shutdown\",\"itemsToClear\":[\"cache\"],\"options\":{}},{\"id\":\"newtab-container\",\"itemsToClear\":[],\"options\":{}}]";
      "privacy.trackingprotection.emailtracking.enabled" = true;
      "security.OCSP.require" = false;
      "security.disable_button.openCertManager" = false;
      "services.settings.clock_skew_seconds" = 1;
      "services.sync.engine.addresses.available" = true;
      "services.sync.prefs.sync.browser.uiCustomization.state" = true;
      "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
      "toolkit.telemetry.reportingpolicy.firstRun" = false;
      "toolkit.winRegisterApplicationRestart" = false;
      "ui.key.menuAccessKeyFocuses" = false;
      "webchannel.allowObject.urlWhitelist" = "";

      # Other security options taken from arkonfox's user.js
      "browser.newtabpage.activity-stream.showSponsored" = false;
      "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
      "browser.newtabpage.activity-stream.default.sites" = "";
      "geo.provider.ms-windows-location" = false;
      "geo.provider.use_corelocation" = false;
      "geo.provider.use_geoclue" = false;
      "browser.shopping.experience2023.enabled" = false;
      "toolkit.telemetry.newProfilePing.enabled" = false;
      "toolkit.telemetry.shutdownPingSender.enabled" = false;
      "toolkit.telemetry.updatePing.enabled" = false;
      "toolkit.telemetry.bhrPing.enabled" = false;
      "toolkit.telemetry.firstShutdownPing.enabled" = false;
      "browser.newtabpage.activity-stream.feeds.telemetry" = false;
      "network.dns.disablePrefetchFromHTTPS" = true;
      "network.predictor.enable-prefetch" = false;
      "browser.places.speculativeConnect.enabled" = false;
      "network.proxy.socks_remote_dns" = true;
      "network.file.disable_unc_paths" = true;
      "network.gio.supported-protocols" = "";
      "browser.urlbar.quicksuggest.enabled" = false;
      "browser.urlbar.trending.featureGate" = false;
      "browser.urlbar.addons.featureGate" = false;
      "browser.urlbar.fakespot.featureGate" = false;
      "browser.urlbar.mdn.featureGate" = false;
      "browser.urlbar.pocket.featureGate" = false;
      "browser.urlbar.weather.featureGate" = false;
      "browser.urlbar.yelp.featureGate" = false;
      "browser.search.separatePrivateDefault.ui.enabled" = true;
      "signon.autofillForms" = false;
      "signon.formlessCapture.enabled" = false;
      "network.auth.subresource-http-auth-allow" = 1;
      "browser.sessionstore.privacy_level" = 2;
      "browser.shell.shortcutFavicons" = false;
      "security.ssl.require_safe_negotiation" = true;
      "security.OCSP.enabled" = 1;
      "security.cert_pinning.enforcement_level" = 2;
      "security.remote_settings.crlite_filters.enabled" = true;
      "security.ssl.treat_unsafe_negotiation_as_broken" = true;
      "browser.xul.error_pages.expert_bad_cert" = true;
      "network.http.referer.XOriginTrimmingPolicy" = 2;
      "privacy.userContext.enabled" = true;
      "privacy.userContext.ui.enabled" = true;
      "media.peerconnection.ice.proxy_only_if_behind_proxy" = true;
      "media.peerconnection.ice.default_address_only" = true;
      "dom.disable_window_move_resize" = true;
      "browser.download.start_downloads_in_tmp_dir" = true;
      "browser.helperApps.deleteTempFileOnExit" = true;
      "browser.uitour.enabled" = false;
      "pdfjs.disabled" = false;
      "pdfjs.enableScripting" = false;
      "browser.tabs.searchclipboardfor.middleclick" = false;
      "browser.contentanalysis.enabled" = false;
      "browser.contentanalysis.default_result" = 0;
      "browser.download.useDownloadDir" = false;
      "browser.download.alwaysOpenPanel" = false;
      "browser.download.manager.addToRecentDocs" = false;
      "extensions.enabledScopes" = 5;
      "extensions.postDownloadThirdPartyPrompt" = false;
      "privacy.sanitize.sanitizeOnShutdown" = true;
      "privacy.clearOnShutdown_v2.cache" = true;
      "privacy.clearOnShutdown_v2.historyFormDataAndDownloads" = true;
      "privacy.clearSiteData.cache" = true;
      "privacy.clearSiteData.cookiesAndStorage" = false;
      "privacy.clearSiteData.historyFormDataAndDownloads" = true;
      "privacy.cpd.cache" = true;
      "privacy.clearHistory.cache" = true;
      "privacy.cpd.formdata" = true;
      "privacy.clearHistory.historyFormDataAndDownloads" = true;
      "privacy.cpd.cookies" = false;
      "privacy.cpd.sessions" = true;
      "privacy.cpd.offlineApps" = false;
      "privacy.clearHistory.cookiesAndStorage" = false;
      "privacy.sanitize.timeSpan" = 0;
      "privacy.spoof_english" = 1;
      "browser.display.use_system_colors" = false;
      "widget.non-native-theme.use-theme-accent" = false;
      "browser.link.open_newwindow" = 3;
      "browser.link.open_newwindow.restriction" = 0;
      "extensions.blocklist.enabled" = true;
      "network.http.referer.spoofSource" = false;
      "security.dialog_enable_delay" = 1000;
      "security.tls.version.enable-deprecated" = false;
      "extensions.webcompat-reporter.enabled" = false;
      "extensions.quarantinedDomains.enabled" = true;
      "browser.startup.homepage_override.mstone" = "ignore";
      "browser.urlbar.showSearchTerms.enabled" = false;
      "network.dns.skipTRR-when-parental-control-enabled" = false;
      "browser.messaging-system.whatsNewPanel.enabled" = false;
      "browser.contentanalysis.default_allow" = false;
      "widget.non-native-theme.enabled" = true;

      # Disable dns over https (I have selfhosted dns)
      "network.trr.mode" = 5;

      # Disable new features
      "browser.ml.chat.enabled" = false;
      "media.videocontrols.picture-in-picture.enable-when-switching-tabs.enabled" = false;
      "browser.urlbar.keepPanelOpenDuringImeComposition" = false;

      # Show container when clicking the new tab button
      "privacy.userContext.newTabContainerOnLeftClick.enabled" = true;

      # Zen specific
      # Toolbar
      "browser.proton.toolbar.version" = 3;
      "browser.theme.toolbar-theme" = 0;
      "zen.view.compact.toolbar-flash-popup" = false;
      "zen.view.use-single-toolbar" = false;
      # New tab button
      "zen.tabs.show-newtab-vertical" = false;
      "zen.view.show-newtab-button-top" = false;
      # Accent color
      "zen.theme.accent-color" = "#aac7ff";
      "zen.theme.color-prefs.use-workspace-colors" = false;
      # Compact mode
      "zen.view.compact.hide-tabbar" = true;
      # Enable glance
      "zen.glance.enabled" = true;
      # Enable side panels
      "zen.sidebar.enabled" = true;
      # Url bar behaivor
      "zen.urlbar.behavior" = "floating-on-type";
      # Splitview
      "zen.splitView.change-on-hover" = false;
      # Workspaces
      "zen.workspaces.hide-default-container-indicator" = false;
      "zen.workspaces.individual-pinned-tabs" = true;
      "zen.workspaces.show-icon-strip" = true;
      "zen.workspaces.force-container-workspace" = false;
      "zen.workspaces.container-specific-essentials-enabled" = true;
      # Disale tab unloader
      "zen.tab-unloader.enabled" = false;
      # Pinned tabs
      "zen.pinned-tab-manager.restore-pinned-tabs-to-pinned-url" = false;
      # New tabs
      "browser.newtabpage.activity-stream.showWeather" = false;
      # Search
      "browser.urlbar.suggest.recentsearches" = true; # for my setup this is session-only
      # Don't show welcome screen
      "zen.welcome-screen.seen" = true;
      # Browser state (the way back buttons and things are positioned)
      "browser.uiCustomization.state" = "{\"placements\":{\"widget-overflow-fixed-list\":[],\"unified-extensions-area\":[\"sponsorblocker_ajay_app-browser-action\",\"_d7742d87-e61d-4b78-b8a1-b469842139fa_-browser-action\",\"jid1-mnnxcxisbpnsxq_jetpack-browser-action\",\"jid1-bofifl9vbdl2zq_jetpack-browser-action\",\"jid1-kkzogwgsw3ao4q_jetpack-browser-action\",\"user-agent-switcher_ninetailed_ninja-browser-action\",\"_74145f27-f039-47ce-a470-a662b129930a_-browser-action\",\"_b7f9d2cd-d772-4302-8c3f-eb941af36f76_-browser-action\"],\"nav-bar\":[\"back-button\",\"forward-button\",\"stop-reload-button\",\"vertical-spacer\",\"urlbar-container\",\"downloads-button\",\"_611f1832-736c-4611-a9f0-ff429bd50c6e_-browser-action\",\"_446900e4-71c2-419f-a6a7-df9c091e268b_-browser-action\",\"addon_darkreader_org-browser-action\",\"cookieautodelete_kennydo_com-browser-action\",\"ublock0_raymondhill_net-browser-action\",\"_7a7b1d36-d7a4-481b-92c6-9f5427cb9eb1_-browser-action\",\"unified-extensions-button\"],\"toolbar-menubar\":[\"menubar-items\"],\"TabsToolbar\":[\"tabbrowser-tabs\"],\"vertical-tabs\":[],\"PersonalToolbar\":[\"personal-bookmarks\"],\"zen-sidebar-top-buttons\":[\"new-tab-button\",\"customizableui-special-spring4\",\"home-button\"],\"zen-sidebar-icons-wrapper\":[\"preferences-button\",\"zen-workspaces-button\",\"zen-sidepanel-button\"]},\"seen\":[\"developer-button\",\"cookieautodelete_kennydo_com-browser-action\",\"addon_darkreader_org-browser-action\",\"jid1-bofifl9vbdl2zq_jetpack-browser-action\",\"jid1-kkzogwgsw3ao4q_jetpack-browser-action\",\"jid1-mnnxcxisbpnsxq_jetpack-browser-action\",\"ublock0_raymondhill_net-browser-action\",\"user-agent-switcher_ninetailed_ninja-browser-action\",\"_446900e4-71c2-419f-a6a7-df9c091e268b_-browser-action\",\"_611f1832-736c-4611-a9f0-ff429bd50c6e_-browser-action\",\"_74145f27-f039-47ce-a470-a662b129930a_-browser-action\",\"_7a7b1d36-d7a4-481b-92c6-9f5427cb9eb1_-browser-action\",\"_b7f9d2cd-d772-4302-8c3f-eb941af36f76_-browser-action\",\"_d7742d87-e61d-4b78-b8a1-b469842139fa_-browser-action\",\"sponsorblocker_ajay_app-browser-action\"],\"dirtyAreaCache\":[\"zen-sidebar-icons-wrapper\",\"nav-bar\",\"zen-sidebar-top-buttons\",\"toolbar-menubar\",\"TabsToolbar\",\"vertical-tabs\",\"PersonalToolbar\",\"unified-extensions-area\"],\"currentVersion\":21,\"newElementCount\":5}";
    };

    # Use a stable profile name so we can target it in themes
    home.file = let
      cfgPath = ".zen";
    in {
      "${cfgPath}/profiles.ini".text = ''
        [Profile0]
        Name=default
        IsRelative=1
        Path=${cfg.profileName}.default
        ZenAvatarPath=chrome://browser/content/zen-avatars/avatar-79.svg
        Default=1

        [General]
        StartWithLastProfile=1
        Version=2
      '';

      "${cfgPath}/${cfg.profileName}.default/user.js" = mkIf (cfg.settings != {} || cfg.extraConfig != "") {
        text = ''
          ${concatStrings (mapAttrsToList (name: value: ''
              user_pref("${name}", ${builtins.toJSON value});
            '')
            cfg.settings)}
          ${cfg.extraConfig}
        '';
      };
    };
  };
}
