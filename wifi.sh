# Étape 1 : Nettoyage des versions précédentes
echo "==> Suppression des anciennes versions du pilote..."
sudo dkms remove rtl8821cu/5.12.0.4 --all 2>/dev/null
sudo rm -rf /usr/src/rtl8821cu-5.12.0.4
echo "==> Nettoyage terminé."

# Étape 2 : Téléchargement des sources
echo "==> Téléchargement du pilote rtl8821cu..."
git clone https://github.com/brektrou/rtl8821CU.git /tmp/rtl8821CU
cd /tmp/rtl8821CU || exit 1

# Étape 3 : Copie des sources dans DKMS
echo "==> Ajout des sources au répertoire DKMS..."
sudo mkdir -p /usr/src/rtl8821cu-5.12.0.4
sudo cp -R . /usr/src/rtl8821cu-5.12.0.4

# Étape 4 : Ajout et compilation du module DKMS
echo "==> Ajout, construction et installation avec DKMS..."
sudo dkms add -m rtl8821cu -v 5.12.0.4
sudo dkms build -m rtl8821cu -v 5.12.0.4
sudo dkms install -m rtl8821cu -v 5.12.0.4

# Étape 5 : Chargement du module
echo "==> Chargement du module rtl8821cu..."
sudo modprobe 8821cu

# Étape 6 : Ajout du module au démarrage
echo "==> Configuration pour charger le module au démarrage..."
echo "8821cu" | sudo tee -a /etc/modules > /dev/null

# Étape 7 : Vérification
echo "==> Vérification de l'installation..."
if lsmod | grep -q "8821cu"; then
    echo "Le module rtl8821cu est installé et chargé avec succès !"
else
    echo "Erreur : le module rtl8821cu n'a pas été chargé correctement."
fi

# Nettoyage
echo "==> Nettoyage des fichiers temporaires..."
cd ~
rm -rf /tmp/rtl8821CU
