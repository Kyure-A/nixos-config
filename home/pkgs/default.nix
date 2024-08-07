{ pkgs }:
with pkgs; [
  delta
  deno
  emacs-git
  emacs-lsp-booster
  eza
  ghq
  gnumake
  neofetch
  nixd
  nixpkgs-fmt
  nodePackages.typescript-language-server
  openssl
  rust-bin.stable.latest.default
  rust-analyzer
  satysfi
  tree-sitter
  zsh-defer
]
