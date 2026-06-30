Devo mergiare le due repository così da collegare la configurazione del server e del mio PC. Poi, devo setuppare BORG/Restic/Kopia come backup solution, prima in locale (quindi su un PC a caso) e poi in remoto, magari pagando mensilmente/annualmente qualcosa

### 1. The "Fast Iteration" Approach: `mkOutOfStoreSymlink`
If your priority is **fast configuration** without rebuilding, this is the industry standard "hack." It creates a symlink from your home directory directly to a file in your local git repository, bypassing the Nix store.

*   **How it works:** You keep your dotfiles in a local folder (e.g., `~/dotfiles/config/hyprland.conf`) and link them in Home Manager.
*   **Pros:** Save the file, and the changes are live immediately. No `nixos-rebuild` or `home-manager switch` needed.
*   **Cons:** It is **impure**. The Nix configuration depends on files existing at a specific absolute path on your disk.

```nix name=home.nix
{ config, ... }:
{
  xdg.configFile."hypr/hyprland.conf".source = 
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/hypr/hyprland.conf";
    
  xdg.configFile."alacritty/alacritty.toml".source = 
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/alacritty/alacritty.toml";
}
```

### 2. The "Purely Declarative" Approach: Home Manager Modules
Most popular programs have dedicated Home Manager modules. You define the configuration as a Nix attribute set.

*   **How it works:** You use the `programs.<name>.settings` options.
*   **Pros:** Highly reproducible, type-safe, and allows you to use Nix variables (e.g., sharing a color palette across Hyprland and Alacritty).
*   **Cons:** **Slow.** Every tiny change requires a full `home-manager switch`.

```nix name=alacritty.nix
programs.alacritty = {
  enable = true;
  settings = {
    window.opacity = 0.9;
    font.size = 12;
    colors.primary.background = "#1a1b26";
  };
};
```

### 3. The Balanced Approach: Importing Local Files
You can keep your original `.conf` or `.toml` files inside your Flake repository and import them using the `source` attribute.

*   **How it works:** `xdg.configFile."hypr/hyprland.conf".source = ./configs/hyprland.conf;`
*   **Pros:** You get to use the native syntax of the program (syntax highlighting in your editor works better). It is 100% reproducible because the file is copied into the Nix store.
*   **Cons:** Still requires a rebuild to update the file in the store.

### 4. Handling External Repos (Git Submodules vs. Flake Inputs)
If you want to use someone else's config or a large theme:
*   **Flake Inputs:** Best for reproducibility. Add the repo to your `flake.nix` inputs. You can then reference `inputs.other-dotfiles.outPath`.
*   **Git Submodules:** Generally discouraged in the Nix ecosystem because Flakes handle external dependencies more natively and cleanly.

---

### Recommended Strategy
To get both **reproducibility** and **speed**, most power users follow this hybrid pattern:

1.  **For Stable Configs (Shells, Git, System Tools):** Use **Nix Modules**. You rarely change your `.gitconfig` or `zsh` aliases, so the rebuild time doesn't matter.
2.  **For Visual/Active Configs (Hyprland, Waybar, Neovim):** Use **`mkOutOfStoreSymlink`** during your "ricing" phase. 
3.  **The "Commit" Phase:** Once you are happy with a config, move the file into your Flake repo and switch from `mkOutOfStoreSymlink` to a relative `source = ./path/to/file;`. This makes it reproducible for your next machine.

**Pro-tip for fast rebuilds:**
If you find yourself rebuilding often, use **`nh`** (Nix Helper). It’s a CLI tool that makes `nixos-rebuild` and `home-manager` commands much faster and cleaner:
```bash
nh home switch . # Fast, shows diffs, and cleans old generations
```
