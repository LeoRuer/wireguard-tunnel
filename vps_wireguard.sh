#!/bin/bash

# Configuration
WG_INTERFACE="wg0"
WG_SERVER_IP="10.0.0.1" #à modifier
WG_PORT=51820 #UDP
WG_CLIENT_IP="10.0.0.2/24" #à modifier
WG_SERVER_PUBLIC_KEY="<contenu_de_proxmox_public.key>"
WG_SERVER_ENDPOINT="<adresse_ip_de_proxmox>:$WG_PORT"

# Installer WireGuard
apt update && apt upgrade -y
apt install -y wireguard

# Générer les clés
umask 077
wg genkey | tee /etc/wireguard/vps_private.key | wg pubkey > /etc/wireguard/vps_public.key

# Lire les clés générées
CLIENT_PRIVATE_KEY=$(cat /etc/wireguard/vps_private.key)
CLIENT_PUBLIC_KEY=$(cat /etc/wireguard/vps_public.key)

# Créer le fichier de configuration
cat <<EOF > /etc/wireguard/$WG_INTERFACE.conf
[Interface]
Address = $WG_CLIENT_IP
PrivateKey = $CLIENT_PRIVATE_KEY

[Peer]
PublicKey = $WG_SERVER_PUBLIC_KEY
Endpoint = $WG_SERVER_ENDPOINT
AllowedIPs = 10.0.0.1/32
PersistentKeepalive = 25
EOF

# Activer et démarrer WireGuard
systemctl enable wg-quick@$WG_INTERFACE
systemctl start wg-quick@$WG_INTERFACE

#Interface web Proxmox depuis l'IP du VPS
iptables -t nat -A PREROUTING -p tcp --dport 8006 -j DNAT --to-destination 10.0.0.1:8006
iptables -A FORWARD -p tcp -d 10.0.0.1 --dport 8006 -j ACCEPT
#Ne pas oublier de remplacer les IP et d'autoriser le firewall ionos

#Sauvegarder les règles iptables
apt install iptables-persistent
netfilter-persistent save



echo "Configuration du client WireGuard terminée."
