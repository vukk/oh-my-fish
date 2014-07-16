# name: RobbyRussel
function _git_branch_name
  echo (command git symbolic-ref HEAD ^/dev/null | sed -e 's|^refs/heads/||')
end

function _is_git_dirty
  echo (command git status -s --ignore-submodules=dirty ^/dev/null)
end

function fish_prompt
  set -l last_status $status
  set -l cyan (set_color -o cyan)
  set -l red (set_color -o red)
  set -l green (set_color -o green)
  set -l normal (set_color normal)

  if test $last_status = 0
    set arrow "$green➜ "
  else
    set arrow "$red➜ "
  end
  set -l cwd $cyan(basename (prompt_pwd))

  set -gx GIT_MODULE_OUTPUT '(set_color -o blue)git:\((set_color -o red)$git_branch(set_color -o blue)\) (set_color -o yellow)$git_dirty'
  echo -n -s $arrow $cwd ' ' (git_module_output) ' ' $normal
end

