export PROMPT_COMMAND='echo -ne "\033]0;sandbox_dev:${PWD/#$HOME/~}\007"'

# Install auto complete
# curl https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash -o ~/.git-completion.bash
if [ -f ~/.git-completion.bash ]; then
  . ~/.git-completion.bash
fi
