-- hrtf.lua --- SOFA/HRTF binaural spatialization over headphones, via ffmpeg's `sofalizer`
-- audio filter. Takes multichannel audio (5.1/7.1 TrueHD etc.) and renders it to binaural
-- stereo using a measured HRTF, so surround content has real spatial placement on headphones.
--
-- Requires mpv built against ffmpeg with libmysofa (ffmpeg-full) --- see modules/desktop/media/mpv.nix.
-- Default: OFF. Drop `.sofa` files in ~/.config/mpv/hrtf/ and pick one from the menu.
--
--   Ctrl+h      toggle on/off          (script-binding hrtf/toggle)
--   Alt+h       open the SOFA menu      (script-binding hrtf/open-menu)  --- also in uosc's menu
--   Ctrl+= / -  HRTF gain +/- 1 dB      (hrtf/gain-up · hrtf/gain-down)  --- HRTF convolution is quieter,
--                                        so a few dB of make-up gain is normal. Persists across restarts.
--
-- Free SOFA databases: SADIE II (york.ac.uk/sadie-project), MIT KEMAR, ARI. A 7.1-capable
-- set (e.g. SADIE KU100) suits movie remuxes best.

local mp = require 'mp'
local utils = require 'mp.utils'

local HOME = os.getenv("HOME") or ""
local DIR = HOME .. "/.config/mpv/hrtf"
local GAIN_FILE = DIR .. "/.gain" -- persisted make-up gain (dB)
local LABEL = "@hrtf" -- labeled filter so we can add/remove it cleanly

local state = { enabled = false, sofa = nil, gain = 3 }

-- make sure the drop-in dir exists (config/mpv is store-deployed; this stays user-writable)
utils.subprocess({ args = { "mkdir", "-p", DIR }, cancellable = false })

-- load persisted gain
do
  local f = io.open(GAIN_FILE, "r")
  if f then
    local v = tonumber((f:read("*l") or ""))
    f:close()
    if v then state.gain = v end
  end
end

local function save_gain()
  local f = io.open(GAIN_FILE, "w")
  if f then f:write(tostring(state.gain) .. "\n"); f:close() end
end

local function osd(t) mp.osd_message(t, 2) end

-- mpv filter-arg escaping: %<bytelen>%<string> passes arbitrary paths (spaces etc.) safely
local function esc(s) return "%" .. tostring(#s) .. "%" .. s end

local function list_sofa()
  local out = {}
  for _, f in ipairs(utils.readdir(DIR, "files") or {}) do
    if f:lower():match("%.sofa$") then out[#out + 1] = f end
  end
  table.sort(out)
  return out
end

local function apply()
  mp.commandv("af", "remove", LABEL) -- idempotent; harmless if not present
  if state.enabled and state.sofa then
    mp.commandv("af", "add",
      LABEL .. ":sofalizer=sofa=" .. esc(DIR .. "/" .. state.sofa) .. ":gain=" .. tostring(state.gain))
  end
end

local function set_sofa(name)
  state.sofa = name
  if state.enabled then apply() end
  osd("HRTF file: " .. name .. (state.enabled and "" or "  (HRTF is off)"))
end

local function toggle()
  if state.enabled then
    state.enabled = false
    apply()
    osd("HRTF: off")
  else
    if not state.sofa then
      local files = list_sofa()
      if #files == 0 then
        osd("HRTF: no .sofa files in ~/.config/mpv/hrtf")
        return
      end
      state.sofa = files[1] -- default to first available
    end
    state.enabled = true
    apply()
    osd("HRTF: on  ·  " .. state.sofa .. "  ·  " .. state.gain .. " dB")
  end
end

local function adjust_gain(delta)
  state.gain = math.max(-20, math.min(40, state.gain + delta))
  save_gain()
  if state.enabled then apply() end
  osd("HRTF gain: " .. state.gain .. " dB" .. (state.enabled and "" or "  (HRTF is off)"))
end

-- uosc menu: toggle + gain nudges + the SOFA file list
local function open_menu()
  local me = mp.get_script_name()
  local items = {
    {
      title = state.enabled and "Disable HRTF" or "Enable HRTF",
      hint = state.enabled and (state.sofa or "") or "off",
      value = { "script-message-to", me, "hrtf-toggle" },
    },
    { title = "Gain  −1 dB", hint = state.gain .. " dB", keep_open = true, value = { "script-message-to", me, "hrtf-gain", "-1" } },
    { title = "Gain  +1 dB", hint = state.gain .. " dB", keep_open = true, value = { "script-message-to", me, "hrtf-gain", "1" } },
  }
  local files = list_sofa()
  if #files == 0 then
    items[#items + 1] = { title = "No .sofa files found", hint = "~/.config/mpv/hrtf", selectable = false }
  else
    for _, f in ipairs(files) do
      items[#items + 1] = {
        title = f,
        hint = (state.sofa == f) and "current" or nil,
        active = (state.sofa == f),
        value = { "script-message-to", me, "hrtf-load", f },
      }
    end
  end
  local menu = { type = "hrtf", title = "HRTF · SOFA files  (" .. state.gain .. " dB)", items = items }
  mp.commandv("script-message-to", "uosc", "open-menu", utils.format_json(menu))
end

mp.register_script_message("hrtf-load", set_sofa)
mp.register_script_message("hrtf-toggle", toggle)
mp.register_script_message("hrtf-gain", function(d) adjust_gain(tonumber(d) or 0) end)
mp.add_key_binding(nil, "toggle", toggle)
mp.add_key_binding(nil, "open-menu", open_menu)
mp.add_key_binding(nil, "gain-up", function() adjust_gain(1) end)
mp.add_key_binding(nil, "gain-down", function() adjust_gain(-1) end)

-- re-assert the filter on each new file so it re-inits for that file's channel layout
mp.register_event("file-loaded", function() if state.enabled then apply() end end)
