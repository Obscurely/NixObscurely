{lib, ...}:
with builtins;
with lib; {
  ## Location config
  time.timeZone = mkDefault "Europe/Bucharest";
  i18n.defaultLocale = mkDefault "en_US.UTF-8";
  # Generate US-English (language/messages) + en_DK (ISO formats) + the C fallback.
  i18n.supportedLocales = [
    "C.UTF-8/UTF-8"
    "en_US.UTF-8/UTF-8"
    "en_DK.UTF-8/UTF-8"
  ];
  # Language/messages stay US-English, but the *format* categories come from en_DK — the de-facto
  # ISO locale: dates as 2026-01-01, 24h time, Monday-first weeks, metric units, A4 paper. Numbers
  # and money stay en_US so decimals use a period (1,234.56) and currency is USD ($).
  i18n.extraLocaleSettings = {
    LC_TIME = "en_DK.UTF-8"; # ISO 8601 date, 24h time, Monday-first weeks
    LC_MEASUREMENT = "en_DK.UTF-8"; # metric
    LC_PAPER = "en_DK.UTF-8"; # A4
    LC_NUMERIC = "en_US.UTF-8"; # period decimal separator
    LC_MONETARY = "en_US.UTF-8"; # USD
  };
  # fake location for the sake of it
  location = {
    latitude = 43.70011;
    longitude = -79.4163;
  };
}
