#!/bin/bash

# method takes argument defining which screens and sinks to enable/diable
switch_display () {
  case "$1" in
    "desk")
      sink=alsa_output.pci-0000_00_1b.0.analog-stereo
      xrandr --output DVI-I-1 --mode 1920x1080 --pos 1920x0 --rotate normal \
             --output DVI-D-1 --mode 1920x1080 --pos 0x0 --rotate normal \
             --output DP-1 --off \
             --output HDMI-1 --off
      switch_sink $sink
      notify "desk" $sink
      ;;
    "tv")
      sink=alsa_output.pci-0000_01_00.1.hdmi-surround-extra1
      xrandr --output DVI-I-1 --off \
             --output DP-1 --off \
             --output DVI-D-1 --off \
             --output HDMI-1 --mode 1920x1080 --pos 0x0 --rotate normal 
      switch_sink $sink
      notify "TV" $sink
      ;;
    "all")
      sink=alsa_output.pci-0000_00_1b.0.analog-stereo
      xrandr --output DVI-I-1 --mode 1920x1080 --pos 1920x0 --rotate normal \
             --output DP-1 --off \
             --output HDMI-1 --mode 1920x1080 --pos 3840x0 --rotate normal \
             --output DVI-D-1 --mode 1920x1080 --pos 0x0 --rotate normal
      switch_sink $sink
      notify "All of them" $sink
      ;;
  esac
  exit
}

# set new default sink and move all streams.
# trimmed down version of paswitch found here: 
# http://www.freedesktop.org/wiki/Software/PulseAudio/FAQ/#index40h3
switch_sink () {

  # switch default sound card to next
  pacmd "set-default-sink $1" 

  # $inputs: A list of currently playing inputs
  inputs=$(pacmd list-sink-inputs | awk '$1 == "index:" {print $2}')
  for INPUT in $inputs; do # Move all current inputs to the new default sound card
    pacmd move-sink-input $INPUT $1
  done
  # $nextscdec: The device.description of the new default sound card
  # NOTE: This is the most likely thing to break in future, the awk lines may need playing around with
  #nextscdesc=$(pacmd list-sinks | awk '$1 == "device.description" {print substr($0,5+length($1 $2))}' \
                           #| sed 's|"||g' | awk -F"," 'NR==v1{print$0}' v1=$((nextind+1)))
  #notify-send "Default sound-card changed to $nextscdesc"
  #notify-send "Default sound-card changed to $nextscdesc"
  #exit
}

notify () {
  notify-send "Active monitor set to $1 \nDefault sound-card changed to $2" 
}

getopts "dta" optname
case "$optname" in
  "d")
    switch_display "desk"
  ;;
  "t")
    switch_display "tv"
  ;;
  "a")
    switch_display "all"
  ;;
  "?")
    echo "Unknown option $OPTARG"
  ;;
  ":")
    echo "No argument value for option $OPTARG"
  ;;
  *)
    echo "Unknown error while processing options"
  ;;
esac


 #name: <alsa_output.pci-0000_01_00.1.hdmi-surround-extra1>
 #name: <alsa_output.usb-Logitech_Logitech_Wireless_Headset_000D44FF5916-00.analog-stereo>
 #name: <alsa_output.pci-0000_00_1b.0.analog-stereo>

