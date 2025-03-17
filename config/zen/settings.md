# Zen manual settings

Do note all this extensions and settings are tailored to the experience I want
and for my own setup, change accordingly.

## Settings

- Rigth click on the toolbar and hit change theme colors
  - Change the theme color to match the one from my start page
- Go to your search engine (selfhosted searx in my case), add it and set it as default
- In my case add ssl certificates

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
- [Wallabagger](https://addons.mozilla.org/en-US/firefox/addon/wallabagger/) - saves websites to my selfhosted instance of wallabagger

### Extensions Settings

- [Cookie AutoDelete](https://addons.mozilla.org/en-US/firefox/addon/cookie-autodelete/)
  - Load [CAD_CoreSettings](./CAD_CoreSettings.json) in the core settings page
  - Load [Cad_Expressions](CAD_Expressions.json) in the expressions page
- [ClearURLs](https://addons.mozilla.org/en-US/firefox/addon/clearurls/)
  - Load [ClearURLs.conf](./ClearURLs.conf) as settings restore
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
  - Load [DarkReaderSettings](./Dark-Reader-Settings.json)
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
- DarkReader
- Cookie Auto Delete
- UBlockOrigin
- Wallabagger

## Zen Mods

- [Better Active Tab](https://zen-browser.app/mods/d8b79d4a-6cba-4495-9ff6-d6d30b0e94fe/)
- [Better Find Bar](https://zen-browser.app/mods/a6335949-4465-4b71-926c-4a52d34bc9c0/)
  - Enable transparency in settings
- [Bottom Essentials](https://zen-browser.app/mods/477bc813-c333-4747-813e-00e0420ceec0/)
- [Cleaned Url Bar](https://zen-browser.app/mods/a5f6a231-e3c8-4ce8-8a8e-3e93efd6adec/)
- [Colored Container Tab](https://zen-browser.app/mods/3ff55ba7-4690-4f74-96a8-9e4416685e4e/)
- [Compact Tabs Title](https://zen-browser.app/mods/35f24f2c-b211-43e2-9fe4-2c3bc217d9f7/)
- [Download BG](https://zen-browser.app/mods/13696593-837d-464d-adf4-ff13bd0e0545/)
- [Erics Zen UI Tweak Box](https://zen-browser.app/mods/bed8c922-616a-4165-8c86-6822ccf478ad/)
  - Enable: Removes the top padding from the tabs side panel so it's aligned with the page
  - Enable: URL Bar appearance tweaks
  - Enable: New tab button text
- [No Gaps](https://zen-browser.app/mods/bfcc400a-4ecb-4752-bfd2-a68f116a2722/)
- [No Sidebar Scrollbar](https://zen-browser.app/mods/4ab93b88-151c-451b-a1b7-a1e0e28fa7f8/)
- [Only Close On Hover](https://zen-browser.app/mods/4596d8f9-f0b7-4aeb-aa92-851222dc1888/)
- [Private Mode Highlighting](https://zen-browser.app/mods/58649066-2b6f-4a5b-af6d-c3d21d16fc00/)
- [Remove Browser Padding](https://zen-browser.app/mods/680424a8-a818-406b-98c5-7726214e2a9f/)

## Containers

### Create the following Containers

- Google
- Mail
- Work
- Shop
- Social Media
- Finance
- Other
