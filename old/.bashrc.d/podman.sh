#works with `act` local gha runner!
#systemctl enable --now --user podman.socket
#systemctl start --user podman.socket
#export DOCKER_HOST=unix://$XDG_RUNTIME_DIR/podman/podman.sock
#but it confuses root nomad fingerprinting the docker driver
