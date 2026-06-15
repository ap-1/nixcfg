{
  flake.modules.homeManager.discord =
    { pkgs, inputs, ... }:
    {
      imports = [ inputs.moonlight.homeModules.default ];

      home.packages = [
        (pkgs.discord-canary.override {
          withMoonlight = true;
          moonlight = inputs.moonlight.packages.${pkgs.stdenv.hostPlatform.system}.moonlight;
        })
      ];

      programs.moonlight = {
        enable = true;
        configs.canary = {
          extensions = {
            moonbase.enabled = true;

            # theme
            customCSS = {
              enabled = true;
              config.css = ''@import url("https://catppuccin.github.io/discord/dist/catppuccin-mocha.theme.css");'';
            };

            # installed extensions
            allActivities.enabled = true;
            alwaysShowForwardTime.enabled = true;
            antinonce.enabled = true;
            betterEmbedsYT.enabled = true;
            betterTags.enabled = true;
            clearUrls.enabled = true;
            cloneExpressions.enabled = true;
            colorConsistency.enabled = true;
            copyAvatarUrl.enabled = true;
            copyWebp.enabled = true;
            dmCallLayout.enabled = true;
            domOptimizer.enabled = true;
            doubleClickActions.enabled = true;
            doubleClickToJoin.enabled = true;
            favouriteGifSearch.enabled = true;
            freeScreenShare.enabled = true;
            gameActivityToggle.enabled = true;
            inviteToNowhere.enabled = true;
            manyAccounts.enabled = true;
            mediaControls.enabled = true;
            mediaTweaks.enabled = true;
            memberCount.enabled = true;
            mentionAvatars.enabled = true;
            nameColor.enabled = true;
            noOnboardingDelay.enabled = true;
            ownerCrown.enabled = true;
            platformIcons.enabled = true;
            pronouns.enabled = true;
            quickDelete.enabled = true;
            replyChain.enabled = true;
            resolver.enabled = true;
            rpcObeysDetection.enabled = true;
            showMediaOptions.enabled = true;
            showReplySelf.enabled = true;
            showVoiceMemberCount.enabled = true;
            silenceTyping.enabled = true;
            spotifySpoof.enabled = true;
            typingTweaks.enabled = true;
            viewJson.enabled = true;
            voiceTextLink.enabled = true;
            volumeManipulator.enabled = true;
            whosWatching.enabled = true;
          };
        };
      };
    };
}
