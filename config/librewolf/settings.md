# Librewolf manual settings

Do note all this extensions and settings are tailored to the experience I want
and for my own setup, change accordingly.

## Theme

Some settings that are needed for the theme to be displayed properly

- Right click on the toolbar and hit customize toolbar
  - Enable the titler bar (left corner down)
  - Remove the flexible space by the refresh button
  - Click on manage themes (left corner down) and disable all themes, so that
    only system - auto remains
- Right click on the toolbar, go to bookmarks toolbar and hit never show (the
  bookmarks can still be seen by pressing ctrl + b)

## Extensions

### Extensions List

- [Bitwarden](https://addons.mozilla.org/en-US/firefox/addon/bitwarden-password-manager/) -
  Use passwords from my self-hosted vaultwarden instance
- [ClearURLs](https://addons.mozilla.org/en-US/firefox/addon/clearurls/) -
  remove telemetry url params
- [Cookie AutoDelete](https://addons.mozilla.org/en-US/firefox/addon/cookie-autodelete/) -
  auto delete cookies in un-containered tabs
- [Dark Reader](https://addons.mozilla.org/en-US/firefox/addon/darkreader/) -
  dark mode across the board
- [Decentraleyes](https://addons.mozilla.org/en-US/firefox/addon/decentraleyes/) -
  prevents a lot of request from reaching networks like google
- [I don't care about cookies](https://addons.mozilla.org/en-US/firefox/addon/i-dont-care-about-cookies/) -
  get rid of cookies warnings
- [LeechBlock NG](https://addons.mozilla.org/en-US/firefox/addon/leechblock-ng/) -
  block access to certain websites at certain times and limit the time allowes
  on them
- [Linkace Bookmarklet](https://addons.mozilla.org/en-US/firefox/addon/linkace-bookmarklet/) -
  saves bookmarks on my self-hosted linkace instance
- [Privacy Badger](https://addons.mozilla.org/en-US/firefox/addon/privacy-badger17/) -
  automatically learns to block invisible trackers
- [Privacy Redirect](https://addons.mozilla.org/en-US/firefox/addon/privacy-redirect/) -
  redirect youtube urls to my self-hosted instance of piped
- [SponsorBlock](https://addons.mozilla.org/en-US/firefox/addon/sponsorblock/) -
  skip sponsors on youtube itself, in case I ever need to go on actual youtube
- [uBlock Origin](https://addons.mozilla.org/en-US/firefox/addon/ublock-origin/) -
  the lord and savior, the web protector, the sanity keeper, the greatest
  extension to be invented
- [User-Agent Switcher](https://addons.mozilla.org/en-US/firefox/addon/uaswitcher/) -
  pretend to be another platform and web browser
- [Vimium-FF](https://addons.mozilla.org/en-US/firefox/addon/vimium-ff/) - vim
  bindings browser

### Extensions Settings

- [Cookie AutoDelete](https://addons.mozilla.org/en-US/firefox/addon/cookie-autodelete/)
  - Load [CAD_CoreSettings](./CAD_CoreSettings.json) in the core settings page
  - Load [Cad_Expressions](CAD_Expressions.json) in the expressions page
- [ClearURLs](https://addons.mozilla.org/en-US/firefox/addon/clearurls/)
  - Load [ClearURLs.conf](./ClearURLs.conf) as settings restore
- [LeechBlock NG](https://addons.mozilla.org/en-US/firefox/addon/leechblock-ng/)
  - Load [LeeckBlockOptions.txt](./LeechBlockOptions.txt) as settings restore
- [uBlock Origin](https://addons.mozilla.org/en-US/firefox/addon/ublock-origin/)
  - Load [my-ublock](./my-ublock-backup.txt) as settings restore
- [Privacy Badger](https://addons.mozilla.org/en-US/firefox/addon/privacy-badger17/)
  - Load [PrivacyBadger_user_data](./PrivacyBadger_user_data) as settings
    restore
- [SponsorBlock](https://addons.mozilla.org/en-US/firefox/addon/sponsorblock/)
  - Load [SponsorBlockConfig](./SponsorBlockConfig.json) as settings restore
- [Vimium-FF](https://addons.mozilla.org/en-US/firefox/addon/vimium-ff/)
  - Load [vimium_custom_keybinds](./vimium_options.json) as settings restore
- [DarkReader](https://addons.mozilla.org/en-US/firefox/addon/darkreader/)
  - Set contrast to +5
- [Decentraleyes](https://addons.mozilla.org/en-US/firefox/addon/decentraleyes/)
  - Enable Display injection counts on icon, Disable link prefetching, Strip
    metadata from allowed requests
- [LinkAce](https://addons.mozilla.org/en-US/firefox/addon/linkace-bookmarklet/)
  - Set your linkace instance (in my case
    [https://linkace.server.com](https://linkace.server.com))
- [Privacy Redirect](https://addons.mozilla.org/en-US/firefox/addon/privacy-redirect/)
  - Enable invidious and set url (in my case
    [https://piped.server.com](https://piped.server.com))

### Extension pins (in order)

- LinkAce
- Bitwarder
- User-Agent Switcher
- DarkReader
- Cookier Auto Delete
- UBlockOrigin

## Containers

### Create the following Containers

- Google
- Mail
- Work
- Shop
- Social Media
- Banking
- Other
