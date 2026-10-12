{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:

{
  languages.nix.enable = true;

  treefmt = {
    enable = true;

    config.programs = {
      nixfmt.enable = true;
      shfmt.enable = true;
      shellcheck.enable = true;
    };
  };

  git-hooks.hooks = {
    treefmt.enable = true;
    detect-private-keys.enable = true;
    check-added-large-files.enable = true;
    check-case-conflicts.enable = true;
    pre-commit-hook-ensure-sops.enable = true;
  };
}
