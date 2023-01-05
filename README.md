# conky-rings

A simple ring layout for Conky

![](https://raw.githubusercontent.com/deeptoaster/conky-rings/master/screenshot.png)

## Installation

1.  Install [Conky](https://github.com/brndnmtthws/conky/wiki/Installation#conky-on-operating-systems).
2.  Install the [Neuropol font](https://www.dafont.com/neuropol.font) (optional).
3.  Copy _conkyrc_ to _~/.conkyrc_ and _rings.lua_ to _~/.lua/scripts/rings.lua_.
4.  Start Conky.

On Debian- and Ubuntu-based systems, you can run the following commands:

```
sudo apt install conky
git clone https://github.com/deeptoaster/conky-rings.git
ln -rs conky-rings/conkyrc ~/.conkyrc
mkdir -p ~/.lua/scripts
ln -rs conky-rings/rings.lua ~/.lua/scripts/rings.lua
conky --daemonize --pause=1
```

## Configuration

Update the values under the `config` block in each file as appropriate.

### _conkyrc_

- `network_ethernet` is the name of your Ethernet device (which you can
  obtain through `ip link`)
- `network_wlan` is the name of your Wi-Fi device (which you can obtain
  through `ip link`)

### _rings.lua_

- `bg_color` and `bg_alpha` define the color of the background (unused or
  unoccupied) part of the ring.
- `fg_color_override` and `fg_alpha` define the color of the foreground (used
  or occupied) part of the ring. If `fg_color_override` is `nil`, four default
  colors are used, as shown in the screenshot above.
- `network_ethernet` is the name of your Ethernet device (which you can
  obtain through `ip link`)
- `network_wlan` is the name of your Wi-Fi device (which you can obtain
  through `ip link`)
