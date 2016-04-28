/interface bridge add name=GoFriends_Admin
/interface bridge port add bridge=GoFriends_Admin interface=ether4
/ip address add address=192.168.88.1/24 interface=GoFriends_Admin
/ip pool add name=GF-adm-pool ranges=192.168.88.100-192.168.88.200
/ip dhcp-server add disabled=no name=GF-adm-dhcp lease-time=30d address-pool=GF-adm-pool bootp-support=none interface=GoFriends_Admin
/ip dhcp-server network add address=192.168.88.0/24 dns-server=192.168.88.1 gateway=192.168.88.1 ntp-server=192.168.88.1
