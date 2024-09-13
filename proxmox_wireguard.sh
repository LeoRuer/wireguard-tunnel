#!/bin/bash

# Configuration
WG_INTERFACE="wg0"
WG_PORT=51820 #UDP
WG_SERVER_IP="10.0.0.1/24" #à modifier
WG_PEER_PUBLIC_KEY="<contenu_de_vps_public.key>"

# Installer WireGuard
apt update && apt upgrade -y
apt install -y wireguard

# Générer les clés
umask 077
wg genkey | tee /etc/wireguard/proxmox_private.key | wg pubkey > /etc/wireguard/proxmox_public.key

# Lire les clés générées
SERVER_PRIVATE_KEY=$(cat /etc/wireguard/proxmox_private.key)
SERVER_PUBLIC_KEY=$(cat /etc/wireguard/proxmox_public.key)

# Créer le fichier de configuration
cat <<EOF > /etc/wireguard/$WG_INTERFACE.conf
[Interface]
Address = $WG_SERVER_IP
PrivateKey = $SERVER_PRIVATE_KEY
ListenPort = $WG_PORT

[Peer]
PublicKey = $WG_PEER_PUBLIC_KEY
AllowedIPs = 10.0.0.2/32
EOF

# Activer démarrer WireGuard
systemctl enable wg-quick@$WG_INTERFACE
systemctl start wg-quick@$WG_INTERFACE

# Activer le routage IP
sed -i '/net.ipv4.ip_forward = 1/d' /etc/sysctl.conf
echo 'net.ipv4.ip_forward = 1' >> /etc/sysctl.conf
sysctl -p

echo "Configuration du serveur WireGuard terminée."
