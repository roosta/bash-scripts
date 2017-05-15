#!/usr/bin/env bash
#
#  Note: this script requires passwordless access to
#        poweroff, reboot, pm-suspend and pm-hibernate
#
# source: https://github.com/Airblader/dotfiles-manjaro/blob/master/.i3/i3exit

lock() {
  $HOME/.config/i3lock/i3lock.sh
}

case "$1" in
  lock)
    lock
    ;;
  logout)
    i3-msg exit
    ;;
  suspend)
#     lock && sudo pm-suspend
    lock && systemctl suspend
    ;;
  hibernate)
#     lock && sudo pm-hibernate
    lock && systemctl hibernate
    ;;
  reboot)
#     sudo reboot
    systemctl reboot
    ;;
  shutdown)
#     sudo poweroff
    systemctl poweroff
    ;;
  *)
    echo "Usage: $0 [lock|logout|suspend|hibernate|reboot|shutdown]"
    exit 2
esac

exit 0
