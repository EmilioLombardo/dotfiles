{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "emilio";
  home.homeDirectory = "/home/emilio";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "25.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello
    hello

    neofetch
    tree
    fzf
    tmux

    gcc

    zsh-powerlevel10k

    # dolphin

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
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    ".config/nvim".source = ./neovim/.config/nvim;
    ".tmux.conf".source = ./tmux/.tmux.conf;
    ".config/hypr".source = ./hyprland/.config/hypr;
    # ".p10k.zsh".source = ./powerlevel10k/.p10k.zsh;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  programs.git = {
    enable = true;
    settings.user = {
      name = "Emilio Lombardo";
      email = "emilomb3@gmail.com";
    };
  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    vimAlias = true;
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    shellAliases = {
      q = "exit";
      d = "dirs -v | head -10";
      # hm-switch = "home-manager switch --flake ~/.dotfiles";
    };
    plugins = [
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
    ];
    initContent = ''
      # type only name of directory = cd into that directory (e.g. type .. to go up a dir)
      setopt autocd
      # automatically pushd for each cd. allows cd +1 to go back to prev. dir
      setopt autopushd
      # remove duplicates from directory stack
      # (going back and forth between two dirs doesn't fill up the stack)
      setopt pushdignoredups
    '';
  };

  programs.tmux = {
    enable = true;
    shell = "${pkgs.zsh}/bin/zsh";
    terminal = "tmux-256color";
    keyMode = "vi";
    extraConfig = ''
      set-option -g update-environment "PATH"
    '';
  };

  programs.ghostty = {
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
  };

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
  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}

# vim: sts=2 sw=2
