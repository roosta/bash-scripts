# Used with polybar to display a colored label that indicated if VPN is active
# https://github.com/roosta/etc/tree/master/conf/polybar
# Author: Daniel Berg <mail@roosta.sh>

tunnel=$(ip link show|awk '/(tun|pon)/{print substr($2, 1, 4)}')
# if [[ ! -z $tunnel ]]; then
#   echo "%{F#98BC37} %{F-}"
# else
#   echo "%{F#F75341} %{F-}"
# fi

if [[ ! -z $tunnel ]]; then
  echo "%{F#98BC37}VPN%{F-}"
else
  echo "%{F#F75341}No VPN!%{F-}"
fi
