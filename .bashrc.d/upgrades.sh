do-upgrade() {
  sudo whoami
  #_upgrade_zoom_rpm
  sudo dnf update
  flatpak update
}
