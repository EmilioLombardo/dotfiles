{ config, pkgs, ... }:

{
  home.username = "emilio";
  home.homeDirectory = "/home/emilio";

  # READ THIS BEFORE CHANGING home.stateVersion # {{{
  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  # }}}
  home.stateVersion = "25.05"; # Please read the comment before changing.

  home.packages = with pkgs; [
    # --- Terminal utilities ---
    neofetch tree fzf tmux zsh-powerlevel10k

    # --- Hyprland ---
    rofi waybar #dolphin

    # --- LSP ---
    lua-language-server
    python313Packages.python-lsp-server
    nixd
    #clangd

    # --- Other ---
    gcc

    # # Info: package overrides # {{{
    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
    # # }}}
  ];

  home.file = {
    ".config/nvim".source = ./neovim/.config/nvim;
    ".tmux.conf".source = ./tmux/.tmux.conf;
    ".config/hypr".source = ./hyprland/.config/hypr;
    ".config/waybar".source = ./waybar/.config/waybar;
  };

  programs.git = {# {{{
    enable = true;
    settings.user = {
      name = "Emilio Lombardo";
      email = "emilomb3@gmail.com";
      push.autoSetupRemote = true;
    };
  };# }}}

  programs.neovim = {# {{{
    enable = true;
    defaultEditor = true;
    vimAlias = true;
  };# }}}

  programs.zsh = { # {{{
    enable = true;
    enableCompletion = true;
    shellAliases = {
      q = "exit";
      d = "dirs -v | head -10";
    };
    plugins = [# {{{
    {
      name = "powerlevel10k-config";
      src = ./powerlevel10k;
      file = ".p10k.zsh";
    }
    {
      name = "zsh-powerlevel10k";
      src = "${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/";
      file = "powerlevel10k.zsh-theme";
    }
    { # Automatically use zsh when running nix-shell
      name = "zsh-nix-shell";
      file = "nix-shell.plugin.zsh";
      src = pkgs.fetchFromGitHub {
        owner = "chisui";
        repo = "zsh-nix-shell";
        rev = "v0.8.0";
        sha256 = "1lzrn0n4fxfcgg65v0qhnj7wnybybqzs4adz7xsrkgmcsr0ii8b7";
      };
    }
    ];# }}}
    initContent = ''
      # type only name of directory = cd into that directory (e.g. type .. to go up a dir)
      setopt autocd
      # automatically pushd for each cd. allows cd +1 to go back to prev. dir
      setopt autopushd
      # remove duplicates from directory stack
      # (going back and forth between two dirs doesn't fill up the stack)
      setopt pushdignoredups

      # zoxide: resolve symlinks before adding directories to the database
      export _ZO_RESOLVE_SYMLINKS=1
    '';
  }; # }}}

  programs.zoxide = {# {{{
    enable = true;
    enableZshIntegration = true;
    options = [
      "--cmd cd"
    ];
  };# }}}

  programs.tmux = {# {{{
    enable = true;
    shell = "${pkgs.zsh}/bin/zsh";
    terminal = "tmux-256color";
    keyMode = "vi";
    plugins = with pkgs; [
      tmuxPlugins.resurrect
      tmuxPlugins.continuum
    ];
    extraConfig = ''
      set-option -g update-environment "PATH"
    '';
  };# }}}

  programs.ghostty = {# {{{
    enable = true;
    enableZshIntegration = true;
    settings = {
      command = "/home/emilio/.nix-profile/bin/zsh";
      theme = "Monokai Remastered";
      font-family = "FiraCode Nerd Font";
      font-size = 14;
      cursor-color = "#fefefe";
      cursor-style = "block";
      adjust-cursor-thickness = 1;
      adjust-box-thickness = 1;
      background-opacity = 0.8;
    };
  };# }}}

  # Info: home.sessionVariables # {{{
  # 
  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/emilio/etc/profile.d/hm-session-vars.sh
  #
  # }}}
  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}

# vim: sts=2 sw=2 foldmethod=marker foldmarker={{{,}}}
