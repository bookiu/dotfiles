autoload -U add-zsh-hook

add-zsh-hook precmd success_emoji
add-zsh-hook precmd error_emoji

function _get_type() {
    local value="$1"
    echo $(print -rl -- ${(t)value})
}

function _current_time() {
    local current_time=`date +%H:%M:%S`
    echo "%{$fg[cyan]%}$current_time%{$reset_color%}"
}

function success_emoji() {
    local emojis=(${(@s: :)RET_SUCCESS_EMOJIS})
    local emojis_count=${#emojis}
    if [ $emojis_count -eq 0 ]; then
        local emojis=(🍺 🍋 🌽 🐵 🎾)
    fi
    local emojis_count=${#emojis}
    local idx=$(($RANDOM % $emojis_count))

    success_emoji=${emojis[$idx + 1]}
}

function error_emoji() {
    local emojis=(${(@s: :)RET_ERROR_EMOJIS})
    local emojis_count=${#emojis}
    if [ $emojis_count -eq 0 ]; then
        local emojis=(🍎 🔥 🚒 🚨 🧨 💔)
        local emojis_count=${#emojis}
    fi
    local idx=$(($RANDOM % $emojis_count))

    error_emoji=${emojis[$idx + 1]}
}

local ret_code="%(?:"":%{$fg[red]%}%?%{$reset_color%}|)"

PROMPT='%(?:%{$fg_bold[green]%}${success_emoji}:%{$fg_bold[red]%}${error_emoji})'
PROMPT+=' %{$fg_bold[cyan]%}%c%{$reset_color%} $(git_prompt_info)'

RPROMPT='${ret_code}$(_current_time)'

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[blue]%}git:(%{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[blue]%}) %{$fg[yellow]%}✗"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[blue]%})"
