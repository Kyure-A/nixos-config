{ pkgs, llmAgents }:
let
  lib = pkgs.lib;
  copilot = llmAgents."copilot-language-server";
in
{
  home.packages = [ copilot ];

  home.sessionVariables = {
    COPILOT_LANGUAGE_SERVER_PATH = lib.getExe copilot;
  };
}
