{
  lib,
  agent-skills,
  # personal,
  anthropic,
  vercel,
  find-skills,
  ...
}:
{
  imports = [
    (import "${agent-skills.outPath}/modules/home-manager/agent-skills.nix" {
      inherit lib;
      inputs = { };
    })
  ];

  programs.agent-skills = {
    enable = true;
    sources = {
      # personal = {
      #   path = personal;
      # };
      anthropic = {
        path = anthropic;
        subdir = "skills";
      };
      vercel = {
        path = vercel;
        subdir = "skills";
      };
      find-skills = {
        path = find-skills;
        subdir = "skills";
      };
    };
    skills.enable = [
      "doc-coauthoring"
      "find-skills"
      "pdf"
      "pptx"
      "skill-creator"
    ];
    # skills.enableAll = [ "personal" ];
    # "link" manages only the bundle's own entries via home.file, so skills
    # installed into the same directories by other tools (e.g. the self
    # repository's skills-install) are left untouched. copy-tree/symlink-tree
    # would rsync --delete them on every switch.
    targets = {
      codex = {
        dest = ".codex/skills";
        structure = "link";
      };
      claude = {
        dest = ".claude/skills";
        structure = "link";
      };
      pi = {
        dest = ".pi/agent/skills";
        structure = "link";
      };
    };
  };
}
