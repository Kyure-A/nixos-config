{ pkgs, inputs, ... }:
let
  bun2nix = pkgs.callPackage ../../inputs/bun2nix { inherit pkgs; };
  nixSweepPkg = inputs.nix-sweep.packages.${pkgs.stdenv.hostPlatform.system}.default;
  programs = import ./programs { inherit pkgs; };
in
{
  imports = programs ++ [
    inputs.emacs.homeModules.twist
    inputs.agent-skills.homeManagerModules.default
    inputs.nix-sweep.homeModules.default
    inputs.sheldon.homeManagerModules.default
  ];
  home.packages = import ./pkgs {
    inherit
      pkgs
      bun2nix
      nixSweepPkg
      ;
  };
  home.file = {
    ".claude/CLAUDE.md".source = ./AGENTS.md;
    ".codex/AGENTS.md".source = ./AGENTS.md;
    ".config/agents-md/template.md".source = ./AGENTS.md.template;
  };

  services.nix-sweep = {
    enable = true;
    package = nixSweepPkg;
    interval = "weekly";
    keepNewer = "7d";
    removeOlder = "30d";
    keepMin = 10;
  };
}
