{ pkgs, ... }:

{
  channel = "stable-23.11";

  packages = [
    pkgs.tmux
    pkgs.htop
    pkgs.curl
    pkgs.git
    pkgs.bashInteractive
  ];

  idx.preLaunch = ''
    echo "🔧 Cài Nexus CLI..."
    curl -s https://cli.nexus.xyz/ | sh || echo "⚠️ Nexus CLI lỗi"

    cat > ~/node.sh << 'EOF'
#!/bin/bash
NODE_IDS=(13092137 13015832 13039637 12982602 13153315 13124535 13231841 12953433 12393681 12393691 12534723)
BASE_DIR=~/nexus-nodes
BINARY=~/.nexus/bin/nexus-network

start_nodes() {
  echo "🚀 Khởi động các node bằng tmux..."
  i=1
  for NODE_ID in "${NODE_IDS[@]}"; do
    SESSION="node$i"
    NODE_DIR="$BASE_DIR/$SESSION"
    mkdir -p "$NODE_DIR"
    if ! tmux has-session -t "$SESSION" 2>/dev/null; then
      tmux new-session -d -s "$SESSION" "cd $NODE_DIR && $BINARY start --node-id $NODE_ID | tee node.log"
      echo "✅ $SESSION node-id $NODE_ID ok"
    fi
    ((i++))
  done
}

stop_nodes() {
  echo "🛑 Dừng các node..."
  for i in {1..11}; do
    tmux kill-session -t "node$i" 2>/dev/null && echo "✅ node$i stopped"
  done
}

status_nodes() {
  tmux ls 2>/dev/null || echo "🧾 Không có session nào"
}

logs_node() {
  [ -z "$2" ] && { echo "logs <n>"; exit 1; }
  tmux attach -t "node$2" || echo "❌ Session node$2 không tồn tại"
}

case "$1" in
  start) start_nodes ;;
  stop) stop_nodes ;;
  status) status_nodes ;;
  logs) logs_node "$@" ;;
  *) echo "Usage: $0 {start|stop|status|logs <n>}";;
esac
EOF

    chmod +x ~/node.sh
    echo "✅ ~/node.sh created"
  '';
}
