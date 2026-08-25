{ inputs, ... }:
let
  # --impure evaluation picks up the invoking user (SUDO_USER survives
  # `sudo darwin-rebuild switch`); pure evaluation falls back to "kyre".
  sudoUser = builtins.getEnv "SUDO_USER";
  envUser = builtins.getEnv "USER";
  username =
    if sudoUser != "" then
      sudoUser
    else if envUser != "" && envUser != "root" then
      envUser
    else
      "kyre";
in
{
  imports = [
    ../../modules/darwin
    inputs.home-manager.darwinModules.home-manager
  ];

  system.primaryUser = username;

  users.users.${username}.home = "/Users/${username}";

  home-manager = {
    users.${username} = import ./users/kyre/home-configuration.nix;
  };
}
