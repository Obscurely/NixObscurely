# ~/.config/zsh/theme.zsh --- glacial shell colors (autosuggestions + fast-syntax-highlighting).
# Sourced from .zshrc AFTER the plugins load, so these override the plugin defaults.
# Palette: docs/glacial-design-language.md. Cohesive with the Alacritty/GTK/icon themes.

# zsh-autosuggestions: the inline "ghost" completion — dim + recessed so it reads as a hint.
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#4C5D72'

# fast-syntax-highlighting: intentionally left at its DEFAULT (functional, high-contrast) colors.
# The command line is a working surface where syntax color must pop for fast reading, so we do NOT
# mute it to the glacial palette (same rationale as the alacritty ANSI defaults). Only the ghost
# suggestion (above) stays recessed.
