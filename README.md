# Nexus Node Runner (IDX)

- Định nghĩa môi trường qua **dev.nix**

- sh <(curl -L https://nixos.org/nix/install)
- source ~/.nix-profile/etc/profile.d/nix.sh
- nix-shell dev.nix


- Các lệnh:

➡ Dùng các lệnh sau:
   - start_nodes       - Khởi động tất cả node
   - stop_nodes        - Dừng tất cả node
   - status_nodes      - Xem trạng thái tmux session
   - logs_node <n>     - Xem log của node số n (vd: logs_node 2)
