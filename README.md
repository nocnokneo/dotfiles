# Dotfiles

This is a fork of https://github.com/cowboy/dotfiles. It provides an easy command
to boostrap user configuration files.

That command is [~/.local/bin/dotfiles][dotfiles], and this is my "dotfiles"
Git repo.

[dotfiles]: https://github.com/nocnokneo/dotfiles/blob/master/bin/dotfiles
[bin]: https://github.com/nocnokneo/dotfiles/tree/master/bin

## What, exactly, does the "dotfiles" command do?

It's really not very complicated. When [dotfiles][dotfiles] is run, it does a few things:

1. Git is installed if necessary, via APT or Homebrew (which is installed if necessary).
2. This repo is cloned into the `~/.dotfiles` directory (or updated if it already exists).
2. Files in `init` are executed (in alphanumeric order).
3. Files in `copy` are copied into `~/`.
4. Files in `link` are linked into `~/`.

Note:

* The `backups` folder only gets created when necessary. Any files in `~/` that would have been overwritten by `copy` or `link` get backed up there.
* Files in `bin` are executable shell scripts ([~/.dotfiles/bin][bin] is added into the path).
* Files in `profile.d` get sourced once upon logging in (in alphanumeric order).
* Files in `bashrc.d` get sourced whenever a new shell is opened (in alphanumeric order).
* Files in `conf` just sit there. If a config file doesn't _need_ to go in `~/`, put it in there.
* Files in `caches` are cached files, only used by some scripts. This folder will only be created if necessary.

## Installation
### OS X
Notes:

* You need to be an administrator (for `sudo`).
* You need to have installed [XCode Command Line Tools](https://developer.apple.com/downloads/index.action?=command%20line%20tools), which are available as a separate, optional (and _much smaller_) download from XCode.

```sh
. <(curl -fsSL raw.githubusercontent.com/nocnokneo/dotfiles/master/bin/dotfiles)
```

### Ubuntu
Notes:

* You need to be an administrator (for `sudo`).
* If APT hasn't been updated or upgraded recently, it will probably be a few minutes before you see anything.

```sh
sudo apt-get install curl
. <(curl -fsSL raw.githubusercontent.com/nocnokneo/dotfiles/master/bin/dotfiles)
```

## The "init" step
These things will be installed, but _only_ if they aren't already.

### OS X
* Homebrew
  * git
  * tree
  * sl
  * lesspipe
  * id3tool
  * nmap
  * git-extras
  * htop-osx
  * apple-gcc42 (via [homebrew-dupes](https://github.com/Homebrew/homebrew-dupes/blob/master/apple-gcc42.rb))

### Ubuntu
* APT
  * git-core
  * tree
  * nmap
  * telnet
  * htop

## The ~/ "copy" step
Any file in the `copy` subdirectory will be copied into `~/`. Any file that _needs_ to be modified with personal information (like [.gitconfig](https://github.com/nocnokneo/dotfiles/blob/master/copy/.gitconfig) which contains an email address and private key) should be _copied_ into `~/`. Because the file you'll be editing is no longer in `~/.dotfiles`, it's less likely to be accidentally committed into your public dotfiles repo.

## The ~/ "link" step
Any file in the `link` subdirectory gets symbolically linked with `ln -s` into `~/`. Edit these, and you change the file in the repo. Don't link files containing sensitive data, or you might accidentally commit that data!

## Aliases and Functions
To keep things easy, the `~/.profile` and `~/.bashrc` and `~/.bash_profile` files are extremely simple, and should never need to be modified. Instead, add your aliases, functions, settings, etc into a file in either the `profile.d` or `bashrc.d` subdirectory. `profile.d` is for environment configuration that should be done no matter what you login to (graphical desktop, bash, csh, etc.). `bashrc.d` is for bash-specific stuff.

## License
Copyright (c) 2012 "Cowboy" Ben Alman
Copyright (c) 2013 Taylor Braun-Jones
Licensed under the MIT license.
<http://benalman.com/about/license/>
