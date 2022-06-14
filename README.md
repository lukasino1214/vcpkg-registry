
# How to update a port:
(using Daxa as an example)

- make and **commit** your changes (see update_all.ps1 if you just want to refresh it to master)
- either edit and run commit_changes.ps1, or do the following:
    - run `git rev-parse HEAD:ports/daxa` to get the commit hash for that path within the repo
    - update the relevant versions .json file with said commit hash (maybe add a new version)
    - add those changes to the previous commit **staging them** and then running `git commit --amend --no-edit`
