{
  pkgs,
  lib,
  ...
}: {
  boot.loader.timeout = lib.mkForce 10; # wait for x seconds to select the boot entry

  environment.systemPackages = with pkgs; [
    wl-clipboard
    grim
    lmstudio
    cherry-studio
    qqmusic
    go-musicfox
    coze
    uv
  ];
}