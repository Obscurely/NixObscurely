import os
import glob

## Load settings applied with :set
config.load_autoconfig()

## General config
c.content.default_encoding = 'utf-8'
c.content.javascript.enabled = False
c.content.local_storage = True
c.content.plugins = True

c.editor.encoding = 'utf-8'

## Security & privacy
c.content.autoplay = False   # don't autoplay videos

## Adblocking
# Use (superior) Brave adblock if available, or fall back to host blocking
c.content.blocking.method = "both"
c.content.blocking.hosts.lists = [
    'https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts',
    'https://pgl.yoyo.org/adservers/serverlist.php?hostformat=hosts&mimetype=plaintext'
    # 'https://www.malwaredomainlist.com/hostslist/hosts.txt',
    # 'http://someonewhocares.org/hosts/hosts',
    # 'http://winhelp2002.mvps.org/hosts.zip',
    # 'http://malwaredomains.lehigh.edu/files/justdomains.zip',
]
# c.content.blocking.whitelist = []

## Options
c.downloads.position = 'bottom'
c.downloads.location.directory = os.path.expanduser("~/Downloads")
c.downloads.location.prompt = False
c.input.insert_mode.auto_leave = True
c.input.insert_mode.auto_load = False
c.input.links_included_in_focus_chain = False
c.new_instance_open_target = 'tab-silent'
c.prompt.filebrowser = False
c.prompt.radius = 0
c.spellcheck.languages = ['en-US']
c.session.lazy_restore = True
c.tabs.show = 'multiple'
c.tabs.title.format = '{audio}{current_title} - {host}'
c.tabs.title.format_pinned = ''
c.window.title_format = '{current_title} - {host} - qutebrowser'
# Set my self hosted searxng instance as default search engine
c.url.default_page = 'https://searx.server.com/preferences?preferences=eJx1VkuT2zYM_jXri2Z3mqSdNgefMtNrO5P0rIFIWEJEElw-bGt_fUFLtqjV5mCN-QEkHgQ-UEHCngNhPPboMIA5GHB9hh6P6J7_-34wrMCUxQFyYsXWG0x4PJAVndYHvk7Hv8FEPFhMA-vjv_98_3GIcMKIENRw_O2QBrR4jFS2HgLGbFJs2bUOL22CbtmumVoRsjljODLI8oVDf5i3tTFN4oWGMB5An8Ep1O1iYN7-mjFMLbk2URLNGSR3IkdJtqvAxhx_hCyGKEJnZD-6npxEDn5sLIXAoW1PZDA-ff5WTqYzNhTbdsnMDU2k2vYWe9HqyPW1vKwbCUs2le8NSV1WIybZlco6aer71Y5S6jmd2_ZMGrkA7NFJBiJWZib0tRUMfCHdtiyJDbK-0EgaEtQ6WoyWX8_NfEx1XJKoJ6y1P10r8cmQGkMNBMQm8ildIGCjKaBKLMmeIzoFciNBnRY5mLJYtDmSKmvqJeMQU21TscYOQ78c0zP3Bps5D1U-FtwbmBrwPq6pqyWWz4SbbZ61xrD6MEAXoHwWe2R1t6aQHFSbyclf4hw_xu5H_qQ48HrGKGmDWDloSEyGqSkxR_pAwKdGseul6uvrMdzFhC8hLp7Cm5kCqcqw83aRuQlgPbfUDsj1-NzJHUIidrIrKkLpl0UuUq5c8SBO9xTv9ekpCCV0MK0qc5uV62rK53HtYKEEcgciWnDSHk1UAxsIteGYpHN8IYyqABKPEyeWHI7gVnMTDMy13g3YdpUGMpPlEmB1RWeyyNX6Qt206V6DV3A60KZTSvd0zGN8D75mTvgejJyD2qGlYSlNO5indzFrUumN3RbLGt1aRhHfHNhawfJPxLFGHJxLba9AyN3Uo72XjEcMKXdYJcOiJhATozTK5YJdJQrZCh_WieMrjexe5Mbj5NhNFiv_nr798fTXZ744GpufT99-f_r69W0aofFs4kgyTrbMZIWBNxwZxPka8JgKWZci-wW8p7BauFbGQcp_y-xFbsjla1NcuTdUuNK5Ls9OqkKB9WuHFW1fMrZj950rN3RHWzJvYgx4qs2oHIL83ZSJRnyraUrjmaSNpF0qE1r3jcbbKJtbutrPMlxCM-RuCW4l_s3ISNIuTjJRXeRJBy5j5MGn6FLpvJmOZYpCty5WAzPt1ocvRLzLzIJvOnfBPuCIYTn3ZuTteeHI1T1LV2U46zVXwjdSb3dCv5NfmYQR0474YpIxliyUWwZfakiXBlmV_CBs5B7S3EnLbOSTv1fQ60XuqE7BDdhGOkO7pMzwrl7Eb01yZGRFYJpbt97IwBPce-OhLCQkBbtNhlCsGllo4WT4ci_0OOYuu5TvFJ09hhwfKZPHFmkZ5VKVqZoJ2UUZqnGoXyCc3_HJA6lbZpMAAUq53i7xQQhs5sHhB1hRKwRj5UXRpAAuGhlA1evm05cvf15X5y4ctDDPIl8fc95k6fl4LMm6viyrl4FjEjZFeVlKSPMs2igwtPPD8xLknfggkF-cVpIyL3YHLZckBaTmN_Uk71MjL6UPNM1JHqon3kkk_NLNbQ5GPLLlNnc6MuRaKdQRp3iQCSp1ffwfe21ydQ==&save=1'
c.url.searchengines = { 'DEFAULT': 'https://searx.server.com/?preferences=eJx1VkuT2zYM_jXri2Z3mqSdNgefMtNrO5P0rIFIWEJEElw-bGt_fUFLtqjV5mCN-QEkHgQ-UEHCngNhPPboMIA5GHB9hh6P6J7_-34wrMCUxQFyYsXWG0x4PJAVndYHvk7Hv8FEPFhMA-vjv_98_3GIcMKIENRw_O2QBrR4jFS2HgLGbFJs2bUOL22CbtmumVoRsjljODLI8oVDf5i3tTFN4oWGMB5An8Ep1O1iYN7-mjFMLbk2URLNGSR3IkdJtqvAxhx_hCyGKEJnZD-6npxEDn5sLIXAoW1PZDA-ff5WTqYzNhTbdsnMDU2k2vYWe9HqyPW1vKwbCUs2le8NSV1WIybZlco6aer71Y5S6jmd2_ZMGrkA7NFJBiJWZib0tRUMfCHdtiyJDbK-0EgaEtQ6WoyWX8_NfEx1XJKoJ6y1P10r8cmQGkMNBMQm8ildIGCjKaBKLMmeIzoFciNBnRY5mLJYtDmSKmvqJeMQU21TscYOQ78c0zP3Bps5D1U-FtwbmBrwPq6pqyWWz4SbbZ61xrD6MEAXoHwWe2R1t6aQHFSbyclf4hw_xu5H_qQ48HrGKGmDWDloSEyGqSkxR_pAwKdGseul6uvrMdzFhC8hLp7Cm5kCqcqw83aRuQlgPbfUDsj1-NzJHUIidrIrKkLpl0UuUq5c8SBO9xTv9ekpCCV0MK0qc5uV62rK53HtYKEEcgciWnDSHk1UAxsIteGYpHN8IYyqABKPEyeWHI7gVnMTDMy13g3YdpUGMpPlEmB1RWeyyNX6Qt206V6DV3A60KZTSvd0zGN8D75mTvgejJyD2qGlYSlNO5indzFrUumN3RbLGt1aRhHfHNhawfJPxLFGHJxLba9AyN3Uo72XjEcMKXdYJcOiJhATozTK5YJdJQrZCh_WieMrjexe5Mbj5NhNFiv_nr798fTXZ744GpufT99-f_r69W0aofFs4kgyTrbMZIWBNxwZxPka8JgKWZci-wW8p7BauFbGQcp_y-xFbsjla1NcuTdUuNK5Ls9OqkKB9WuHFW1fMrZj950rN3RHWzJvYgx4qs2oHIL83ZSJRnyraUrjmaSNpF0qE1r3jcbbKJtbutrPMlxCM-RuCW4l_s3ISNIuTjJRXeRJBy5j5MGn6FLpvJmOZYpCty5WAzPt1ocvRLzLzIJvOnfBPuCIYTn3ZuTteeHI1T1LV2U46zVXwjdSb3dCv5NfmYQR0474YpIxliyUWwZfakiXBlmV_CBs5B7S3EnLbOSTv1fQ60XuqE7BDdhGOkO7pMzwrl7Eb01yZGRFYJpbt97IwBPce-OhLCQkBbtNhlCsGllo4WT4ci_0OOYuu5TvFJ09hhwfKZPHFmkZ5VKVqZoJ2UUZqnGoXyCc3_HJA6lbZpMAAUq53i7xQQhs5sHhB1hRKwRj5UXRpAAuGhlA1evm05cvf15X5y4ctDDPIl8fc95k6fl4LMm6viyrl4FjEjZFeVlKSPMs2igwtPPD8xLknfggkF-cVpIyL3YHLZckBaTmN_Uk71MjL6UPNM1JHqon3kkk_NLNbQ5GPLLlNnc6MuRaKdQRp3iQCSp1ffwfe21ydQ==&q={}' }
c.url.start_pages = 'https://searx.server.com/preferences?preferences=eJx1VkuT2zYM_jXri2Z3mqSdNgefMtNrO5P0rIFIWEJEElw-bGt_fUFLtqjV5mCN-QEkHgQ-UEHCngNhPPboMIA5GHB9hh6P6J7_-34wrMCUxQFyYsXWG0x4PJAVndYHvk7Hv8FEPFhMA-vjv_98_3GIcMKIENRw_O2QBrR4jFS2HgLGbFJs2bUOL22CbtmumVoRsjljODLI8oVDf5i3tTFN4oWGMB5An8Ep1O1iYN7-mjFMLbk2URLNGSR3IkdJtqvAxhx_hCyGKEJnZD-6npxEDn5sLIXAoW1PZDA-ff5WTqYzNhTbdsnMDU2k2vYWe9HqyPW1vKwbCUs2le8NSV1WIybZlco6aer71Y5S6jmd2_ZMGrkA7NFJBiJWZib0tRUMfCHdtiyJDbK-0EgaEtQ6WoyWX8_NfEx1XJKoJ6y1P10r8cmQGkMNBMQm8ildIGCjKaBKLMmeIzoFciNBnRY5mLJYtDmSKmvqJeMQU21TscYOQ78c0zP3Bps5D1U-FtwbmBrwPq6pqyWWz4SbbZ61xrD6MEAXoHwWe2R1t6aQHFSbyclf4hw_xu5H_qQ48HrGKGmDWDloSEyGqSkxR_pAwKdGseul6uvrMdzFhC8hLp7Cm5kCqcqw83aRuQlgPbfUDsj1-NzJHUIidrIrKkLpl0UuUq5c8SBO9xTv9ekpCCV0MK0qc5uV62rK53HtYKEEcgciWnDSHk1UAxsIteGYpHN8IYyqABKPEyeWHI7gVnMTDMy13g3YdpUGMpPlEmB1RWeyyNX6Qt206V6DV3A60KZTSvd0zGN8D75mTvgejJyD2qGlYSlNO5indzFrUumN3RbLGt1aRhHfHNhawfJPxLFGHJxLba9AyN3Uo72XjEcMKXdYJcOiJhATozTK5YJdJQrZCh_WieMrjexe5Mbj5NhNFiv_nr798fTXZ744GpufT99-f_r69W0aofFs4kgyTrbMZIWBNxwZxPka8JgKWZci-wW8p7BauFbGQcp_y-xFbsjla1NcuTdUuNK5Ls9OqkKB9WuHFW1fMrZj950rN3RHWzJvYgx4qs2oHIL83ZSJRnyraUrjmaSNpF0qE1r3jcbbKJtbutrPMlxCM-RuCW4l_s3ISNIuTjJRXeRJBy5j5MGn6FLpvJmOZYpCty5WAzPt1ocvRLzLzIJvOnfBPuCIYTn3ZuTteeHI1T1LV2U46zVXwjdSb3dCv5NfmYQR0474YpIxliyUWwZfakiXBlmV_CBs5B7S3EnLbOSTv1fQ60XuqE7BDdhGOkO7pMzwrl7Eb01yZGRFYJpbt97IwBPce-OhLCQkBbtNhlCsGllo4WT4ci_0OOYuu5TvFJ09hhwfKZPHFmkZ5VKVqZoJ2UUZqnGoXyCc3_HJA6lbZpMAAUq53i7xQQhs5sHhB1hRKwRj5UXRpAAuGhlA1evm05cvf15X5y4ctDDPIl8fc95k6fl4LMm6viyrl4FjEjZFeVlKSPMs2igwtPPD8xLknfggkF-cVpIyL3YHLZckBaTmN_Uk71MjL6UPNM1JHqon3kkk_NLNbQ5GPLLlNnc6MuRaKdQRp3iQCSp1ffwfe21ydQ==&save=1'
# This will load pages even if their ssl certificate is invalid or expired.
# I have this options because I use a reverse proxy on a dns rewrite for my home server (so I don't have to pay anything)
# If you don't know what this means or are not exprienced enough browsing, please disable this as it poses a very high security risk.
c.content.tls.certificate_errors = 'load-insecurely'
c.content.prefers_reduced_motion = False # I don't like animations
c.input.media_keys = True # Should be enabled by default, but just in case
c.scrolling.smooth = False # Should be disabled by default, but just because I hate smooth scrolling... (except half page scroll in neovim)

# some privacy related options
c.content.cookies.accept = 'no-3rdparty' # blocking 3rdparty cookies doesn't generally block anything
c.content.geolocation = False
c.content.headers.do_not_track = True

#
## Keybindings

# Universal Emacsien C-g alias for Escape
config.bind('<Ctrl-g>', 'clear-keychain ;; search ;; fullscreen --leave')
for mode in ['caret', 'command', 'hint', 'insert', 'passthrough', 'prompt', 'register']:
    config.bind('<Ctrl-g>', 'mode-leave', mode=mode)

# ...
config.bind('zz', 'close')
config.bind('tm', 'tab-mute')
config.bind('wi', 'devtools bottom')
config.bind(';;', 'hint inputs --first')  # easier to reach than ;t
config.bind(';e', 'hint inputs --first ;; fake-key <Ctrl+a> ;; :spawn nohup bspc rule -a "Emacs:*" -o state=floating sticky=on && emacsclient --eval "(emacs-everywhere)"')
# ;v already bound to 'spawn mpv {url}'
config.bind(';V', 'hint links spawn mpv {hint-url}')

# Use external editor
c.editor.command = ['emacsclient', '-c', '-F', '((name . "qutebrowser-editor"))', '+{line}:{column}', '{}']
# Though we set it, I use the more specialzied emacs-everywhere instead
config.bind('<Ctrl+E>',    'edit-text', mode='insert')
config.bind('<Ctrl+E>',    'hint inputs --first ;; edit-text', mode='normal')
config.bind('<Shift+Ins>', 'fake-key <Ctrl+V>', mode='insert')

# Vaultwarden integration
config.bind(";pp", 'spawn -u qute-bwmenu')
config.bind(";pu", 'spawn -u qute-bwmenu --field username')
config.bind(";ps", 'spawn -u qute-bwmenu --field password')
config.bind(";po", 'spawn -u qute-bwmenu --field otp')
config.bind(";pl", 'spawn -u qute-bwmenu --last')

## Ex-commands


## Bindings for normal mode
# config.bind("'", 'enter-mode jump_mark')
# config.bind('+', 'zoom-in')
# config.bind('-', 'zoom-out')
# config.bind('.', 'repeat-command')
# config.bind('/', 'set-cmd-text /')
# config.bind(':', 'set-cmd-text :')
# config.bind(';I', 'hint images tab')
# config.bind(';O', 'hint links fill :open -t -r {hint-url}')
# config.bind(';R', 'hint --rapid links window')
# config.bind(';Y', 'hint links yank-primary')
# config.bind(';b', 'hint all tab-bg')
# config.bind(';d', 'hint links download')
# config.bind(';f', 'hint all tab-fg')
# config.bind(';h', 'hint all hover')
# config.bind(';i', 'hint images')
# config.bind(';o', 'hint links fill :open {hint-url}')
# config.bind(';r', 'hint --rapid links tab-bg')
# config.bind(';t', 'hint inputs')
# config.bind(';y', 'hint links yank')
# config.bind('<Alt-1>', 'tab-focus 1')
# config.bind('<Alt-2>', 'tab-focus 2')
# config.bind('<Alt-3>', 'tab-focus 3')
# config.bind('<Alt-4>', 'tab-focus 4')
# config.bind('<Alt-5>', 'tab-focus 5')
# config.bind('<Alt-6>', 'tab-focus 6')
# config.bind('<Alt-7>', 'tab-focus 7')
# config.bind('<Alt-8>', 'tab-focus 8')
# config.bind('<Alt-9>', 'tab-focus -1')
# config.bind('<Ctrl-A>', 'navigate increment')
# config.bind('<Ctrl-Alt-p>', 'print')
# config.bind('<Ctrl-B>', 'scroll-page 0 -1')
# config.bind('<Ctrl-D>', 'scroll-page 0 0.5')
# config.bind('<Ctrl-F5>', 'reload -f')
# config.bind('<Ctrl-F>', 'scroll-page 0 1')
# config.bind('<Ctrl-N>', 'open -w')
# config.bind('<Ctrl-PgDown>', 'tab-next')
# config.bind('<Ctrl-PgUp>', 'tab-prev')
# config.bind('<Ctrl-Q>', 'quit')
# config.bind('<Ctrl-Return>', 'follow-selected -t')
# config.bind('<Ctrl-Shift-N>', 'open -p')
# config.bind('<Ctrl-Shift-T>', 'undo')
# config.bind('<Ctrl-Shift-W>', 'close')
# config.bind('<Ctrl-T>', 'open -t')
# config.bind('<Ctrl-Tab>', 'tab-focus last')
# config.bind('<Ctrl-U>', 'scroll-page 0 -0.5')
# config.bind('<Ctrl-V>', 'enter-mode passthrough')
# config.bind('<Ctrl-W>', 'tab-close')
# config.bind('<Ctrl-X>', 'navigate decrement')
# config.bind('<Ctrl-^>', 'tab-focus last')
# config.bind('<Ctrl-h>', 'home')
# config.bind('<Ctrl-p>', 'tab-pin')
# config.bind('<Ctrl-s>', 'stop')
# config.bind('<Escape>', 'clear-keychain ;; search ;; fullscreen --leave')
# config.bind('<F11>', 'fullscreen')
# config.bind('<F5>', 'reload')
# config.bind('<Return>', 'follow-selected')
# config.bind('<back>', 'back')
# config.bind('<forward>', 'forward')
# config.bind('=', 'zoom')
# config.bind('?', 'set-cmd-text ?')
# config.bind('@', 'run-macro')
# config.bind('B', 'set-cmd-text -s :quickmark-load -t')
# config.bind('D', 'tab-close -o')
# config.bind('F', 'hint all tab')
# config.bind('G', 'scroll-to-perc')
# config.bind('H', 'back')
# config.bind('J', 'tab-next')
# config.bind('K', 'tab-prev')
# config.bind('L', 'forward')
config.bind('Q', 'bookmark-add')
# config.bind('N', 'search-prev')
# config.bind('O', 'set-cmd-text -s :open -t')
# config.bind('PP', 'open -t -- {primary}')
# config.bind('Pp', 'open -t -- {clipboard}')
# config.bind('R', 'reload -f')
# config.bind('Sb', 'open qute://bookmarks#bookmarks')
# config.bind('Sh', 'open qute://history')
config.bind('M', 'open qute://bookmarks')
# config.bind('Ss', 'open qute://settings')
# config.bind('T', 'tab-focus')
# config.bind('ZQ', 'quit')
# config.bind('ZZ', 'quit --save')
# config.bind('[[', 'navigate prev')
# config.bind(']]', 'navigate next')
# config.bind('`', 'enter-mode set_mark')
# config.bind('ad', 'download-cancel')
# config.bind('b', 'set-cmd-text -s :quickmark-load')
# config.bind('cd', 'download-clear')
# config.bind('co', 'tab-only')
# config.bind('d', 'tab-close')
# config.bind('f', 'hint')
# config.bind('g$', 'tab-focus -1')
# config.bind('g0', 'tab-focus 1')
# config.bind('gB', 'set-cmd-text -s :bookmark-load -t')
# config.bind('gC', 'tab-clone')
# config.bind('gO', 'set-cmd-text :open -t -r {url:pretty}')
# config.bind('gU', 'navigate up -t')
# config.bind('g^', 'tab-focus 1')
# config.bind('ga', 'open -t')
# config.bind('gb', 'set-cmd-text -s :bookmark-load')
# config.bind('gd', 'download')
# config.bind('gf', 'view-source')
# config.bind('gg', 'scroll-to-perc 0')
# config.bind('gl', 'tab-move -')
# config.bind('gm', 'tab-move')
# config.bind('go', 'set-cmd-text :open {url:pretty}')
# config.bind('gr', 'tab-move +')
# config.bind('gt', 'set-cmd-text -s :buffer')
# config.bind('gu', 'navigate up')
# config.bind('h', 'scroll left')
# config.bind('i', 'enter-mode insert')
# config.bind('j', 'scroll down')
# config.bind('k', 'scroll up')
# config.bind('l', 'scroll right')
config.bind('m', 'quickmark-save')
# config.bind('n', 'search-next')
# config.bind('o', 'set-cmd-text -s :open')
# config.bind('pP', 'open -- {primary}')
# config.bind('pp', 'open -- {clipboard}')
# config.bind('q', 'record-macro')
# config.bind('r', 'reload')
# config.bind('sf', 'save')
# config.bind('sk', 'set-cmd-text -s :bind')
# config.bind('sl', 'set-cmd-text -s :set -t')
# config.bind('ss', 'set-cmd-text -s :set')
# config.bind('th', 'back -t')
# config.bind('tl', 'forward -t')
# config.bind('u', 'undo')
# config.bind('v', 'enter-mode caret')
# config.bind('wB', 'set-cmd-text -s :bookmark-load -w')
# config.bind('wO', 'set-cmd-text :open -w {url:pretty}')
# config.bind('wP', 'open -w -- {primary}')
# config.bind('wb', 'set-cmd-text -s :quickmark-load -w')
# config.bind('wf', 'hint all window')
# config.bind('wh', 'back -w')
# config.bind('wi', 'inspector')
# config.bind('wl', 'forward -w')
# config.bind('wo', 'set-cmd-text -s :open -w')
# config.bind('wp', 'open -w -- {clipboard}')
# config.bind('xO', 'set-cmd-text :open -b -r {url:pretty}')
# config.bind('xb', 'config-cycle statusbar.hide')
# config.bind('xo', 'set-cmd-text -s :open -b')
# config.bind('xt', 'config-cycle tabs.show always switching')
# config.bind('xx', 'config-cycle statusbar.hide ;; config-cycle tabs.show always switching')
# config.bind('yD', 'yank domain -s')
# config.bind('yP', 'yank pretty-url -s')
# config.bind('yT', 'yank title -s')
# config.bind('yY', 'yank -s')
# config.bind('yd', 'yank domain')
# config.bind('yp', 'yank pretty-url')
# config.bind('yt', 'yank title')
# config.bind('yy', 'yank')
# config.bind('{{', 'navigate prev -t')
# config.bind('}}', 'navigate next -t')

## Bindings for caret mode
# config.bind('$', 'move-to-end-of-line', mode='caret')
# config.bind('0', 'move-to-start-of-line', mode='caret')
# config.bind('<Ctrl-Space>', 'drop-selection', mode='caret')
# config.bind('<Escape>', 'leave-mode', mode='caret')
# config.bind('<Return>', 'yank selection', mode='caret')
# config.bind('<Space>', 'toggle-selection', mode='caret')
# config.bind('G', 'move-to-end-of-document', mode='caret')
# config.bind('H', 'scroll left', mode='caret')
# config.bind('J', 'scroll down', mode='caret')
# config.bind('K', 'scroll up', mode='caret')
# config.bind('L', 'scroll right', mode='caret')
# config.bind('Y', 'yank selection -s', mode='caret')
# config.bind('[', 'move-to-start-of-prev-block', mode='caret')
# config.bind(']', 'move-to-start-of-next-block', mode='caret')
# config.bind('b', 'move-to-prev-word', mode='caret')
# config.bind('c', 'enter-mode normal', mode='caret')
# config.bind('e', 'move-to-end-of-word', mode='caret')
# config.bind('gg', 'move-to-start-of-document', mode='caret')
# config.bind('h', 'move-to-prev-char', mode='caret')
# config.bind('j', 'move-to-next-line', mode='caret')
# config.bind('k', 'move-to-prev-line', mode='caret')
# config.bind('l', 'move-to-next-char', mode='caret')
# config.bind('v', 'toggle-selection', mode='caret')
# config.bind('w', 'move-to-next-word', mode='caret')
# config.bind('y', 'yank selection', mode='caret')
# config.bind('{', 'move-to-end-of-prev-block', mode='caret')
# config.bind('}', 'move-to-end-of-next-block', mode='caret')

## Bindings for command mode
# config.bind('<Alt-B>', 'rl-backward-word', mode='command')
# config.bind('<Alt-Backspace>', 'rl-backward-kill-word', mode='command')
# config.bind('<Alt-D>', 'rl-kill-word', mode='command')
# config.bind('<Alt-F>', 'rl-forward-word', mode='command')
# config.bind('<Ctrl-?>', 'rl-delete-char', mode='command')
# config.bind('<Ctrl-A>', 'rl-beginning-of-line', mode='command')
# config.bind('<Ctrl-B>', 'rl-backward-char', mode='command')
# config.bind('<Ctrl-D>', 'completion-item-del', mode='command')
# config.bind('<Ctrl-E>', 'rl-end-of-line', mode='command')
# config.bind('<Ctrl-F>', 'rl-forward-char', mode='command')
config.bind('<Ctrl-B>', 'rl-backward-word', mode='command')
config.bind('<Ctrl-F>', 'rl-forward-word', mode='command')
# config.bind('<Ctrl-H>', 'rl-backward-delete-char', mode='command')
# config.bind('<Ctrl-K>', 'rl-kill-line', mode='command')
# config.bind('<Ctrl-N>', 'command-history-next', mode='command')
# config.bind('<Ctrl-P>', 'command-history-prev', mode='command')
# config.bind('<Ctrl-Shift-Tab>', 'completion-item-focus prev-category', mode='command')
# config.bind('<Ctrl-Tab>', 'completion-item-focus next-category', mode='command')
# config.bind('<Ctrl-U>', 'rl-unix-line-discard', mode='command')
# config.bind('<Ctrl-W>', 'rl-unix-word-rubout', mode='command')
# config.bind('<Ctrl-Y>', 'rl-yank', mode='command')
# config.bind('<Down>', 'command-history-next', mode='command')
# config.bind('<Escape>', 'leave-mode', mode='command')
# config.bind('<Return>', 'command-accept', mode='command')
# config.bind('<Shift-Delete>', 'completion-item-del', mode='command')
# config.bind('<Shift-Tab>', 'completion-item-focus prev', mode='command')
# config.bind('<Tab>', 'completion-item-focus next', mode='command')
# config.bind('<Up>', 'command-history-prev', mode='command')

## Bindings for hint mode
# config.bind('<Ctrl-B>', 'hint all tab-bg', mode='hint')
# config.bind('<Ctrl-F>', 'hint links', mode='hint')
# config.bind('<Ctrl-R>', 'hint --rapid links tab-bg', mode='hint')
# config.bind('<Escape>', 'mode-leave', mode='hint')
# config.bind('<Return>', 'follow-hint', mode='hint')

## Bindings for insert mode
# config.bind('<Ctrl-E>', 'open-editor', mode='insert')
# config.bind('<Escape>', 'leave-mode', mode='insert')
# config.bind('<Shift-Ins>', 'insert-text {primary}', mode='insert')

## Bindings for passthrough mode
# config.bind('<Ctrl-V>', 'leave-mode', mode='passthrough')

## Bindings for prompt mode
# config.bind('<Alt-B>', 'rl-backward-word', mode='prompt')
# config.bind('<Alt-Backspace>', 'rl-backward-kill-word', mode='prompt')
# config.bind('<Alt-D>', 'rl-kill-word', mode='prompt')
# config.bind('<Alt-F>', 'rl-forward-word', mode='prompt')
# config.bind('<Ctrl-?>', 'rl-delete-char', mode='prompt')
# config.bind('<Ctrl-A>', 'rl-beginning-of-line', mode='prompt')
# config.bind('<Ctrl-B>', 'rl-backward-char', mode='prompt')
# config.bind('<Ctrl-E>', 'rl-end-of-line', mode='prompt')
# config.bind('<Ctrl-F>', 'rl-forward-char', mode='prompt')
config.bind('<Ctrl-B>', 'rl-backward-word', mode='prompt')
config.bind('<Ctrl-F>', 'rl-forward-word', mode='prompt')
# config.bind('<Ctrl-H>', 'rl-backward-delete-char', mode='prompt')
# config.bind('<Ctrl-K>', 'rl-kill-line', mode='prompt')
# config.bind('<Ctrl-U>', 'rl-unix-line-discard', mode='prompt')
# config.bind('<Ctrl-W>', 'rl-unix-word-rubout', mode='prompt')
# config.bind('<Ctrl-X>', 'prompt-open-download', mode='prompt')
# config.bind('<Ctrl-Y>', 'rl-yank', mode='prompt')
# config.bind('<Down>', 'prompt-item-focus next', mode='prompt')
# config.bind('<Escape>', 'leave-mode', mode='prompt')
# config.bind('<Return>', 'prompt-accept', mode='prompt')
# config.bind('<Shift-Tab>', 'prompt-item-focus prev', mode='prompt')
# config.bind('<Tab>', 'prompt-item-focus next', mode='prompt')
# config.bind('<Up>', 'prompt-item-focus prev', mode='prompt')
# config.bind('n', 'prompt-accept no', mode='prompt')
# config.bind('y', 'prompt-accept yes', mode='prompt')

## Bindings for register mode
# config.bind('<Escape>', 'leave-mode', mode='register')

## Per-domain settings
c.content.user_stylesheets = glob.glob(os.path.expanduser('~/.local/share/qutebrowser/userstyles.css'))


## Load theme
for path in glob.glob(os.path.expanduser('~/.config/qutebrowser/extra/*.py')):
    config.source(path)
