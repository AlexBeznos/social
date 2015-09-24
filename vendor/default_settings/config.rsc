# sep/22/2015 18:30:11 by RouterOS 6.23
# software id = XSP0-HN0R
#
/interface bridge
add name=bridge1
add admin-mac=4C:5E:0C:AF:19:EF auto-mac=no name=bridge2
/interface ethernet
set [ find default-name=ether1 ] name=ether1-gateway
set [ find default-name=ether2 ] name=ether2-master-local
set [ find default-name=ether3 ] master-port=ether2-master-local name=\
    ether3-slave-local
set [ find default-name=ether4 ] master-port=ether2-master-local name=\
    ether4-slave-local
set [ find default-name=ether5 ] master-port=ether2-master-local name=\
    ether5-slave-local
/interface wireless
set [ find default-name=wlan1 ] band=2ghz-b/g/n channel-width=\
    20/40mhz-ht-above disabled=no distance=indoors frequency=auto l2mtu=2290 \
    mode=ap-bridge ssid="##ssid## | GoFriends WiFi" wireless-protocol=802.11
/ip neighbor discovery
set ether1-gateway discover=no
/interface wireless security-profiles
set [ find default=yes ] authentication-types=wpa-psk,wpa2-psk \
    wpa-pre-shared-key=gofriends98 wpa2-pre-shared-key=gofriends98
add authentication-types=wpa-psk,wpa2-psk management-protection=allowed mode=\
    dynamic-keys name=profile1 wpa-pre-shared-key=gofriends98 \
    wpa2-pre-shared-key=gofriends98
/interface wireless
add disabled=no l2mtu=2290 mac-address=4E:5E:0C:AF:19:F3 master-interface=\
    wlan1 name=wlan2 security-profile=profile1 ssid=Admin wds-default-bridge=\
    bridge2
/ip hotspot profile
add dns-name=gofriends.com.ua/wifi/##slug## hotspot-address=\
    172.16.16.1 name=hsprof1
/ip hotspot user profile
set [ find default=yes ] keepalive-timeout=1d mac-cookie-timeout=1d \
    session-timeout=1d shared-users=unlimited
/ip pool
add name=default-dhcp ranges=192.168.88.10-192.168.88.254
add name=hs-pool-8 ranges=172.16.16.2-172.16.31.254
add name=pool1 ranges=192.168.88.2-192.168.88.254
/ip dhcp-server
add address-pool=default-dhcp disabled=no interface=bridge2 name=default
add address-pool=hs-pool-8 disabled=no interface=bridge1 lease-time=1d name=\
    dhcp1
/ip hotspot
add address-pool=hs-pool-8 disabled=no idle-timeout=none interface=bridge1 \
    name=hotspot1 profile=hsprof1
/interface bridge port
add bridge=bridge2 interface=ether2-master-local
add bridge=bridge2 interface=wlan2
add bridge=bridge1 interface=wlan1
/ip address
add address=192.168.88.1/24 comment="default configuration" interface=bridge2 \
    network=192.168.88.0
add address=172.16.16.1/20 interface=bridge1 network=172.16.16.0
/ip cloud
set enabled=yes
/ip dhcp-client
add comment="default configuration" dhcp-options=hostname,clientid disabled=\
    no interface=ether1-gateway
/ip dhcp-server network
add address=172.16.16.0/20 comment="hotspot network" gateway=172.16.16.1
add address=192.168.88.0/24 comment="default configuration" dns-server=\
    192.168.88.1 gateway=192.168.88.1
/ip dns
set allow-remote-requests=yes servers=8.8.8.8,8.8.4.4
/ip dns static
add address=192.168.88.1 name=router
/ip firewall filter
add chain=input comment="default configuration" protocol=icmp
add chain=input comment="default configuration" connection-state=
add action=drop chain=input comment="default configuration" in-interface=\
    ether1-gateway
add chain=forward comment="default configuration" connection-state=
add action=drop chain=forward comment="default configuration" \
    connection-state=invalid
add action=drop chain=forward comment="default configuration"
add action=passthrough chain=unused-hs-chain comment=\
    "place hotspot rules here" disabled=yes
/ip firewall nat
add action=masquerade chain=srcnat comment="default configuration" \
    out-interface=ether1-gateway
add action=passthrough chain=unused-hs-chain comment=\
    "place hotspot rules here" disabled=yes to-addresses=0.0.0.0
add action=masquerade chain=srcnat comment="masquerade hotspot network" \
    src-address=172.16.16.0/20 to-addresses=0.0.0.0
add action=masquerade chain=srcnat comment="masquerade hotspot network" \
    src-address=192.168.88.0/24 to-addresses=0.0.0.0
/ip hotspot user
add name=##username## password=##password##
/ip hotspot walled-garden
add dst-host=*facebook*
add dst-host=*gofriends.com.ua*
add dst-host=*gowifi-prod.s3.amazonaws.com*
add dst-host=*akamai*
add dst-host=*vk.com
add dst-host=*vk.me*
add dst-host=*googleapis*
add dst-host=*odnoklassniki*
add dst-host=*mycdn*
add dst-host=*.ok.ru
add dst-host=*twitter*
add dst-host=*twimg*
add dst-host=*facebook*
add dst-host=*akamai*
add dst-host=*gtld-servers.net
add dst-host=*verisign-grs.com
add dst-host=*edgecastcdn.net
add dst-host=*instagram.com
add dst-host=*google-analytics.com
/ip service
set telnet address=192.168.88.0/24
set ftp address=192.168.88.0/24
set www address=192.168.88.0/24
set ssh address=192.168.88.0/24
set api address=192.168.88.0/24
set winbox address=192.168.88.0/24
set api-ssl address=192.168.88.0/24
/system leds
set 0 interface=wlan1
set 5 interface=wlan1
/tool mac-server
set [ find default=yes ] disabled=yes
add interface=ether2-master-local
add interface=ether3-slave-local
add interface=ether4-slave-local
add interface=ether5-slave-local
add interface=wlan1
add interface=bridge2
/tool mac-server mac-winbox
set [ find default=yes ] disabled=yes
add interface=ether2-master-local
add interface=ether3-slave-local
add interface=ether4-slave-local
add interface=ether5-slave-local
add interface=wlan1
add interface=bridge2
