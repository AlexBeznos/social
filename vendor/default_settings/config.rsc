# jan/21/2015 14:09:32 by RouterOS 6.15
# software id = 61TG-0USL
#
/certificate
add common-name=common-name country=it key-usage=\
    digital-signature,key-cert-sign,crl-sign locality=locality name=\
    common-name organization=organization state=state subject-alt-name=\
    DNS:my.local.net,IP:172.16.16.1,email:mail@kydaidem.ru unit=\
    organization-unit
/interface bridge
add l2mtu=1598 name=bridge1
add l2mtu=1598 name=bridge2
/interface wireless
set [ find default-name=wlan1 ] band=2ghz-b/g/n disabled=no l2mtu=2290 mode=ap-bridge ssid="##ssid##"
/ip hotspot profile
add dns-name=gofriends.com.ua/wifi/##slug## hotspot-address=172.16.16.1 login-by=\
    cookie,http-pap name=hsprof1
/ip hotspot user profile
set [ find default=yes ] idle-timeout=none keepalive-timeout=1d mac-cookie-timeout=1d \
    session-timeout=1d shared-users=unlimited
/ip pool
add name=hs-pool-8 ranges=172.16.16.2-172.16.31.254
add name=pool1 ranges=192.168.88.2-192.168.88.254
/ip dhcp-server
add address-pool=hs-pool-8 disabled=no interface=bridge1 lease-time=1d name=\
    dhcp1
add address-pool=pool1 disabled=no interface=bridge2 name=server1
/ip hotspot
add address-pool=hs-pool-8 disabled=no idle-timeout=none interface=bridge1 \
    name=hotspot1 profile=hsprof1
/interface bridge port
add bridge=bridge1 interface=ether4
add bridge=bridge1 interface=wlan1
add bridge=bridge2 interface=ether2
add bridge=bridge2 interface=ether3
/ip address
add address=172.16.16.1/20 interface=bridge1 network=172.16.16.0
add address=192.168.88.1/24 interface=bridge2 network=192.168.88.0
/ip dhcp-client
add default-route-distance=0 dhcp-options=hostname,clientid disabled=no \
    interface=ether1
/ip dhcp-server network
add address=172.16.16.0/20 comment="hotspot network" gateway=172.16.16.1
add address=192.168.88.0/24 dns-server=192.168.88.1 gateway=192.168.88.1
/ip dns
set allow-remote-requests=yes servers=8.8.8.8,8.8.4.4
/ip firewall filter
add action=passthrough chain=unused-hs-chain comment=\
    "place hotspot rules here" disabled=yes
/ip firewall nat
add action=passthrough chain=unused-hs-chain comment=\
    "place hotspot rules here" disabled=yes to-addresses=0.0.0.0
add action=masquerade chain=srcnat comment="masquerade hotspot network" \
    src-address=172.16.16.0/20 to-addresses=0.0.0.0
add action=masquerade chain=srcnat comment="masquerade hotspot network" \
    src-address=192.168.88.0/24 to-addresses=0.0.0.0
/ip hotspot user
add name=admin password=sp07tc
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
/ip upnp
set allow-disable-external-interface=no
/system leds
set 0 interface=wlan1
/tool mac-server
set [ find default=yes ] disabled=yes
add interface=ether2
add interface=ether3
/tool mac-server mac-winbox
set [ find default=yes ] disabled=yes
add interface=ether2
add interface=ether3
