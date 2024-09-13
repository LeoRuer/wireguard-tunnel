<div align="center">
    <img src="https://www.2-remove-virus.com/wp-content/uploads/2022/08/WireGuard.png" alt="Logo" width="784" height="292">
  </a>
</div>

# Tunnel Wireguard 🐲

Ce dépôt contient des scripts pour configurer un tunnel WireGuard entre un serveur Proxmox et un VPS.

## Instructions

1. **Transférez les scripts** vers chaque machine (serveur Proxmox et VPS).

2. **Rendez les scripts exécutables** :

   ```bash
   chmod +x /chemin/vers/proxmox_wireguard.sh
   chmod +x /chemin/vers/vps_wireguard.sh

# Dépannage
- Assurez-vous que les pare-feu sur les deux machines permettent le trafic sur le port WireGuard (51820 en UDP).
- Vérifier les IP et la notation CIDR.
- Vérifiez les journaux WireGuard pour toute erreur avec ```journalctl -u wg-quick@wg0```.
- Article 22 (TMTC).
- [Ceci](https://superuser.com/questions/1770829/how-to-setup-a-vpn-tunnel-using-wireguard) peut aider, ou encore [celui là](https://www.ionos.fr/digitalguide/serveur/outils/wireguard-vpn-principes-de-base/)
