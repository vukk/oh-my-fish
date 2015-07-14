Used git subtree to fetch plugins, see 
https://blogs.atlassian.com/2013/05/alternatives-to-git-submodule-git-subtree/
Added fish-bd remote.

Commands to update fish-bd:
  git fetch fish-bd master
  git subtree pull --prefix custom/plugins/fish-bd fish-bd master --squash
