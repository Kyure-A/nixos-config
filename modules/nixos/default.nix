{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  isWsl = (config ? wsl) && (config.wsl.enable or false);
in
{
  config = lib.mkMerge [
    {
      nixpkgs = {
        hostPlatform = lib.mkDefault "x86_64-linux";
        overlays = [
          inputs.bun2nix.overlays.default
          inputs.nur-packages.overlays.default
          (final: prev: {
            gnome2 = prev.gnome2.overrideScope (
              _gnomeFinal: gnomePrev: {
                gtksourceview = gnomePrev.gtksourceview.overrideAttrs (old: {
                  nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [ prev.gettext ];
                });
              }
            );
          })
          (
            final: prev:
            prev.lib.optionalAttrs (prev ? emacs-git) {
              emacs-git = prev.emacs-git.overrideAttrs (old: {
                patches = final.lib.filter (
                  patch:
                  let
                    patchName = builtins.baseNameOf (toString patch);
                    stalePatches = [
                      "fix-off-by-one-mistake-80851-CVE-2026-6861.patch"
                      "01_all_treesit-0.26.patch"
                      "02_all_ts-query-pred.patch"
                    ];
                  in
                  !(final.lib.any (name: final.lib.hasInfix name patchName) stalePatches)
                ) old.patches;
              });
            }
          )
          (final: _prev: {
            nodePackages = {
              inherit (final) typescript-language-server;
            };
          })
          inputs.rust-overlay.overlays.default
          inputs.fenix.overlays.default
          inputs.rustowl-flake.overlays.default
        ];
      };

      home-manager = {
        useUserPackages = true;
        useGlobalPkgs = true;
        extraSpecialArgs = { inherit inputs pkgs; };
      };

      nix = {
        settings = {
          experimental-features = [
            "nix-command"
            "flakes"
          ];
          trusted-users = [
            "root"
            "kyre"
          ];
        };
        optimise = {
          automatic = true;
          dates = [ "00:00" ];
        };
        gc = {
          automatic = true;
          dates = "weekly";
          options = "--delete-older-than 7d";
        };
      };

      networking = {
        hostName = "nixos";
        networkmanager.enable = true;
      };

      time.timeZone = "Asia/Tokyo";

      i18n = {
        defaultLocale = "en_US.UTF-8";
        extraLocaleSettings = {
          LC_ADDRESS = "en_US.UTF-8";
          LC_IDENTIFICATION = "en_US.UTF-8";
          LC_MEASUREMENT = "en_US.UTF-8";
          LC_MONETARY = "en_US.UTF-8";
          LC_NAME = "en_US.UTF-8";
          LC_NUMERIC = "en_US.UTF-8";
          LC_PAPER = "en_US.UTF-8";
          LC_TELEPHONE = "en_US.UTF-8";
          LC_TIME = "en_US.UTF-8";
        };
        inputMethod = {
          enable = true;
          type = "fcitx5";
          fcitx5.addons = with pkgs; [
            fcitx5-mozc
            fcitx5-anthy
          ];
        };
      };

      fonts = {
        packages = with pkgs; [
          noto-fonts-cjk-serif
          noto-fonts-cjk-sans
          noto-fonts-color-emoji
          nerd-fonts.fira-code
        ];
        fontDir.enable = true;
        fontconfig = {
          allowBitmaps = false;
          allowType1 = false;
          defaultFonts = {
            serif = [
              "Noto Serif CJK JP"
              "Noto Color Emoji"
            ];
            sansSerif = [
              "Noto Sans CJK JP"
              "Noto Color Emoji"
            ];
            monospace = [
              "FiraCode Nerd Font"
              "Noto Color Emoji"
            ];
            emoji = [ "Noto Color Emoji" ];
          };
        };
      };

      security.rtkit.enable = true;

      services = {
        xserver = {
          enable = true;
          displayManager = {
            gdm.enable = true;
          };
          xkb = {
            variant = "";
            layout = "us";
          };
        };
        pcscd.enable = true;
        printing.enable = true;
        pipewire = {
          enable = true;
          alsa.enable = true;
          alsa.support32Bit = true;
          pulse.enable = true;
        };
        pulseaudio.enable = false;
      };

      users.users.kyre = {
        isNormalUser = true;
        extraGroups = [
          "networkmanager"
          "wheel"
        ];
        shell = pkgs.zsh;
        useDefaultShell = true;
        packages = with pkgs; [ ];
      };

      programs = {
        zsh.enable = true;
        gnupg = {
          agent = {
            enable = true;
            pinentryPackage = pkgs.pinentry-all;
            enableSSHSupport = true;
          };
        };
      };

      system.stateVersion = "25.05";
    }
    (lib.mkIf (!isWsl) {
      boot = {
        loader.systemd-boot.enable = true;
        loader.efi.canTouchEfiVariables = true;
      };
      services.xserver.desktopManager.gnome.enable = true;
    })
  ];
}
