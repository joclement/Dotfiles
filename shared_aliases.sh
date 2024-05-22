# shellcheck disable=SC2046

################################### My aliases #################################

alias kfi='pkill -f /usr/lib/firefox/firefox && (firefox &> /dev/null &)'
alias pingTest='ping 9.9.9.9'
alias testHDMI='speaker-test -c 2 -r 48000 -D hw:0,3'
alias grep='grep \
    -I \
    --color=auto \
    --exclude-dir={.git,build,.mypy_cache,.nox,.pytest_cache} \
    --exclude=tags'
# use sudo to get all open ports
alias open_ports='netstat -tulpn | grep LISTEN'
alias used_ports='sudo lsof -i -P -n | grep LISTEN'
alias vless='vim -R -'
alias vi='vim'

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'

alias docker_kill_all='docker kill $(docker ps -q)'

################################ My alias functions ############################

function pgrep {
    find "$2" -type f | parallel -k -j150% -n 1000 -m grep -H -n "$1" {}
}

# TODO do I really still need this function? I think this can also be done with
# an environment variable.
function pmake {
    ncpu=$(nproc)
    upper_limit=10
    if ((ncpu > 10)); then
        ncpu=$upper_limit
    fi
    nice -n19 make -j"$ncpu" "$@"
}

function mkcd {
    mkdir "$1" && cd "$1" || exit
}

function md2html {
    markdownfile=$1
    htmlfile=${markdownfile%".md"}".html"
    pandoc \
        --from gfm \
        --to html \
        --standalone "$markdownfile" \
        --output "$htmlfile"
}

function cless {
    pygmentize -f terminal "$1" | less -R
}

function gitfixup {
    selected_commit=$(git log -n 30 --pretty=format:'%h %s' --no-merges \
        | fzf \
        | cut -c -7)

    git commit --fixup "$selected_commit"
    GIT_SEQUENCE_EDITOR=true git rebase -i --autosquash "${selected_commit}"~1
}

function list_dirty_gits {
    is_git_dirty="git diff --quiet --ignore-submodules --exit-code"

    # editorconfig-checker-disable
    find ./ \
        -type d \
        -name '.git' \
        -exec sh -c "cd '$1/..' && $is_git_dirty || echo 'Dirty: $1'" shell {} \;
    # editorconfig-checker-enable
}

function git_determine_default_branch {
    if git rev-parse --verify main 2> /dev/null; then
        echo "main"
    else
        echo "master"
    fi
}

function gprunesquashmerged {
    local default_branch
    default_branch=$(git_determine_default_branch)

    git checkout -q "$default_branch" \
        && git for-each-ref refs/heads/ "--format=%(refname:short)" \
        | while read -r branch; do
            mergeBase=$(git merge-base "$default_branch" "$branch") \
                && [[ $(git cherry "$default_branch" \
                    $(git commit-tree $(git rev-parse "$branch^{tree}") \
                        -p "$mergeBase" -m _)) == "-"* ]] \
                && git branch -D "$branch"
        done
}

function datetime_to_unix {
    date -u -d "${1} ${2}" +%s
}

function unix_to_datetime {
    date -u -d @"${1}" +'%F %T'
}
