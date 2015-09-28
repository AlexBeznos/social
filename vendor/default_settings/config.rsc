#GoFriends......Go....Go....Go
/interface bridge
add name=bridge1
add name=bridge2
/ip address
add address=192.168.88.1/24 interface=bridge2
add address=172.16.16.1/24 interface=bridge1
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
set [ find default-name=wlan1 ] band=2ghz-b/g/n \
    disabled=no distance=indoors mode=ap-bridge \
    ssid="##ssid## | GoFriends WiFi"
/ip neighbor discovery
set ether1-gateway discover=no
/interface wireless security-profiles
add authentication-types=wpa-psk management-protection=allowed mode=\
    dynamic-keys name=profile1 wpa-pre-shared-key=gofriends98
/interface wireless
add disabled=no master-interface=\
    wlan1 name=wlan2 security-profile=profile1 ssid=Admin wds-default-bridge=\
    bridge2
/ip pool
add name=hs-pool-8 ranges=172.16.16.2-172.16.16.254
add name=pool1 ranges=192.168.88.2-192.168.88.254
/ip dhcp-server
add address-pool=hs-pool-8 disabled=no interface=bridge1 lease-time=1d name=\
    dhcp1
add address-pool=pool1 disabled=no interface=bridge2 name=server1
/ip hotspot user
add name=admin password=sp07tc
add name=##username## password=##password##
/ip hotspot profile
add dns-name=gofriends.com.ua/wifi/##slug## hotspot-address=172.16.16.1 login-by=\
    cookie,http-pap name=hsprof1
/ip hotspot user profile
set [ find default=yes ] idle-timeout=none keepalive-timeout=1d mac-cookie-timeout=1d \
session-timeout=1d shared-users=unlimited
/ip hotspot
add address-pool=hs-pool-8 disabled=no idle-timeout=none interface=bridge1 \
  name=hotspot1 profile=hsprof1
/interface bridge port
add bridge=bridge2 interface=ether2-master-local
add bridge=bridge1 interface=wlan1
add bridge=bridge2 interface=wlan2
/ip dhcp-client
add comment="default configuration" dhcp-options=hostname,clientid disabled=\
    no interface=ether1-gateway
/ip dhcp-server network
add address=172.16.16.0/24 dns-server=172.16.16.1 gateway=172.16.16.1
add address=192.168.88.0/24 comment="default configuration" dns-server=\
    192.168.88.1 gateway=192.168.88.1
/ip dns
set allow-remote-requests=yes servers=8.8.8.8
/ip dns static
add address=192.168.88.1 name=router
/ip firewall filter
add action=passthrough chain=unused-hs-chain comment=\
    "place hotspot rules here" disabled=yes
add action=passthrough chain=unused-hs-chain comment=\
    "place hotspot rules here" disabled=yes
/ip firewall nat
add action=passthrough chain=unused-hs-chain comment=\
    "place hotspot rules here" disabled=yes
add action=passthrough chain=unused-hs-chain comment=\
    "place hotspot rules here" disabled=yes to-addresses=0.0.0.0
add action=masquerade chain=srcnat comment="masquerade hotspot network" \
    src-address=172.16.16.0/24 to-addresses=0.0.0.0
add action=masquerade chain=srcnat comment="masquerade hotspot network" \
    src-address=192.168.88.0/24 to-addresses=0.0.0.0
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
/ip upnp
set allow-disable-external-interface=no
/system leds
set 0 interface=wlan1
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
