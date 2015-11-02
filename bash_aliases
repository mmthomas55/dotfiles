alias run_unit='fab run_unit_tests --set=DEV_SANDBOX=true'
alias vim='/usr/bin/vim7.4'
alias tmux='TERM=xterm-256color tmux'
alias clean_pyc='find . -name "*.pyc" | xargs rm -f'
alias clean_local='git branch --merged master | grep -v "\* master" | xargs -n 1 git branch -d'

set_env () {
    cd ~/src/api/
    . env/bin/activate
    export API_ENV="$*"
    export WORK_FACTOR=0
}

# Create directory, then enter it
mkcd () {
    mkdir -p "$*"
    cd "$*"
}

# Kill a process from a pid file
function pk {
    kill -9 $(cat $1)
}
