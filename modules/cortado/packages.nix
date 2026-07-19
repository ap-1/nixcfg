{
  flake.modules.homeManager.cortado-packages = { pkgs, ... }: {
    home.packages = with pkgs; [
      colima
      container
      sshpass
      typst
      bun
      uv
      openbao
      ffmpeg-headless
      yt-dlp
      poppler-utils
      (proxmark3.override { hardwarePlatform = "PM3GENERIC"; })

      # remote dev box (mocha): durable mosh + tmux session
      mosh
      (writeShellScriptBin "dev" ''
        exec env LC_ALL=en_US.UTF-8 mosh \
          --ssh="ssh -o StrictHostKeyChecking=accept-new" \
          mocha.ts.anish.land -- \
          sh -c '
            tmux new-session -A -d -s main
            [ "$#" -gt 0 ] && d=$(zoxide query -- "$@") && tmux new-window -t main -c "$d"
            exec tmux attach -t main
          ' sh "$@"
      '')

      # applications
      shottr
      iina
    ];
  };
}
