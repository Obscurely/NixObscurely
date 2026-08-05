-- ~/.config/mpv/scripts/open-dialog.lua
-- Bind a key to a NATIVE GTK file-open dialog (zenity) -> loadfile. This is the "open like
-- VLC" path; the dialog is glacial via the Mont-Blanc-Dark GTK theme. Pairs with uosc's
-- in-player browser (script-binding uosc/open-file). Bound to Ctrl+o in input.conf.
-- zenity is provided on PATH by the same nix module (modules/desktop/media/mpv.nix).
local mp = require 'mp'
local msg = require 'mp.msg'

local function open_dialog()
    local res = mp.command_native({
        name = 'subprocess',
        playback_only = false,     -- allow running while idle (no file loaded)
        capture_stdout = true,
        args = {
            'zenity', '--file-selection', '--multiple',
            '--title=Open in mpv', '--separator=\n',
        },
    })
    -- zenity exits 1 on cancel; only act on a successful selection
    if res.status ~= 0 or not res.stdout or res.stdout == '' then
        if res.error_string and res.error_string ~= '' then
            msg.warn('open-dialog: ' .. res.error_string)
        end
        return
    end
    local first = true
    for path in res.stdout:gmatch('[^\n]+') do
        mp.commandv('loadfile', path, first and 'replace' or 'append')
        first = false
    end
end

-- Expose the named binding; input.conf assigns the key (script-binding open_dialog/open-file-dialog)
-- and uosc reads it into its menu. mpv derives the script name "open_dialog" from this filename.
mp.add_key_binding(nil, 'open-file-dialog', open_dialog)
