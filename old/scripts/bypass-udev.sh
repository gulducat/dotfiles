# udev rules can get in the way of things.
# most recently, trying to format a usb drive so
# I can install latest fedora as required by IBM :|

# this script disables udev rules, executes whatever I need,
# then re-enables udev.

if [[ $# -eq 0 || "$@" =~ '-h' ]]; then
  echo 'pass args to wrap in udev-disablement'
  exit 1
fi

set -xu

# Bypass udev/udisks entirely with direct I/O
sudo systemctl stop udisks2
sudo udevadm control --stop-exec-queue

# Do the thing
eval "$@"

# Restart services
sudo udevadm control --start-exec-queue
sudo systemctl start udisks2 
