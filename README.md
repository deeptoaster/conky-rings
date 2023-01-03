# conky-rings

A simple ring layout for Conky

![](https://raw.githubusercontent.com/deeptoaster/conky-rings/master/screenshot.png)

## Installation

Copy _conkyrc_ to _~/.conkyrc_ and _rings.lua_ to _~/.lua/scripts/rings.lua_,
then start Conky (`conky --daemonize --pause=1`).

## Configuration

Update the values under the `config` block in each file as appropriate.

### _conkyrc_

- `network_ethernet` is the name of your Ethernet device (which you can
  obtain through `ifconfig`)
- `network_wlan` is the name of your Wi-Fi device (which you can obtain
  through `ifconfig`)

### _rings.lua_

- `bg_color` and `bg_alpha` define the color of the background (unused or
  unoccupied) part of the ring.
- `fg_color` and `fg_alpha` define the color of the foreground (used or
  occupied) part of the ring.
- `network_ethernet` is the name of your Ethernet device (which you can
  obtain through `ifconfig`)
- `network_wlan` is the name of your Wi-Fi device (which you can obtain
  through `ifconfig`)
