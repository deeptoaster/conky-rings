# conky-rings

A simple ring layout for Conky

## Installation

Copy conkyrc to ~/.conkyrc and rings.lua to ~/.lua/scripts/rings.lua, then
start Conky.

## Configuration

Update the values under the `config` block in each file as appropriate.

conkyrc:

- `network_ethernet` is the name of your Ethernet device (which you can
  obtain through `ifconfig`)
- `network_wlan` is the name of your Wi-Fi device (which you can obtain
  through `ifconfig`)

rings.lua:

- `bg_color` and `bg_alpha` define the color of the background (unused or
  unoccupied) part of the ring.
- `fg_color` and `fg_alpha` define the color of the foreground (used or
  occupied) part of the ring.
- `network_ethernet` is the name of your Ethernet device (which you can
  obtain through `ifconfig`)
- `network_wlan` is the name of your Wi-Fi device (which you can obtain
  through `ifconfig`)
