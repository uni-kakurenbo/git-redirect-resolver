# Git Redirect Resolver
Automatically updates the remote URLs of your git repositories.

## Install

```
git clone git-redirect-resolver
sudo cp ./git-redirect-resolver/git-resolve.sh /bin/git-resolve
```

## Usage

```
git-resolve [--submodule] [--recursive]
```

- `--submodule`: Also updates submodules. Forced if `--recursive` is specified.
- `--recursive`: Recursively updates all submodules.
