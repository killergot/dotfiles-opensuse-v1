#!/usr/bin/env sh
set -eu

repo_dir=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd -P)
backup_dir="$repo_dir/.dotfiles-backup-$(date +%Y%m%d-%H%M%S)"

usage() {
  printf '%s\n' "Usage: $0 [package ...]"
  printf '%s\n' "If no package is provided, all packages are installed."
}

list_packages() {
  find "$repo_dir" -mindepth 1 -maxdepth 1 -type d \
    ! -name .git \
    ! -name scripts \
    ! -name '.dotfiles-backup-*' \
    -exec basename {} \; | sort
}

link_file() {
  src=$1
  rel=${src#"$repo_dir/$package/"}
  dest=$HOME/$rel
  dest_dir=$(dirname -- "$dest")

  mkdir -p -- "$dest_dir"

  if [ -L "$dest" ]; then
    current=$(readlink -- "$dest")
    if [ "$current" = "$src" ]; then
      printf 'ok: %s\n' "$dest"
      return 0
    fi
  fi

  if [ -e "$dest" ] || [ -L "$dest" ]; then
    mkdir -p -- "$backup_dir"
    backup_path=$backup_dir/$rel
    mkdir -p -- "$(dirname -- "$backup_path")"
    mv -- "$dest" "$backup_path"
    printf 'backup: %s -> %s\n' "$dest" "$backup_path"
  fi

  ln -s -- "$src" "$dest"
  printf 'link: %s -> %s\n' "$dest" "$src"
}

install_package() {
  package=$1
  package_dir=$repo_dir/$package

  if [ ! -d "$package_dir" ]; then
    printf 'error: unknown package: %s\n' "$package" >&2
    return 1
  fi

  find "$package_dir" -type f | sort | while IFS= read -r src; do
    link_file "$src"
  done
}

if [ "${1:-}" = "-h" ] || [ "${1:-}" = "--help" ]; then
  usage
  exit 0
fi

if [ "$#" -eq 0 ]; then
  set -- $(list_packages)
fi

for package in "$@"; do
  install_package "$package"
done
