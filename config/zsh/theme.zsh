# ~/.config/zsh/theme.zsh --- glacial shell colors (autosuggestions + fast-syntax-highlighting).
# Sourced from .zshrc AFTER the plugins load, so these override the plugin defaults.
# Palette: docs/glacial-design-language.md. Cohesive with the Alacritty/GTK/icon themes.

# zsh-autosuggestions: the inline "ghost" completion — dim + recessed so it reads as a hint.
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#4C5D72'

# fast-syntax-highlighting: cool, calm command-line highlighting. Icy blues for the syntax,
# with the theme's semantic amber/red kept for precommands (sudo) and errors so they still pop.
typeset -gA FAST_HIGHLIGHT_STYLES
FAST_HIGHLIGHT_STYLES[default]='fg=#CBD8EA'
FAST_HIGHLIGHT_STYLES[command]='fg=#8FC7B4'
FAST_HIGHLIGHT_STYLES[builtin]='fg=#8FC7B4'
FAST_HIGHLIGHT_STYLES[function]='fg=#8FC7B4'
FAST_HIGHLIGHT_STYLES[alias]='fg=#8FC7B4'
FAST_HIGHLIGHT_STYLES[suffix-alias]='fg=#8FC7B4'
FAST_HIGHLIGHT_STYLES[precommand]='fg=#E7B872'
FAST_HIGHLIGHT_STYLES[reserved-word]='fg=#8C9BD8'
FAST_HIGHLIGHT_STYLES[path]='fg=#8CC6F2'
FAST_HIGHLIGHT_STYLES[path-to-dir]='fg=#8CC6F2,underline'
FAST_HIGHLIGHT_STYLES[globbing]='fg=#79C0E8'
FAST_HIGHLIGHT_STYLES[single-quoted-argument]='fg=#A6D4B0'
FAST_HIGHLIGHT_STYLES[double-quoted-argument]='fg=#A6D4B0'
FAST_HIGHLIGHT_STYLES[dollar-quoted-argument]='fg=#A6D4B0'
FAST_HIGHLIGHT_STYLES[dollar-double-quoted-argument]='fg=#79C0E8'
FAST_HIGHLIGHT_STYLES[back-quoted-argument]='fg=#79C0E8'
FAST_HIGHLIGHT_STYLES[command-substitution-delimiter]='fg=#90A4BC'
FAST_HIGHLIGHT_STYLES[comment]='fg=#5B6E85'
FAST_HIGHLIGHT_STYLES[variable]='fg=#90A4BC'
FAST_HIGHLIGHT_STYLES[assign]='fg=#CBD8EA'
FAST_HIGHLIGHT_STYLES[redirection]='fg=#90A4BC'
FAST_HIGHLIGHT_STYLES[unknown-token]='fg=#E58A8A'
FAST_HIGHLIGHT_STYLES[incorrect-subtle]='fg=#E58A8A'
