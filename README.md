# ❄ Nix Config

One **dendritic** flake for all my machines:

- **`bach`** — aarch64-linux VPS. ~12 self-hosted services (Nextcloud, Immich, Ghost,
  Miniflux, Calibre-Web, a Hugo site…), ZFS + impermanence with remote LUKS/ZFS unlock,
  agenix + git-agecrypt secrets.
- **`satie`** — aarch64-linux Apple-Silicon (Asahi) laptop. Hyprland + DankMaterialShell
  desktop, agenix secrets.

## The dendritic pattern

The flake is built with [flake-parts] + [import-tree]. **Every `.nix` file under `./modules`
is auto-imported** as a flake-parts module — there is no central list of imports to maintain.

A file under `modules/` does one of two things:

1. **Registers an aspect** — a reusable, self-contained piece of config:
   ```nix
   # modules/nixos/services/immich.nix
   { ... }: {
     flake.nixosModules.immich = { config, pkgs, env, ... }: {
       services.immich.enable = true;
       # …everything Immich needs: nginx vhost, postgres, redis, backup, fail2ban…
     };
   }
   ```
   NixOS aspects register under `flake.nixosModules.<name>`; home-manager aspects under
   `flake.homeModules.<name>`. **Registering an aspect does nothing on its own** — it just
   makes it available.

2. **Assembles a host** — `modules/hosts/<host>.nix` lists the aspects that machine runs.
   This is the single **toggle surface**:
   ```nix
   # modules/hosts/bach.nix (excerpt)
   modules = with config.flake.nixosModules; [
     bach-hardware core networking optimization users sudo
     ssh tailscale nginx acme postgresql fail2ban backup
     nextcloud immich calibre miniflux hugo ghost
   ];
   ```

### Recipes

- **Add a service / app** → create a file in `modules/nixos/services/` (or
  `modules/home/…`) that registers `flake.nixosModules.<x>` / `flake.homeModules.<x>`,
  then add `<x>` to the host's module list.
- **Add a host** → create `modules/hosts/<host>.nix` with a `flake.nixosConfigurations.<host>`
  that lists the aspects it wants.
- **Toggle a service on a host** → comment/uncomment its name in that host's module list.
  (No `enable` flags — the import *is* the switch.)

### Layout

```
flake.nix                     # flake-parts entry: home-manager flakeModule + import-tree ./modules
env.nix                       # shared settings hub, imported per host, passed via specialArgs
modules/
  hosts/{bach,satie}.nix     # per-machine assembly + toggle surface
  nixos/                      # flake.nixosModules.<x>
    core.nix networking.nix optimization.nix sudo.nix users.nix desktop.nix
    hardware/{bach,asahi}.nix
    services/*.nix
  home/                       # flake.homeModules.<x>
    git.nix  shells/*.nix  desktop/*.nix
disko/                        # bach ZFS + impermanence (imported by nixos/hardware/bach.nix)
secrets/                      # see secrets/README.md
```

> **`env.nix` note:** shared values (`env.cloudSettings`, `env.userSettings`) are threaded
> through modules via `specialArgs`/`extraSpecialArgs` rather than flake-parts options. This
> is a deliberate, pragmatic exception to strict dendritic purity that keeps every module
> body plain NixOS/home-manager config.

## Build / switch

```bash
nixos-rebuild switch --flake .#bach     # on bach
nixos-rebuild switch --flake .#satie   # on satie
nix flake check                         # evaluate both configurations
```

Secrets decrypt at activation, not evaluation. Note that `env.cloudSettings.*` reads
git-agecrypt files under `secrets/sensitive/`; a full local `nix eval` of `bach` only
produces real values where that smudge filter is active.

## References

1. [Dendritic pattern](https://github.com/mightyiam/dendritic)
2. [https://github.com/carjorvaz/nixos](https://github.com/carjorvaz/nixos)
3. [https://github.com/diogotcorreia/dotfiles](https://github.com/diogotcorreia/dotfiles)
4. [https://github.com/librephoenix/nixos-config](https://github.com/librephoenix/nixos-config)
5. [https://github.com/Baitinq/nixos-config](https://github.com/Baitinq/nixos-config)

[flake-parts]: https://flake.parts
[import-tree]: https://github.com/vic/import-tree
