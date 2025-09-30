# Script MikroTik RouterOS para Honeypot Simples
# Adiciona IPs que tentam acessar portas comuns a uma blacklist.

/ip firewall address-list
add name=blacklist comment="Lista de IPs bloqueados pelo Honeypot"

/ip firewall filter
# Regra do HONEYPOT: Captura tentativas de acesso a portas comuns e adiciona à blacklist
# Portas monitoradas: FTP (21), SSH (22), Telnet (23), HTTP (80), HTTPS (443), Winbox (8291), HTTP Alternativo (8080)
add action=add-src-to-address-list address-list=blacklist address-list-timeout=7d \
    chain=input connection-state=new in-interface-list=WAN protocol=tcp \
    dst-port=21,22,23,80,443,8080,8291 comment="HONEYPOT - Captura e Bloqueia Atacantes"

# Regra para dropar o tráfego de IPs na blacklist
add action=drop chain=input src-address-list=blacklist comment="BLOQUEIA IPs na Blacklist (Honeypot)"
add action=drop chain=forward src-address-list=blacklist comment="BLOQUEIA IPs na Blacklist (Honeypot)"

# Opcional: Logar tentativas de acesso ao honeypot
# add action=log chain=input connection-state=new in-interface-list=WAN protocol=tcp \
#     dst-port=21,22,23,80,443,8080,8291 log-prefix="Honeypot_Hit" comment="Log Honeypot Attempts"
