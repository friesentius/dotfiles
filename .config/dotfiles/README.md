# Dotfiles

My personal Linux dotfiles

## Currently includes

- Neovim
- Starship
- Zsh

## Installation

Clone this repo as a bare repository:

`git clone --bare git@github.com:friesentius/dotfiles.git ~/.dotfiles`

Create the `dotfiles` alias

`alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'`

Check out the configuration

`dotfiles checkout`

Hide untracked files:

`dotfiles config --local status.showUntrackedFiles no`

## Usage

Use `dotfiles` in place of `git` when managing configuration files:

```sh
dotfiles status
dotfiles add ~/.config/nvim
dotfiles commit -m "Update neovim config"
dotfiles push
```
