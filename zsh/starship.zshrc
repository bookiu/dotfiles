# set XDG_CONFIG_HOME
if [ -z "${XDG_CONFIG_HOME-}" ]; then
    XDG_CONFIG_HOME="${HOME}/.config"
fi

# Path to your oh-my-zsh installation.
export ZSH="${HOME}/.oh-my-zsh"

# # See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
# ZSH_THEME="robbyrussell"
# if [ -f ~/.zsh_theme ]; then
#     ZSH_THEME=$(cat ~/.zsh_theme | head -1)
# fi

# omz features
CASE_SENSITIVE="false"
DISABLE_AUTO_UPDATE="true"
DISABLE_MAGIC_FUNCTIONS=true

# Would you like to use another custom folder than $ZSH/custom?
ZSH_CUSTOM=$XDG_CONFIG_HOME/zsh

# git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
# git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
# git clone https://github.com/wting/autojump.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/autojump
# git clone https://github.com/zsh-users/zsh-completions.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-completions
plugins=(
    brew sudo history git colored-man-pages tmux
    zsh-autosuggestions autojump kubectl
)
# docker plugin
if which docker &> /dev/null; then
    plugins+=(docker docker-compose)
fi
# archlinux
if grep -i arch /etc/issue &> /dev/null; then
    plugins+=(archlinux)
fi
# fzf, https://github.com/junegunn/fzf
if which fzf &> /dev/null; then
    plugins+=(fzf)
fi
if which pip &> /dev/null; then
    plugins+=(pip)
fi
if which systemctl &> /dev/null; then
    plugins+=(systemd)
fi
if which thefuck &> /dev/null; then
    plugins+=(thefuck)
fi

# Load omz
source $ZSH/oh-my-zsh.sh

# User configuration
# disable zsh auto correct
unsetopt correct_all
# disable mail check
unset MAILCHECK
# disable history share between sessions
unsetopt share_history
# ignore dump command
setopt HIST_IGNORE_ALL_DUPS
# ignore command start with space
setopt HIST_IGNORE_SPACE
# disable ctrl+d
#set -o ignoreeof
#setopt CORRECT

# Plugin setting
[ -d "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-completions" ] && autoload -U compinit && compinit
[[ -s $HOME/.autojump/etc/profile.d/autojump.sh ]] && source $HOME/.autojump/etc/profile.d/autojump.sh && autoload -U compinit && compinit -u

ZSH_CONFIG="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.zsh" || printf %s "${XDG_CONFIG_HOME}/zsh")"
profiles=(
    "$ZSH_CONFIG/zshrc.local" "$ZSH_CONFIG/zshenv" "$ZSH_CONFIG/zsh_func" "$ZSH_CONFIG/zsh_aliases"
    "$ZSH_CONFIG/zshenv.local" "$ZSH_CONFIG/zsh_func.local" "$ZSH_CONFIG/zsh_aliases.local"
)
for profile in "${profiles[@]}"; do
    if [[ -f $profile ]]; then
        source "$profile"
    fi
done
unset profile profiles

# Load additional script
ignore_additional_files=(
    "iterm2_shell_integration.zsh"
)
if [ -d "$ZSH_CONFIG/zsh.d/" ]; then
    for k in "${ZSH_CONFIG}"/zsh.d/*.{zsh,sh}; do
        for ignored in "${ignore_additional_files[@]}"; do
            if [[ "$(basename "${k}")" == "$ignored" ]]; then
                continue 2
            fi
        done
        source "${k}"
    done
    unset k
fi
unset ZSH_CONFIG

# https://github.com/starship/starship/issues/5463
# https://gitlab.com/gnachman/iterm2/-/issues/10537
if [[ $TERM_PROGRAM == iTerm.app ]]; then
  export ITERM2_SQUELCH_MARK=1
  add-zsh-hook -d precmd omz_termsupport_cwd
fi

# Starship prompt
export STARSHIP_CONFIG="${XDG_CONFIG_HOME}/starship/starship.toml"
eval "$(/opt/homebrew/bin/starship init zsh)"
