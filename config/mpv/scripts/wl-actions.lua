-- ~/.config/mpv/scripts/wl-actions.lua
-- Playback behavior + menu actions for the `yt` workflow. Driven by --script-opts=yt-mode=<wl|keep>
-- (yt wl / yt gold set it; music leaves it unset -> normal autoplay). See youtube-phase3-extras spec.
--   yt-mode=wl   : single video (no autoplay); on eof -> record watched + stay on last frame; delete the
--                  file on mpv close (watch-later) so seek-back / gold / comments work the whole session
--   yt-mode=keep : single video (no autoplay), never delete (gold)
--   unset        : nothing (autoload builds the folder playlist and plays through — music)
-- Menu actions (uosc): mark-watched (delete+record), promote-gold (hardlink), open-browser.
local mp = require 'mp'
local options = require 'mp.options'

local WL = '/data/youtube/watchlater/'
local GOLD = '/data/youtube/gold/'
local STATE = '/data/youtube/.state/'
local o = {mode = ''}
options.read_options(o, 'yt') -- reads --script-opts=yt-mode=...
local current = nil

local function under(p, d) return p ~= nil and p:sub(1, #d) == d end
local function basename(p) return p and p:match('[^/]+$') end
local function idof(p) return p and p:match('%[([%w_%-]+)%]%.%w+$') end

local function record_watched(p)
    local id = idof(p)
    if not id then return end
    mp.command_native({name = 'subprocess', playback_only = false, args = {
        'sh', '-c', 'mkdir -p "$1"; printf "%s\\n" "$2" >> "$1/watched"', 'sh', STATE, id,
    }})
end

local function delete(p)
    if p then os.remove(p) end
end

local finished = false

mp.register_event('file-loaded', function()
    current = mp.get_property('path')
    finished = false
    if o.mode == 'wl' or o.mode == 'keep' then
        mp.commandv('playlist-clear')  -- single video: no autoplay to siblings
        -- NOTE: we deliberately keep the global keep-open=yes (do NOT force it to 'no'). At eof mpv then
        -- rests on the last frame instead of quitting, so the uosc menu (Comments / Open in browser) is
        -- still reachable. The end is detected via the eof-reached property below (end-file's eof reason
        -- does not fire while keep-open=yes).
    end
end)

-- Watch-later: mark it watched the moment it plays through, but KEEP the file — mpv rests on the last frame
-- (keep-open=yes) so you can seek back, view comments, or Promote-to-gold. The file is removed on shutdown
-- (below), i.e. when you actually close mpv — it survives the whole session yet still auto-cleans after.
mp.observe_property('eof-reached', 'native', function(_, eof)
    if eof == true and not finished and o.mode == 'wl' and under(current, WL) then
        finished = true
        record_watched(current)
    end
end)

-- Remove the finished watch-later file when mpv CLOSES (not at eof), so seek-back / Promote-to-gold /
-- comments all keep working during the session. A video quit before the end (never finished) is kept.
mp.register_event('shutdown', function()
    if finished and o.mode == 'wl' and under(current, WL) then
        delete(current)
    end
end)

-- menu: delete the current watch-later file now and quit
mp.add_key_binding(nil, 'mark-watched', function()
    if under(current, WL) then
        record_watched(current)
        delete(current)
        mp.osd_message('done - removed from watch-later')
        mp.commandv('quit')
    else
        mp.osd_message('not a watch-later video')
    end
end)

-- menu: keep a permanent copy in gold (hardlink = no extra space, survives the auto-delete)
mp.add_key_binding(nil, 'promote-gold', function()
    if not current then return end
    mp.command_native({name = 'subprocess', playback_only = false, args = {
        'sh', '-c', 'mkdir -p "$1" && ln -f "$2" "$1/$3"', 'sh', GOLD, current, basename(current),
    }})
    mp.osd_message('promoted to gold')
end)

-- menu: open the current video in the browser (extract [id] from the filename)
mp.add_key_binding(nil, 'open-browser', function()
    if not current then return end
    local id = idof(current)
    local url = id and ('https://youtu.be/' .. id) or current
    mp.command_native({name = 'subprocess', playback_only = false, detach = true,
        args = {'yt', 'browser', url}})
    mp.osd_message('opened in browser')
end)

-- menu: read the current video's comments in a terminal (yt comments -> pager). alacritty is the host
-- terminal; the fetch takes a few seconds (yt-dlp) before the pager fills, same as the feed's ctrl-y.
mp.add_key_binding(nil, 'comments', function()
    if not current then return end
    local id = idof(current)
    local url = id and ('https://youtu.be/' .. id) or current
    mp.command_native({name = 'subprocess', playback_only = false, detach = true,
        args = {'alacritty', '-e', 'yt', 'comments', url}})
    mp.osd_message('opening comments…')
end)
