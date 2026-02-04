{
  pkgs,
  firefox-addons,
  ...
}:

{
  programs.firefox = {
    enable = true;
    package = pkgs.firefox-bin;

    policies = {
      DisableTelemetry = true;
      DisableFirefoxStudies = true;
    };

    profiles.default = {
      search = {
        force = true;
        default = "ddg";
      };

      extensions = {
        force = true;
        packages = with firefox-addons.packages.${pkgs.stdenv.hostPlatform.system}; [
          # YouTube
          # enhancer-for-youtube
          sponsorblock
          return-youtube-dislikes

          # Privacy
          ublock-origin
          decentraleyes
          # port-authority
          # duckduckgo-for-firefox

          # Misc
          bitwarden
          simple-tab-groups
        ];
      };

      containersForce = true;
      containers = {
        "Default" = {
          color = "turquoise";
          icon = "fingerprint";
          id = 1;
        };
        "ScottyLabs" = {
          color = "blue";
          icon = "briefcase";
          id = 2;
        };
      };

      settings = {
        # general
        "browser.startup.page" = 3; # Open previous windows and tabs
        "sidebar.verticalTabs" = true;

        # disable suggestions
        "browser.search.suggest.enabled" = false;
        "browser.urlbar.suggest.searches" = false;
        "browser.urlbar.showSearchSuggestionsFirst" = false;
        "browser.search.suggest.enabled.private" = false;
        "browser.urlbar.trending.featureGate" = false;
        "browser.urlbar.recentsearches.featureGate" = false;
        "browser.urlbar.suggest.quicksuggest.sponsored" = false;
        "browser.urlbar.suggest.quicksuggest.nonsponsored" = false;
        "browser.urlbar.quicksuggest.enabled" = false;
        "browser.urlbar.suggest.topsites" = false;
        "browser.urlbar.suggest.history" = false;
        "browser.urlbar.suggest.bookmark" = false;
        "browser.urlbar.suggest.openpage" = false;
        "browser.urlbar.suggest.engines" = false;
        "browser.urlbar.suggest.quickactions" = false;

        # privacy
        "privacy.globalprivacycontrol.enabled" = true;
        "signon.rememberSignons" = false;
        "extensions.formautofill.creditCards.enabled" = false;
        "extensions.formautofill.addresses.enabled" = false;
        "datareporting.healthreport.uploadEnabled" = false;
        "datareporting.policy.dataSubmissionEnabled" = false;
        "toolkit.telemetry.enabled" = false;
        "toolkit.telemetry.unified" = false;
        "toolkit.telemetry.archive.enabled" = false;
        "identity.fxaccounts.telemetry.clientAssociationPing.enabled" = false;

        # dns over https
        "network.trr.mode" = 2; # fall back to local (tailscale) on failure
        "network.trr.uri" = "https://mozilla.cloudflare-dns.com/dns-query";

        # gwfox theme requirements
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        "svg.context-properties.content.enabled" = true;
        "sidebar.animation.enabled" = false;
      }
      // pkgs.lib.optionalAttrs pkgs.stdenv.isLinux {
        "widget.use-xdg-desktop-portal.file-picker" = 1;
      }
      // pkgs.lib.optionalAttrs pkgs.stdenv.isDarwin {
        # also gwfox theme requirement
        "widget.macos.native-context-menus" = false;
      };

      userChrome = builtins.readFile (
        pkgs.fetchFromGitHub {
          owner = "akkva";
          repo = "gwfox";
          tag = "2.81";
          sha256 = "sha256-EBivjaSTXGwYpvs3WHmrEVa5TDiPpu8tXwRFoIpYBtw=";
        }
        + "/chrome/userChrome.css"
      );

      userContent = builtins.readFile (
        pkgs.fetchFromGitHub {
          owner = "akkva";
          repo = "gwfox";
          tag = "2.81";
          sha256 = "sha256-EBivjaSTXGwYpvs3WHmrEVa5TDiPpu8tXwRFoIpYBtw=";
        }
        + "/chrome/userContent.css"
      );
    };
  };
}
