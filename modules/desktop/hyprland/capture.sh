# Hyprland capture binds (capture.lua) backend, and the waybar REC status

video_dir="${XDG_VIDEOS_DIR:-$HOME/Videos}"
rec_dir="$video_dir/Recordings"
replay_dir="$video_dir/Replays"
replay_monitor="DP-1" # primary
replay_seconds=30
fps=60
runtime="${XDG_RUNTIME_DIR:-/tmp}"
rec_pid="$runtime/capture-record.pid"
replay_pid="$runtime/capture-replay.pid"

note() { notify-send -a capture "$1" "${2:-}"; }
refresh_bar() { pkill -RTMIN+8 waybar 2>/dev/null || true; }

focused_monitor() { hyprctl monitors -j | jq -r '.[] | select(.focused) | .name'; }
# grim wants "X,Y WxH"
window_geom_grim() { hyprctl activewindow -j | jq -r '"\(.at[0]),\(.at[1]) \(.size[0])x\(.size[1])"'; }
# gsr -region wants "WxH+X+Y"
window_geom_region() { hyprctl activewindow -j | jq -r '"\(.size[0])x\(.size[1])+\(.at[0])+\(.at[1])"'; }

screenshot() {
  case "$1" in
    screen) grim - | wl-copy ;;
    region) grim -g "$(slurp)" - | wl-copy ;;
    window) grim -g "$(window_geom_grim)" - | wl-copy ;;
    *) return 1 ;;
  esac
  note "Screenshot copied" "$1"
}

record() {
  local target="$1"
  if [ -f "$rec_pid" ] && kill -SIGINT "$(cat "$rec_pid")" 2>/dev/null; then
    rm -f "$rec_pid"
    note "Recording saved"
    refresh_bar
    return
  fi
  mkdir -p "$rec_dir"
  local -a where
  case "$target" in
    screen) where=(-w "$(focused_monitor)") ;;
    region) where=(-w region -region "$(slurp -f '%wx%h+%x+%y')") ;;
    window) where=(-w region -region "$(window_geom_region)") ;;
    *) return 1 ;;
  esac
  local out
  out="$rec_dir/recording_$(date +%F_%H-%M-%S).mp4"
  gpu-screen-recorder "${where[@]}" -f "$fps" -a default_output -k h264 -c mp4 -o "$out" &
  local pid=$!
  echo "$pid" >"$rec_pid"
  sleep 0.5
  if kill -0 "$pid" 2>/dev/null; then
    note "Recording started" "$target"
  else
    rm -f "$rec_pid"
    note "Recording failed to start" "$target"
  fi
  refresh_bar
}

replay_daemon() {
  if [ -f "$replay_pid" ] && kill -0 "$(cat "$replay_pid")" 2>/dev/null; then
    return 0
  fi
  mkdir -p "$replay_dir"
  gpu-screen-recorder -w "$replay_monitor" -f "$fps" -a default_output \
    -k h264 -c mp4 -r "$replay_seconds" -o "$replay_dir" &
  echo $! >"$replay_pid"
}

replay_save() {
  if [ -f "$replay_pid" ] && kill -SIGUSR1 "$(cat "$replay_pid")" 2>/dev/null; then
    note "Replay saved" "last ${replay_seconds}s"
  else
    note "Replay buffer not running"
  fi
}

menu() {
  local choice
  choice=$(printf '%s\n' \
    'Screenshot: screen' 'Screenshot: region' 'Screenshot: window' \
    'Record: screen' 'Record: region' 'Record: window' \
    'Save replay' | rofi -dmenu -i -p Capture) || return 0
  case "$choice" in
    'Screenshot: screen') screenshot screen ;;
    'Screenshot: region') screenshot region ;;
    'Screenshot: window') screenshot window ;;
    'Record: screen') record screen ;;
    'Record: region') record region ;;
    'Record: window') record window ;;
    'Save replay') replay_save ;;
  esac
}

# feeds waybar custom/recording, refreshed via SIGRTMIN+8
status() {
  if [ -f "$rec_pid" ] && kill -0 "$(cat "$rec_pid")" 2>/dev/null; then
    printf '{"text":"REC","class":"recording","tooltip":"Recording in progress"}\n'
  else
    printf '{"text":""}\n'
  fi
}

case "${1:-}" in
  screenshot) screenshot "${2:-}" ;;
  record) record "${2:-}" ;;
  replay-save) replay_save ;;
  replay-daemon) replay_daemon ;;
  menu) menu ;;
  status) status ;;
  *)
    echo "usage: capture screenshot|record screen|region|window" >&2
    echo "       capture replay-save|replay-daemon|menu|status" >&2
    exit 1
    ;;
esac
