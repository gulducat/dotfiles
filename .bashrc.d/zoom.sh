_upgrade_zoom_pkg() {
  echo -e 'if in doubt, download manually: https://zoom.us/download?os=linux\n'
  local remote_ver pkg

  remote_ver="$(curl -sS 'https://zoom.us/rest/download?os=linux' | jq -r '.result.downloadVO.zoom.version')"
  if [ -z "$remote_ver" ]; then
    echo '!! could not get remote version !!'
    return 1
  fi

  if dpkg -l zoom | grep "^ii.*$remote_ver"; then
    echo 'already on latest version'
    return
  fi

  pkg="$HOME/Downloads/apps/zoom_amd64_${remote_ver}.deb"
  if [ ! -f "$pkg" ]; then
    echo "downloading $remote_ver to $pkg"
    curl -Lo "$pkg" "https://zoom.us/client/${remote_ver}/zoom_amd64.deb"
  fi
  if [ ! -f "$pkg" ]; then
    echo '!! could not download pkg !!'
    return 1
  fi

  echo "apt install $pkg"
  sudo apt install "$pkg"
}

_upgrade_zoom_rpm() {
  echo -e 'if in doubt, download manually: https://zoom.us/download?os=linux\n'
  local remote_ver dest pkg

  remote_ver="$(curl -sS 'https://zoom.us/rest/download?os=linux' | jq -r '.result.downloadVO.zoom.version')"
  if [ -z "$remote_ver" ]; then
    echo '!! could not get remote version !!'
    return 1
  fi

  if dnf info --installed zoom | grep "$remote_ver$"; then
    echo 'already on latest version'
    return
  fi

  dest="$HOME/Downloads/apps"
  mkdir -p "$dest"
  pkg="$dest/zoom_amd64_${remote_ver}.rpm"
  if [ ! -f "$pkg" ]; then
    echo "downloading $remote_ver to $pkg"
    curl -Lo "$pkg" "https://zoom.us/client/${remote_ver}/zoom_x86_64.rpm"
  fi
  if [ ! -f "$pkg" ]; then
    echo '!! could not download pkg !!'
    return 1
  fi

  echo "dnf install install $pkg"
  sudo dnf install "$pkg"
}
