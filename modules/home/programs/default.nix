{ pkgs, llmAgents }:
let
  alacritty = import ./alacritty;
  copilot-language-server = import ./copilot-language-server { inherit pkgs llmAgents; };
  ghostty = import ./ghostty;
  direnv = import ./direnv;
  emacs-twist = import ./emacs-twist;
  git = import ./git { inherit pkgs; };
  starship = import ./starship;
  tmux = import ./tmux { inherit pkgs; };
  zoxide = import ./zoxide;
  zsh = import ./zsh { inherit pkgs; };
  common = [
    copilot-language-server
    direnv
    emacs-twist
    git
    starship
    tmux
    zoxide
    zsh
  ];
  darwin =
    if pkgs.stdenv.isDarwin then
      [
        alacritty
        ghostty
      ]
    else
      [ ];
in
common ++ darwin
