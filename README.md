# Custom files for Oh-My-Zsh

To install replace the following lines in `~/.zshrc`:
```shell
ZSH_THEME="eastwood"
ZSH_CUSTOM="/Users/igor/Projects/imotov/omyzc"
plugins=(git docker docker-compose)
```

## Self-update

New shells periodically check `origin` for updates (rate-limited, default every 7 days)
and print a reminder if one is available. Run it manually any time with `omyzc_update`
(alias `omyzcup`).

To auto-pull instead of just reminding, or to change the check frequency, add before
`source $ZSH/oh-my-zsh.sh` in `~/.zshrc`:
```shell
zstyle ':omyzc:update' mode auto     # auto | reminder (default) | disabled
zstyle ':omyzc:update' frequency 7   # days between checks
```
