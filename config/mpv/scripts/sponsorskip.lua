-- ~/.config/mpv/scripts/sponsorskip.lua
-- Offline auto-skip of the [SponsorBlock] chapters that `yt get` embeds at download time
-- (yt-dlp --sponsorblock-mark). Deterministic, needs no network at playback. Streamed URLs are
-- handled by the separate `sponsorblock` script; native video chapters are left alone (only
-- titles starting with "[SponsorBlock]" are skipped). See the youtube-workflow specs.
local mp = require 'mp'

local function on_chapter(_, ch)
    if ch == nil then return end
    local chapters = mp.get_property_native('chapter-list') or {}
    local cur = chapters[ch + 1] -- the 'chapter' property is 0-indexed
    if not (cur and cur.title and cur.title:find('^%[SponsorBlock%]')) then
        return
    end
    local nxt = chapters[ch + 2]
    if nxt then
        mp.set_property_number('time-pos', nxt.time) -- jump to the next chapter (may re-trigger + chain)
    else
        local dur = mp.get_property_number('duration')
        if dur then mp.commandv('no-osd', 'seek', dur, 'absolute') end
    end
    mp.osd_message('⏭ sponsor skipped')
end

mp.observe_property('chapter', 'number', on_chapter)
