{
  lib,
  pkgs,
  config,
  ...
}:

{
  options = {
    zsh.enable = lib.mkEnableOption "enables zsh";
  };

  config = lib.mkIf config.zsh.enable {
    programs.zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestions.enable = true;
      syntaxHighlighting.enable = true;
      shellAliases = {
        rebuild = "sh /etc/nixos/scrips/nixos/nixos-rebuild.sh";
        update = "sh /etc/nixos/scrips/nixos/nixos-update.sh";
        commit = "sh /etc/nixos/scrips/nixos/nixos-commit.sh";
      };
      ohMyZsh = {
        enable = true;
        plugins = [
          "git"
          "direnv"
        ];
        theme = "robbyrussell";
      };
      interactiveShellInit = ''
        eval "$(devenv hook zsh)"
      '';
    };
    environment.shells = [ pkgs.zsh ];
    users.defaultUserShell = pkgs.zsh;
  };
}
