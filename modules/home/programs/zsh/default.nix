{ pkgs }:
let
  load-zsh-defer = ''source "${pkgs.zsh-defer}/share/zsh-defer/zsh-defer.plugin.zsh"'';
  load-sheldon = ''
    eval "$(sheldon source)"
    if [[ $TERM != "dumb" ]]; then
       eval "$(sheldon completions --shell=zsh)"
    fi
  '';
  text = builtins.concatStringsSep "\n" [
    load-zsh-defer
    load-sheldon
  ];
in
{
  programs.zsh = {
    enable = true;
    # Ensure zsh-defer is available before sheldon applies deferred plugins.
    initContent = pkgs.lib.mkBefore text;
    profileExtra = ''
      eval "$(/opt/homebrew/bin/brew shellenv)"

      # Added by OrbStack: command-line tools and integration
      # This won't be added again if you remove it.
      source ~/.orbstack/shell/init.zsh 2>/dev/null || :
    '';
  };
}
