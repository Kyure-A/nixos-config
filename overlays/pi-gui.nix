{ brew-nix }:
final: prev:
let
  # Mirror the upstream third-party cask through brew-nix's standard converter.
  piGuiCasks = import "${brew-nix}/casks.nix" {
    pkgs = final;
    brew-api = ./pi-gui;
  };
in
{
  brewCasks = prev.brewCasks // {
    pi-gui = piGuiCasks.pi-gui;
  };
}
