{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.modules.desktop.hyprland;
in {
  options.modules.desktop.hyprland = {
    nvidia = mkEnableOption "whether nvidia GPU is used";
  };

  config = mkIf (cfg.enable && cfg.nvidia) {
    wayland.windowManager.hyprland.settings.env = [
      # ### for hyprland with nvidia gpu, ref https://wiki.hyprland.org/Nvidia/      
      # Hardware acceleration on NVIDIA GPUs
      # (https://wiki.archlinux.org/title/Hardware_video_acceleration)
      "LIBVA_DRIVER_NAME,nvidia"
      
      "XDG_SESSION_TYPE,wayland"
      "GBM_BACKEND,nvidia-drm"
      "AQ_DRM_DEVICES,/dev/dri/card0:/dev/dri/card1"

      # To force GBM as a backend
      "__GLX_VENDOR_LIBRARY_NAME,nvidia"

      # TIP: Advantage is all the apps will be running on nvidia
      # WARN: crashes whatever window's opened after "hibranate"
      "__NV_PRIME_RENDER_OFFLOAD,1"
      
      # fix https://github.com/hyprwm/Hyprland/issues/1520
      "WLR_NO_HARDWARE_CURSORS,1"
      
      # Controls if G-Sync capable monitors should use Variable Refresh Rate (VRR)
      # See Nvidia Documentation for details.
      # (https://download.nvidia.com/XFree86/Linux-32bit-ARM/375.26/README/openglenvvariables.html)
      "__GL_GSYNC_ALLOWED,1"

      # Controls if Adaptive Sync should be used. Recommended to set as “0” to avoid
      # having problems on some games.
      "__GL_VRR_ALLOWED,1"

      # use legacy DRM interface instead of atomic mode setting. Might fix flickering
      # issues
      "WLR_DRM_NO_ATOMIC=1"
      
      "__VK_LAYER_NV_optimus,NVIDIA_only"
      "NVD_BACKEND,direct"

      # the line below may help with multiple monitors
      "WLR_EGL_NO_MODIFIERS,0"

      # software rendering backend 
      "WLR_RENDERER_ALLOW_SOFTWARE,1"
    ];
  };
}
