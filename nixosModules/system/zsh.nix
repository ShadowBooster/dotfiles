{
  lib,
  pkgs,
  config,
  ...
}:

{
  options = {
    programs.zsh.enable = lib.mkEnableOption "enables zsh";
  };

  config = lib.mkIf config.programs.zsh.enable {
    programs.zsh = {
      enable = true;
      autosuggestions.enable = true;
      syntaxHighlighting.enable = true;
      ohMyZsh = {
        enable = true;
        plugins = [
          "git"
          "direnv"
        ];
        theme = "robbyrussell";
      };
    };

    environment.shells = [ pkgs.zsh ];

    users.users.evelynvds.shell = pkgs.zsh;
  };
}
