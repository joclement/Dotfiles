# shellcheck disable=SC2046 shell=bash

################################### My aliases #################################

alias kfi='pkill -f /usr/lib/firefox/firefox && (firefox &> /dev/null &)'
alias pingTest='ping 9.9.9.9'
alias testHDMI='speaker-test -c 2 -r 48000 -D hw:0,3'
alias grep='grep \
    -I \
    --color=auto \
    --exclude-dir={.git,build,.mypy_cache,.nox,.pytest_cache,.tox} \
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

pgrep() {
  find "$2" -type f | parallel -k -j150% -n 1000 -m grep -H -n "$1" {}
}

mkcd() {
  mkdir "$1" && cd "$1" || exit
}

md2html() {
  markdownfile=$1
  htmlfile=${markdownfile%".md"}".html"
  pandoc \
    --from gfm \
    --to html \
    --standalone "$markdownfile" \
    --output "$htmlfile"
}

cless() {
  pygmentize -f terminal "$1" | less -R
}

gitfixup() {
  selected_commit=$(git log -n 30 --pretty=format:'%h %s' --no-merges \
    | fzf \
    | cut -c -7)

  git commit --fixup "$selected_commit"
  GIT_SEQUENCE_EDITOR=true git rebase -i --autosquash "${selected_commit}"~1
}

list_dirty_gits() {
  local is_git_dirty="git diff --quiet --ignore-submodules --exit-code"

  # editorconfig-checker-disable
  find ./ \
    -type d \
    -name '.git' \
    -exec sh -c "cd '$1/..' && $is_git_dirty || echo 'Dirty: $1'" shell {} \;
  # editorconfig-checker-enable
}

gprunesquashmerged() {
  local default_branch
  default_branch=$(git default-branch)

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

datetime_to_unix() {
  date -u -d "${1} ${2}" +%s
}

unix_to_datetime() {
  date -u -d @"${1}" +'%F %T'
}

get_gitlab_link_for_commit_id() {
  local ref=${1}
  local commit_id
  commit_id=$(git rev-parse "${ref}")

  echo "$(git remote get-url origin \
    | sed 's#\.git$##' \
    | sed 's#git@#https://#; s#com:#com/#')/-/commit/${commit_id}"
}
