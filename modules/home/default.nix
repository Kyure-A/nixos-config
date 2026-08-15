{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  bun2nix = pkgs.callPackage ../../inputs/bun2nix { inherit pkgs; };
  llmAgents = inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system};
  programs = import ./programs { inherit pkgs llmAgents; };
  nhCleanArgs = [
    "--keep-since"
    "30d"
    "--keep"
    "1"
  ];
in
{
  imports = programs ++ [
    inputs.emacs.homeModules.twist
    inputs.agent-skills.homeManagerModules.default
    inputs.pi-config.homeManagerModules.default
    inputs.sheldon.homeManagerModules.default
  ];
  home.packages = import ./pkgs {
    inherit
      pkgs
      bun2nix
      llmAgents
      ;
  };
  home.file = {
    ".claude/CLAUDE.md".source = ./AGENTS.md;
    ".codex/AGENTS.md".source = ./AGENTS.md;
    ".config/agents-md/template.md".source = ./AGENTS.md.template;
  };

  programs.nh = {
    enable = true;
    clean = {
      enable = true;
      dates = "weekly";
      extraArgs = lib.concatStringsSep " " nhCleanArgs;
    };
  };

  # Home Manager passes extraArgs to launchd as one argument, so keep the
  # arguments separate on macOS.
  launchd.agents.nh-clean.config.ProgramArguments = lib.mkIf pkgs.stdenv.isDarwin (
    lib.mkForce (
      [
        (lib.getExe config.programs.nh.package)
        "clean"
        "user"
      ]
      ++ nhCleanArgs
    )
  );

  launchd.agents.raycast = lib.mkIf pkgs.stdenv.isDarwin {
    enable = true;
    config = {
      ProgramArguments = [
        "/usr/bin/open"
        "-g"
        "${pkgs.brewCasks.raycast}/Applications/Raycast.app"
      ];
      ProcessType = "Interactive";
      RunAtLoad = true;
    };
  };

  launchd.agents.ollama = lib.mkIf pkgs.stdenv.isDarwin {
    enable = true;
    config = {
      ProgramArguments = [
        (lib.getExe pkgs.ollama)
        "serve"
      ];
      EnvironmentVariables = {
        OLLAMA_CONTEXT_LENGTH = "32768";
        OLLAMA_FLASH_ATTENTION = "1";
        OLLAMA_KEEP_ALIVE = "10m";
        OLLAMA_KV_CACHE_TYPE = "q8_0";
      };
      KeepAlive = true;
      ProcessType = "Background";
      RunAtLoad = true;
    };
  };

  programs.pi-coding-agent = {
    settings = {
      defaultProvider = "ollama";
      defaultModel = "hf.co/unsloth/Qwen3.8-27B-GGUF:UD-Q4_K_XL";
      defaultThinkingLevel = "medium";
    };
    models.providers.ollama = {
      baseUrl = "http://localhost:11434/v1";
      api = "openai-completions";
      apiKey = "ollama";
      compat = {
        supportsDeveloperRole = false;
        supportsReasoningEffort = false;
      };
      models = [
        {
          id = "hf.co/unsloth/Qwen3.8-27B-GGUF:UD-Q4_K_XL";
          name = "Qwen3.8 27B UD-Q4_K_XL (Ollama)";
          reasoning = true;
          input = [
            "text"
            "image"
          ];
          contextWindow = 32768;
          maxTokens = 8192;
        }
      ];
    };
  };
}
