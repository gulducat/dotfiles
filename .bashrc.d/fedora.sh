selinux-check() {
  echo 'https://docs.redhat.com/en/documentation/red_hat_enterprise_linux/8/html/using_selinux/troubleshooting-problems-related-to-selinux_using-selinux'
  sudo semodule -DB
  sudo ausearch -m AVC,USER_AVC,SELINUX_ERR,USER_SELINUX_ERR -ts recent
  sudo semodule -B
}

selinux-consul-connect() {
  ausearch -f consul_grpc.sock -ts recent --raw | audit2allow -M consul-grpc
  semodule -i consul-grpc.pp
}
