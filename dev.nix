with import <nixpkgs> {};

mkShell {
  name = "nexus-dev-env";
  buildInputs = [
    git
    tmux
    bash
    coreutils
    curl
  ];

  shellHook = ''
    echo "✅ Welcome to Nexus Dev Shell"

    # Cài Nexus CLI nếu chưa có
    if ! command -v nexus-network >/dev/null 2>&1; then
      echo "🔧 Cài Nexus CLI..."
      curl -s https://cli.nexus.xyz/ | sh || echo "⚠️ Nexus CLI lỗi"
    fi

    export BASE_DIR=$PWD/nodes
    export BINARY=~/.nexus/bin/nexus-network
    export NODE_IDS="16617818 16730538 16893236 16950341 16980199 16815174 16617953 16864458 16864460 16893385"

    start_nodes() {
      echo "🚀 Khởi động các node bằng tmux..."
      i=1
      for NODE_ID in $NODE_IDS; do
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
      echo "📋 Danh sách các node đang chạy:"
      tmux ls 2>/dev/null || echo "🧾 Không có session nào"
    }

    logs_node() {
      if [ -z "$1" ]; then
        echo "❌ Dùng: logs_node <n>"; return 1;
      fi
      tmux attach -t "node$1" || echo "❌ Session node$1 không tồn tại"
    }

    echo ""
    echo "➡ Dùng các lệnh sau:"
    echo "   start_nodes       - Khởi động tất cả node"
    echo "   stop_nodes        - Dừng tất cả node"
    echo "   status_nodes      - Xem trạng thái tmux session"
    echo "   logs_node <n>     - Xem log của node số n (vd: logs_node 2)"
    echo ""
  '';
}
