# dotfiles

Personal Linux configuration files, stored in a GNU stow-compatible layout.

## Layout

Each top-level directory is a package:

- `shell` -> `.bashrc`, `.profile`, `.zshrc`
- `readline` -> `.inputrc`
- `vieb` -> `.viebrc`
- `fish` -> `.config/fish`
- `kitty` -> `.config/kitty`
- `btop` -> `.config/btop`
- `niri` -> `.config/niri`
- `mako` -> `.config/mako`
- `qutebrowser` -> `.config/qutebrowser`
- `nvim` -> `.config/nvim`
- `thunar` -> `.config/Thunar`

## Install on a new system

Clone the repo into the home directory:

```sh
git clone <your-repo-url> ~/dotfiles
cd ~/dotfiles
```

Install everything with the bundled symlink installer:

```sh
./scripts/install.sh
```

Or install only selected packages:

```sh
./scripts/install.sh shell fish kitty
```

The installer creates symlinks from this repo into `$HOME`. If a real file
already exists at the target path, it is moved into a timestamped backup
directory under `~/dotfiles`.

## GNU stow alternative

If `stow` is installed, the same package layout can be used directly:

```sh
cd ~/dotfiles
stow -t "$HOME" shell fish kitty btop niri qutebrowser nvim thunar readline vieb
```

On openSUSE, install stow with:

```sh
sudo zypper install stow
```

## Add a new config

Example for a future app config:

```sh
mkdir -p ~/dotfiles/app/.config
cp -a ~/.config/app ~/dotfiles/app/.config/
cd ~/dotfiles
git add app
git commit -m "Add app config"
```

Then install it on another machine:

```sh
./scripts/install.sh app
```

## Do not commit

Avoid committing secrets, tokens, SSH keys, browser profiles, VPN configs,
wallets, databases, caches, and app state. Prefer committing only hand-written
configuration.
