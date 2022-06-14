
# How to update a port:
(using Daxa as an example)

- make and **commit** your changes (see update_all if you just want to refresh it to master)
- run `git rev-parse HEAD:ports/daxa` to get the commit hash for that path within the repo
- update the relevant versions .json file with said commit hash (maybe add a new version)
- add those changes to the previous commit **staging them** and then running `git commit --amend --no-edit`
