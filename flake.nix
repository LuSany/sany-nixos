{
  description = "Sany's Personal NixOS Configuration";

  outputs = inputs: import ./outputs inputs;

  # the nixConfig here only affects the flake itself, not the system configuration!
  # for more information, see:
  #     https://nixos-and-flakes.thiscute.world/nix-store/add-binary-cache-servers
  nixConfig = {
    # substituers will be appended to the default substituters when fetching packages
    extra-substituters = [
      "https://anyrun.cachix.org"
      # "https://nix-gaming.cachix.org"
      # "https://nixpkgs-wayland.cachix.org"
    ];
    extra-trusted-public-keys = [
      "sany-nixos.cachix.org-1:+AVG2Mr1Qgh3fyl/X6BmqbM+dxUKOdBVzlmhSkc187Q="
    ];
  };

  # This is the standard format for flake.nix. `inputs` are the dependencies of the flake,
  # Each item in `inputs` will be passed as a parameter to the `outputs` function after being pulled and built.
  inputs = {
    # #### Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.05";

    # #### ollama
    nixpkgs-ollama.url = "github:nixos/nixpkgs/nixos-unstable";

    # #### Home manager
    home-manager = {
      # url = "github:nix-community/home-manager/release-24.11";
      url = "github:nix-community/home-manager/master";

      # The `follows` keyword in inputs is used for inheritance.
      # Here, `inputs.nixpkgs` of home-manager is kept consistent with the `inputs.nixpkgs` of the current flake,
      # to avoid problems caused by different versions of nixpkgs dependencies.
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # #### Secure Boot for nixos
    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.4.2";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # #### Hardwafer
    nixos-hardware.url = "github:nixos/nixos-hardware/master";

    # #### Lets you choose what files and directories you want to keep between reboots
    impermanence.url = "github:nix-community/impermanence";

    # #### Community wayland nixpkgs
    # nixpkgs-wayland.url = "github:nix-community/nixpkgs-wayland";
    # #### anyrun - a wayland launcher
    anyrun = {
      url = "github:Kirottu/anyrun";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # #### generate iso/qcow2/docker/... image from nixos configuration
    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # secrets management
    agenix = {
      # lock with git commit at 0.15.0
      url = "github:ryantm/agenix/564595d0ad4be7277e07fa63b5a991b3c645655d";
      # replaced with a type-safe reimplementation to get a better error message and less bugs.
      # url = "github:ryan4yin/ragenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-gaming.url = "github:fufexan/nix-gaming";

    disko = {
      url = "github:nix-community/disko/v1.11.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # add git hooks to format nix code before commit
    pre-commit-hooks = {
      url = "github:cachix/pre-commit-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # #### Nushell environment for Nix
    nuenv.url = "github:DeterminateSystems/nuenv";

    # #### Filesystem-based module system for Nix
    haumea = {
      url = "github:nix-community/haumea/v0.2.2";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # ####Shameless plug: looking for a way to nixify your themes and make everything match nicely? Try nix-colors!
    nix-colors.url = "github:misterio77/nix-colors";

    # ####nur
    nur.url = "github:nix-community/NUR";

    # ####nixpkgs-python
    nixpkgs-python.url = "github:cachix/nixpkgs-python";

    # #### nixpak
    nixpak = {
      url = "github:nixpak/nixpak";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # #### terminal emulator 
    ghostty = {
      url = "github:ghostty-org/ghostty";
    };

    blender-bin.url = "github:edolstra/nix-warez?dir=blender";


    ########################  Some non-flake repositories  #########################################
    polybar-themes = {
      url = "github:adi1090x/polybar-themes";
      flake = false;
    };

    ########################  My own repositories  #########################################
    # my wallpapers
    wallpapers = {
      url = "github:ryan4yin/wallpapers";
      flake = false;
    };

    nur-ryan4yin.url = "github:ryan4yin/nur-packages";
    nur-ataraxiasjel.url = "github:AtaraxiaSjel/nur";
  };
}
