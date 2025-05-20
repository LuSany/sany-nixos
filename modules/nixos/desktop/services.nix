{ pkgs, ... }:

{
  # Enable Services
  programs.direnv.enable = true;
  services.v2raya.enable = true;
}
