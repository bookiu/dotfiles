# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

### Added by Zinit's installer
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
    print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
        print -P "%F{33} %F{34}Installation successful.%f%b" || \
        print -P "%F{160} The clone has failed.%f%b"
fi

source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
    zdharma-continuum/zinit-annex-as-monitor \
    zdharma-continuum/zinit-annex-bin-gem-node \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-rust

zinit light zsh-users/zsh-autosuggestions
zinit light zdharma/fast-syntax-highlighting
zinit light wting/autojump
zinit snippet OMZ::plugins/autojump/autojump.plugin.zsh
zinit snippet OMZ::plugins/brew/brew.plugin.zsh
zinit snippet OMZ::plugins/history/history.plugin.zsh
zinit snippet OMZ::plugins/tmux/tmux.plugin.zsh
zinit snippet OMZ::plugins/kubectl/kubectl.plugin.zsh
zinit snippet OMZ::plugins/sudo/sudo.plugin.zsh
zinit snippet OMZ::lib/git.zsh
zinit snippet OMZ::plugins/git/git.plugin.zsh

# # Load powerlevel10k theme
# zinit ice depth"1" # git clone depth
# zinit light romkatv/powerlevel10k

# Reset PATH environment
if [[ "$OSTYPE" = darwin* ]]; then
    PATH=$PATH:/Library/Apple/usr/bin:/Library/Apple/bin
fi

ZSH_CONFIG="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.config/zsh" || printf %s "${XDG_CONFIG_HOME}/zsh")"
profiles=(
    "$ZSH_CONFIG/zshrc.local" "$ZSH_CONFIG/zshenv" "$ZSH_CONFIG/zsh_func" "$ZSH_CONFIG/zsh_aliases"
    "$ZSH_CONFIG/zshenv.local" "$ZSH_CONFIG/zsh_func.local" "$ZSH_CONFIG/zsh_aliases.local"
)
for profile in $profiles; do
    if [[ -f $profile ]]; then
        source $profile
    fi
done
unset profile k profiles

# Load additional script
if [ -d "$ZSH_CONFIG/zsh.d/" ]; then
    for k in $(ls -1 "$ZSH_CONFIG/zsh.d/"); do
        source "$ZSH_CONFIG/zsh.d/${k}"
    done
fi

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
# [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
