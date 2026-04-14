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
          "auto-notify"
        ];
        theme = "robbyrussell";
      };
    };
    environment.shells = [ pkgs.zsh ];
    users.defaultUserShell = pkgs.zsh;
  };
}
