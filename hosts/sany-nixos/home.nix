{
  modules.desktop = {
    hyprland = {
      nvidia = true;
      settings = {
        # Configure your Display resolution, offset, scale and Monitors here, use `hyprctl monitors` to get the info.
        #   highres:      get the best possible resolution
        #   auto:         position automatically
        #   auto:         auto scale 
        #   bitdepth,10:  enable 10 bit support
        monitor = "DP-1,highres,auto,auto,bitdepth,10";
      };
    };
  };

  programs.ssh = {
    enable = true;
    # extraConfig = ''
    #   Host github.com
    #       IdentityFile ~/.ssh/id_ed25519
    #       # Specifies that ssh should only use the identity file explicitly configured above
    #       # required to prevent sending default identity files first.
    #       IdentitiesOnly yes
    # '';
  };
}
