#GoFriends......Go....Go....Go

/file remove [ find name=auto-before-reset.backup ]
/file remove [ find name=preconfig.rsc ]

/interface bridge add name=GoFriends_WiFi
/interface bridge add name=GoFriends_Admin
/interface bridge port add bridge=GoFriends_WiFi interface=ether2
/interface bridge port add bridge=GoFriends_WiFi interface=ether3
/interface bridge port add bridge=GoFriends_WiFi interface=wlan1
/interface bridge port add bridge=GoFriends_Admin interface=ether4

/ip neighbor discovery set GoFriends_WiFi discover=no
/ip neighbor discovery set ether1 discover=no
/ip neighbor discovery set ether2 discover=no
/ip neighbor discovery set ether3 discover=no
/ip neighbor discovery set ether4 discover=no
/ip neighbor discovery set wlan1 discover=no

/ip dhcp-client add interface=ether1 default-route-distance=0 add-default-route=yes dhcp-options=hostname use-peer-dns=no use-peer-ntp=no disabled=no
/ip address add address=172.16.16.1/24 interface=GoFriends_WiFi
/ip address add address=192.168.88.1/24 interface=GoFriends_Admin

/interface wireless security-profiles add name=open authentication-types="" eap-methods="" supplicant-identity="" unicast-ciphers="" group-ciphers="" management-protection=disabled
/interface wireless security-profiles add name=WPA2-GF-Admin authentication-types=wpa2-psk mode=dynamic-keys wpa2-pre-shared-key=gOfriendS2016_GO eap-methods="" group-key-update=00:10:00 management-protection=disabled
/interface wireless nstreme set wlan1 enable-polling=no
/interface wireless set [ find default-name=wlan1 ] disabled=no mode=ap-bridge band="2ghz-b/g/n" security-profile=open
/interface wireless set [ find default-name=wlan1 ] wps-mode=disabled frequency=auto radio-name=GoFriends wireless-protocol=802.11 bridge-mode=disabled wds-mode=disabled wmm-support=enabled multicast-helper=full default-authentication=yes default-forwarding=no
/interface wireless set [ find default-name=wlan1 ] distance=indoors adaptive-noise-immunity=ap-and-client-mode basic-rates-a/g="" basic-rates-b="" guard-interval=long supported-rates-a/g=6Mbps,9Mbps,12Mbps,18Mbps,24Mbps,36Mbps,48Mbps,54Mbps supported-rates-b="" rate-set=configured ht-basic-mcs=""
/interface wireless set [ find default-name=wlan1 ] ssid=GoFriends
#/interface wireless set [ find default-name=wlan1 ] country=ukraine
# Железки MT используют обычно 1Вт передатчики (для примера сота ОпСоСа 10-40Вт), по законодательству Украины разрешено использовать точки доступа без регистрации не более 0.1Вт... Этот параметр надо настраивать в зависимости от страны.
#/interface wireless set [ find default-name=wlan1 ] tx-power-mode=manual-table tx-power=
/interface wireless add disabled=no name=gf-adm default-authentication=yes master-interface=wlan1 security-profile=WPA2-GF-Admin ssid=gf-adm wmm-support=enabled wps-mode=disabled
/interface bridge port add bridge=GoFriends_Admin interface=gf-adm
/ip neighbor discovery set gf-adm discover=no

/ip pool add name=GF-hotspot-pool ranges=172.16.16.5-172.16.16.254
/ip pool add name=GF-adm-pool ranges=192.168.88.100-192.168.88.200
/ip dhcp-server add disabled=no name=GF-hotspot-dhcp lease-time=2h address-pool=GF-hotspot-pool bootp-support=none interface=GoFriends_WiFi
/ip dhcp-server add disabled=no name=GF-adm-dhcp lease-time=30d address-pool=GF-adm-pool bootp-support=none interface=GoFriends_Admin
/ip dhcp-server network add address=172.16.16.0/24 dns-server=172.16.16.1 gateway=172.16.16.1 ntp-server=172.16.16.1
/ip dhcp-server network add address=192.168.88.0/24 dns-server=192.168.88.1 gateway=192.168.88.1 ntp-server=192.168.88.1

/ip firewall filter add action=drop chain=input dst-address=0.0.0.0/8
/ip firewall filter add action=drop chain=input dst-address=169.254.0.0/16
/ip firewall filter add action=drop chain=input dst-address=192.0.2.0/24
/ip firewall filter add action=drop chain=input dst-address=198.18.0.0/15
/ip firewall filter add action=drop chain=input dst-address=224.0.0.0/4
/ip firewall filter add action=drop chain=input dst-address=240.0.0.0/4
/ip firewall filter add action=drop chain=forward dst-address-list=Local out-interface=ether1
/ip firewall filter add chain=input dst-port=8291 in-interface=ether1 protocol=tcp
/ip firewall filter add chain=input connection-state=established
/ip firewall filter add chain=forward connection-state=established
/ip firewall filter add chain=output connection-state=established
/ip firewall filter add action=drop chain=input dst-port=53 in-interface=ether1 protocol=tcp
/ip firewall filter add action=drop chain=input dst-port=53 in-interface=ether1 protocol=udp

/ip firewall nat add action=masquerade chain=srcnat comment="GoFriends WiFi NAT out" src-address=172.16.16.0/24
/ip firewall nat add action=masquerade chain=srcnat comment="GoFriends adm NAT out" src-address=192.168.88.0/24

/ip hotspot profile add name=GoFriends_hotspot dns-name=gofriends.lan hotspot-address=172.16.16.1 html-directory=hotspot login-by=http-pap
/ip hotspot add disabled=no name=GoFriends_WiFi_srv address-pool=GF-hotspot-pool interface=GoFriends_WiFi profile=GoFriends_hotspot
/ip hotspot user profile add name=apple keepalive-timeout=10s queue-type=hotspot-default session-timeout=6s shared-users=unlimited status-autorefresh=1s
/ip hotspot user profile add name=guest queue-type=hotspot-default session-timeout=1d shared-users=unlimited
/ip hotspot user add name=guest password=guest profile=guest
/ip hotspot user add name=apple password=apple profile=apple

/ip hotspot walled-garden add dst-host=*facebook*
/ip hotspot walled-garden add dst-host=*gofriends.com.ua*
/ip hotspot walled-garden add dst-host=*gowifi-prod.s3.amazonaws.com*
/ip hotspot walled-garden add dst-host=*akamai*
/ip hotspot walled-garden add dst-host=*vk.com
/ip hotspot walled-garden add dst-host=*vk.me*
/ip hotspot walled-garden add dst-host=*googleapis*
/ip hotspot walled-garden add dst-host=*odnoklassniki*
/ip hotspot walled-garden add dst-host=*mycdn*
/ip hotspot walled-garden add dst-host=*.ok.ru
/ip hotspot walled-garden add dst-host=*twitter*
/ip hotspot walled-garden add dst-host=*twimg*
/ip hotspot walled-garden add dst-host=*facebook*
/ip hotspot walled-garden add dst-host=*akamai*
/ip hotspot walled-garden add dst-host=*gtld-servers.net
/ip hotspot walled-garden add dst-host=*verisign-grs.com
/ip hotspot walled-garden add dst-host=*edgecastcdn.net
/ip hotspot walled-garden add dst-host=*instagram.com
/ip hotspot walled-garden add dst-host=*google-analytics.com
/ip hotspot walled-garden add dst-host=*facebook*
/ip hotspot walled-garden add dst-host=*gofriends.com.ua*
/ip hotspot walled-garden add dst-host=*gowifi-prod.s3.amazonaws.com*
/ip hotspot walled-garden add dst-host=*akamai*
/ip hotspot walled-garden add dst-host=*vk.com
/ip hotspot walled-garden add dst-host=*vk.me*
/ip hotspot walled-garden add dst-host=*googleapis*
/ip hotspot walled-garden add dst-host=*odnoklassniki*
/ip hotspot walled-garden add dst-host=*mycdn*
/ip hotspot walled-garden add dst-host=*.ok.ru
/ip hotspot walled-garden add dst-host=*twitter*
/ip hotspot walled-garden add dst-host=*twimg*
/ip hotspot walled-garden add dst-host=*facebook*
/ip hotspot walled-garden add dst-host=*akamai*
/ip hotspot walled-garden add dst-host=*gtld-servers.net
/ip hotspot walled-garden add dst-host=*verisign-grs.com
/ip hotspot walled-garden add dst-host=*edgecastcdn.net
/ip hotspot walled-garden add dst-host=*instagram.com
/ip hotspot walled-garden add dst-host=*google-analytics.com

/ip dns set allow-remote-requests=yes servers=8.8.8.8,64.6.64.6
/ip service set telnet disabled=yes
/ip service set www disabled=yes
/ip service set api disabled=yes
/ip service set api-ssl disabled=yes
#/ip service set ftp disabled=yes
set ftp address=10.0.0.0/8,192.168.0.0/16

/queue tree add limit-at=60M max-limit=60M name=IN_packet parent=GoFriends_WiFi
/queue tree add name=OUT_packet parent=ether1
/queue type add kind=pcq name=PCQ_upload pcq-classifier=src-address
/queue type add kind=pcq name=PCQ_download pcq-classifier=dst-address pcq-limit=100KiB
/queue tree add limit-at=4M max-limit=50M name=IN_Hotspot packet-mark=IN_packets_to_Hotspot parent=IN_packet queue=PCQ_download
/queue tree add limit-at=4M max-limit=50M name=OUT_Hotspot packet-mark=OUT_packets_from_Hotspot parent=OUT_packet queue=PCQ_upload
/queue tree add limit-at=50M max-limit=50M name=HTTP_DL_BOOST packet-mark=http_dl_boost parent=IN_packet priority=2 queue=PCQ_download

/ip firewall mangle add action=add-src-to-address-list address-list=Hotspot_addr chain=prerouting in-interface=GoFriends_WiFi src-address=172.16.16.5-172.16.16.254
/ip firewall mangle add action=mark-connection chain=forward in-interface=ether1 new-connection-mark=IN out-interface=GoFriends_WiFi
/ip firewall mangle add action=mark-packet chain=forward comment=HTTP_DL_BOOST connection-bytes=0-2000000 connection-mark=IN new-packet-mark=http_dl_boost passthrough=no protocol=tcp src-port=80
/ip firewall mangle add action=mark-connection chain=forward connection-mark=IN dst-address-list=Hotspot_addr new-connection-mark=IN_to_Hotspot
/ip firewall mangle add action=mark-packet chain=forward connection-mark=IN_to_Hotspot new-packet-mark=IN_packets_to_Hotspot
/ip firewall mangle add action=mark-connection chain=forward in-interface=GoFriends_WiFi new-connection-mark=OUT out-interface=ether1
/ip firewall mangle add action=mark-connection chain=forward connection-mark=OUT new-connection-mark=OUT_from_Hotspot src-address-list=Hotspot_addr
/ip firewall mangle add action=mark-packet chain=forward connection-mark=OUT_from_Hotspot new-packet-mark=OUT_packets_from_Hotspot


/system clock set time-zone-name=Europe/Kiev
/system identity set name=GoFriends
/system ntp client set enabled=yes primary-ntp=216.239.32.15 secondary-ntp=216.239.34.15
/system ntp server set broadcast=yes broadcast-addresses=172.16.16.1,192.168.88.1 enabled=yes manycast=no
/tool bandwidth-server set enabled=no
/tool mac-server set [ find default=yes ] disabled=yes
/tool mac-server mac-winbox set [ find default=yes ] disabled=yes
/tool mac-server ping set enabled=no
#/tool mac-server mac-winbox add interface=ether1
/tool mac-server mac-winbox add interface=GoFriends_Admin

#ставим своего пользователя и пароль!
/user add name=GF password=12345 group=full
