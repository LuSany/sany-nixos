{
  pkgs,
  nur-ryan4yin,
  ...
}: {
  # refer to https://codeberg.org/dnkl/foot/src/branch/master/foot.ini
  xdg.configFile."foot/foot.ini".text =
    ''
      [main]
      dpi-aware=yes
      font=JetBrainsMono Nerd Font:size=13
      shell=${pkgs.bash}/bin/bash --login -c 'nu --login --interactive'
      term=foot
      initial-window-size-pixels=3840x2160
      initial-window-mode=windowed
      pad=0x0                             # optionally append 'center'
      resize-delay-ms=10

      [mouse]
      hide-when-typing=yes
    ''
    + (builtins.readFile "${nur-ryan4yin.packages.${pkgs.system}.catppuccin-foot}/catppuccin-mocha.conf");

  home.packages = with pkgs; [
    # firefox-wayland
    firefox
    # nixpaks.firefox
    # nixpaks.firefox-desktop-item
    code-cursor # an AI code editor
    # microsoft-edge
    wpsoffice-cn
    onlyoffice-documentserver
    onlyoffice-desktopeditors
  ];

  programs = {
    # a wayland only terminal emulator
    foot = {
      enable = true;
      # foot can also be run in a server mode. In this mode, one process hosts multiple windows.
      # All Wayland communication, VT parsing and rendering is done in the server process.
      # New windows are opened by running footclient, which remains running until the terminal window is closed.
      #
      # Advantages to run foot in server mode including reduced memory footprint and startup time.
      # The downside is a performance penalty. If one window is very busy with, for example, producing output,
      # then other windows will suffer. Also, should the server process crash, all windows will be gone.
      server.enable = true;
    };

    # source code: https://github.com/nix-community/home-manager/blob/master/modules/programs/chromium.nix
    google-chrome = {
      enable = true;

      # https://wiki.archlinux.org/title/Chromium#Native_Wayland_support
      commandLineArgs = [
        "--ozone-platform-hint=auto"
        "--ozone-platform=wayland"
        # make it use GTK_IM_MODULE if it runs with Gtk4, so fcitx5 can work with it.
        # (only supported by chromium/chrome at this time, not electron)
        "--gtk-version=4"
        # make it use text-input-v1, which works for kwin 5.27 and weston
        "--enable-wayland-ime"

        # enable hardware acceleration - vulkan api
        # "--enable-features=Vulkan"
      ];
    };

    vscode = {
      enable = true;
      # let vscode sync and update its configuration & extensions across devices, using github account.
      profiles.default.userSettings = {};
      package =
        pkgs.vscode.override
        {
          isInsiders = false;
          # https://wiki.archlinux.org/title/Wayland#Electron
          commandLineArgs = [
            "--ozone-platform-hint=auto"
            "--ozone-platform=wayland"
            # make it use GTK_IM_MODULE if it runs with Gtk4, so fcitx5 can work with it.
            # (only supported by chromium/chrome at this time, not electron)
            "--gtk-version=4"
            # make it use text-input-v1, which works for kwin 5.27 and weston
            "--enable-wayland-ime"

            # TODO: fix https://github.com/microsoft/vscode/issues/187436
            # still not works...
            "--password-store=gnome" # use gnome-keyring as password store
          ];
        };
        profiles.default.extensions = with pkgs.vscode-extensions; [
          dracula-theme.theme-dracula
          # vscodevim.vim
          esbenp.prettier-vscode
          dbaeumer.vscode-eslint
          christian-kohler.path-intellisense
          # chrmarti.regex
          vincaslt.highlight-matching-tag
          gruntfuggly.todo-tree
          alefragnani.project-manager
          oderwat.indent-rainbow
          aaron-bond.better-comments
          formulahendry.code-runner
          formulahendry.auto-rename-tag
          # kisstkondoros.vscode-gutter-preview
          vscode-icons-team.vscode-icons
          yzhang.markdown-all-in-one
          shd101wyy.markdown-preview-enhanced
          davidanson.vscode-markdownlint
          eamodio.gitlens
          mhutchie.git-graph
          donjayamanne.githistory
          github.copilot-chat
          ms-python.python
          # kevinrose.vsc-python-indent
          vscjava.vscode-java-pack
          ms-vscode.cpptools-extension-pack
          bbenoist.nix
          ms-vscode-remote.remote-ssh
          ryu1kn.partial-diff
          # rvest.vs-code-prettier-eslint
          brettm12345.nixfmt-vscode
          jnoortheen.nix-ide
          # marscode.marscode-extension
          ms-vscode.cpptools-extension-pack
          continue.continue
          ms-windows-ai-studio.windows-ai-studio
          # saoudrizwan.claude-dev
          # snowords.open-any-url
          github.vscode-pull-request-github
          # wscats.cors-browser
        ];
    };
  };
}
