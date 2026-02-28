{ inputs, ... }:
{
  flake.modules.homeManager.firefox =
    { pkgs, ... }:
    {
      programs.firefox = {
        enable = true;
        package = pkgs.firefox-bin;

        policies = {
          DisableAppUpdate = true;
          DisableTelemetry = true;
          DisableFirefoxStudies = true;
          DNSOverHTTPS = {
            Enabled = true;
            ProviderURL = "https://mozilla.cloudflare-dns.com/dns-query";
            Fallback = true;
            Locked = true;
          };
        };

        profiles.default = {
          search = {
            force = true;
            default = "ddg";
          };

          extensions = {
            force = true;
            packages = with inputs.firefox-addons.packages.${pkgs.stdenv.hostPlatform.system}; [
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

          # privacy settings mostly adapted from https://brainfucksec.github.io/firefox-hardening-guide-2026
          settings = {
            # general
            "browser.startup.page" = 3; # Open previous windows and tabs
            "sidebar.verticalTabs" = true;
            "layout.css.prefers-color-scheme.content-override" = 0; # Use system theme

            # startup settings
            "browser.aboutConfig.showWarning" = false; # disable about:config warning
            "browser.toolbars.bookmarks.visibility" = "never"; # disable bookmarks
            "browser.newtabpage.activity-stream.showSponsored" = false; # disable sponsored content on Firefox Home
            "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
            "browser.newtabpage.activity-stream.showSponsoredCheckboxes" = false;
            "browser.newtabpage.activity-stream.default.sites" = ""; # clear default topsites

            # recommendations
            "extensions.getAddons.showPane" = false;
            "extensions.htmlaboutaddons.recommendations.enabled" = false;
            "browser.discovery.enabled" = false;

            # telemetry
            "browser.newtabpage.activity-stream.feeds.telemetry" = false; # disable Firefox Home
            "browser.newtabpage.activity-stream.telemetry" = false;
            "datareporting.policy.dataSubmissionEnabled" = false; # disable new data submission
            "datareporting.healthreport.uploadEnabled" = false; # disable Health Reports
            "toolkit.telemetry.enabled" = false; # disable general telemetry
            "toolkit.telemetry.unified" = false;
            "toolkit.telemetry.server" = "data:,";
            "toolkit.telemetry.archive.enabled" = false;
            "toolkit.telemetry.newProfilePing.enabled" = false;
            "toolkit.telemetry.shutdownPingSender.enabled" = false;
            "toolkit.telemetry.updatePing.enabled" = false;
            "toolkit.telemetry.bhrPing.enabled" = false; # (Background Hang Reporter)
            "toolkit.telemetry.firstShutdownPing.enabled" = false;
            "toolkit.telemetry.coverage.opt-out" = true;
            "identity.fxaccounts.telemetry.clientAssociationPing.enabled" = false;
            "toolkit.coverage.opt-out" = true;
            "toolkit.coverage.endpoint.base" = "";

            # studies
            "app.shield.optoutstudies.enabled" = false;
            "app.normandy.enabled" = false;
            "app.normandy.api_url" = "";

            # crash reports
            "breakpad.reportURL" = "";
            "browser.tabs.crashReporting.sendReport" = false;

            # search bar
            "browser.urlbar.showSearchSuggestionsFirst" = false;
            "browser.urlbar.quicksuggest.enabled" = false; # disable location bar contextual suggestions
            "browser.urlbar.suggest.quicksuggest.nonsponsored" = false;
            "browser.urlbar.suggest.quicksuggest.sponsored" = false;
            "browser.search.suggest.enabled" = false; # disable live search suggestions
            "browser.search.suggest.enabled.private" = false;
            "browser.urlbar.suggest.bookmark" = false;
            "browser.urlbar.suggest.engines" = false;
            "browser.urlbar.suggest.history" = false;
            "browser.urlbar.suggest.openpage" = false;
            "browser.urlbar.suggest.quickactions" = false;
            "browser.urlbar.suggest.searches" = false;
            "browser.urlbar.suggest.topsites" = false;
            "browser.urlbar.trending.featureGate" = false; # disable urlbar trending search suggestions
            "browser.urlbar.addons.featureGate" = false; # disable urlbar suggestions
            "browser.urlbar.amp.featureGate" = false;
            "browser.urlbar.mdn.featureGate" = false;
            "browser.urlbar.recentsearches.featureGate" = false;
            "browser.urlbar.weather.featureGate" = false;
            "browser.urlbar.wikipedia.featureGate" = false;
            "browser.urlbar.yelp.featureGate" = false;

            # passwords / forms
            "signon.rememberSignons" = false; # disable saving passwords
            "signon.autofillForms" = false; # disable autofill login and passwords
            "signon.formlessCapture.enabled" = false; # disable formless login capture for Password Manager
            "browser.formfill.enable" = false; # disable search and form history
            "extensions.formautofill.addresses.enabled" = false; # disable form autofill
            "extensions.formautofill.creditCards.enabled" = false;

            # downloads
            "browser.download.manager.addToRecentDocs" = false; # do not use system's "recent downloads" list
            "browser.download.always_ask_before_handling_new_types" = true; # always ask before handling new mimetypes

            # privacy
            "network.http.referer.XOriginTrimmingPolicy" = 2; # trim referrer to origin
            "browser.contentblocking.category" = "strict"; # Total Cookie Protection
            "privacy.globalprivacycontrol.enabled" = true;
            # "privacy.resistFingerprinting" = true; (disables dark mode)
            "privacy.resistFingerprinting.block_mozAddonManager" = true; # disable mozAddonManager Web API

            # enable webauth
            "security.webauth.u2f" = true;
            "security.webauth.webauthn" = true;
            "security.webauth.webauthn_enable_softtoken" = true;
            "security.webauth.webauthn_enable_usbtoken" = true;

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
              tag = "2.86";
              sha256 = "sha256-z2zTaD63mho050cdvzXygZ2TWHql67yfFOOh7ND1Okc=";
            }
            + "/chrome/userChrome.css"
          );

          userContent = builtins.readFile (
            pkgs.fetchFromGitHub {
              owner = "akkva";
              repo = "gwfox";
              tag = "2.86";
              sha256 = "sha256-z2zTaD63mho050cdvzXygZ2TWHql67yfFOOh7ND1Okc=";
            }
            + "/chrome/userContent.css"
          );
        };
      };
    };
}
