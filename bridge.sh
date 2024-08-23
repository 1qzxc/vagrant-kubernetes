nmcli con add type bridge ifname br0 bridge.stp no
nmcli con mod bridge-br0 $(nmcli -f ipv4.method,ipv4.addresses,ipv4.gateway,ipv6.method,ipv6.addresses,ipv6.gateway con show em1 | grep -v -- -- | sed 's/: */ /')

