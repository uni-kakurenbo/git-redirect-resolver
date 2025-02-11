# Git Redirect Resolver
Automatically updates the remote URLs of your git repositories.

## Build & Install
```
# required only if shc is not installed
sudo apt-get install shc

git clone https://github.com/uni-kakurenbo/git-redirect-resolver.git
sudo shc -v -r -f ./git-redirect-resolver/git-resolve.sh -o /bin/git-resolve
```

## Usage

```
git-resolve [--submodule] [--recursive]
```

- `--submodule`: Also updates submodules. Forced if `--recursive` is specified.
- `--recursive`: Recursively updates all submodules.
