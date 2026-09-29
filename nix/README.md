# dbennett's home-manager flake

Single-user Nix + [home-manager](https://github.com/nix-community/home-manager)
config, replacing the imperative install scripts in `~/dotfiles/install/`.

## Layout

```
nix-config/
├── flake.nix                    # entry point: pins nixpkgs + home-manager, wires up homeConfigurations.dbennett
├── flake.lock                   # exact pinned commits (auto-generated, do not hand-edit)
└── home-manager/
    ├── home.nix                 # top-level home-manager module: username, stateVersion, imports
    ├── modules/
    │   ├── packages.nix         # home.packages - the "what gets installed" list
    │   └── activation.nix       # bootstrap hooks (vim-plug, tmux tpm) that run on `switch`
    └── pkgs/
        └── hc-install.nix       # custom derivation for hashicorp/hc-install (not in nixpkgs)
```

## First-time setup

1. Enable flakes for your user (one-time, only needs doing once ever):
   ```sh
   mkdir -p ~/.config/nix
   echo "experimental-features = nix-command flakes" >> ~/.config/nix/nix.conf
   ```

2. Install home-manager itself and apply this config:
   ```sh
   cd ~/.nixconfigs/nix-config
   nix run home-manager/master -- switch --flake .#dbennett
   ```
   After this first run, the `home-manager` command itself is on your
   PATH (via `programs.home-manager.enable = true` in home.nix), so future
   updates are just:
   ```sh
   home-manager switch --flake .#dbennett
   ```

   `nh` is also installed, so you can use the shorthand:
   ```sh
   nh home switch
   ```

## Conventions used here (for reference)

- **Flakes**: `flake.nix` + `flake.lock` pin *exact* revisions of nixpkgs and
  home-manager, so `home-manager switch` is fully reproducible until you
  deliberately run `nix flake update`.
- **Flakes require git**: local flakes only see git-tracked files (this repo
  is already git-initialized). Untracked files are invisible to the build —
  remember to `git add` new files before building/switching.
- **`home.stateVersion`**: set once, never bump casually — it pins
  home-manager's internal on-disk format, not your package versions.
- **`nixpkgs.config.allowUnfree`**: required for anything with a restrictive
  license (vivaldi, spotify). Without it, Nix refuses to build/fetch them.
- **Custom packages**: anything not in nixpkgs (like `hc-install`) gets its
  own `.nix` file in `pkgs/`, built with the matching `buildXModule` helper
  (`buildGoModule` for Go, `buildRustPackage` for Rust, etc.) and pulled into
  `home.packages` via `pkgs.callPackage`.
- **`home.activation`**: the escape hatch for one-off imperative bootstrap
  steps (cloning a plugin manager repo, etc.) that don't have a package —
  used here for vim-plug and tmux's tpm.

## What's intentionally *not* here

Kept as-is in `~/dotfiles/install/`, not managed by Nix:
- **docker** (`dnf.sh`) — needs systemd + root; home-manager only manages
  user-level things. Would need real NixOS (`services.docker`) to Nix-ify.
- **gh extensions** (`gh extension install ...`) — installed via `gh` itself
  at runtime, not a package manager concern.
- **flatpak.sh** — now only `Pomodorolm` remains (moved Spotify to Nix, see
  `packages.nix`).
- **`/etc/1password/custom_allowed_browsers`** — needs `vivaldi-bin` on one
  line, so the 1Password browser extension can talk to the desktop app.
  This is a system (`/etc`) file, out of scope for a single-user
  home-manager setup (that's NixOS/root territory) — handled manually,
  outside this flake, to keep this config portable across machines/OSes:
  ```sh
  echo "vivaldi-bin" | sudo tee /etc/1password/custom_allowed_browsers
  ```
