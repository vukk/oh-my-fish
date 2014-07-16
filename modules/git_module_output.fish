function _git_branch_name
  echo (command git symbolic-ref HEAD ^/dev/null | sed -e 's|^refs/heads/||')
end

function _is_git_dirty
  echo (command git status -s --ignore-submodules=dirty ^/dev/null)
end

function git_module_output
  if [ (_git_branch_name) ]
    set git_branch (_git_branch_name)

    if [ (_is_git_dirty) ]
      if set -q GIT_MODULE_DIRTY
        set git_dirty $GIT_MODULE_DIRTY
      else
        set git_dirty "✗"
      end
    end

    if set -q GIT_MODULE_OUTPUT
      eval echo $GIT_MODULE_OUTPUT
    end
  end
end
