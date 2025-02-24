#!/bin/bash

# Affichage des mentions légales
echo "================================================="
echo "                    Ordinateur Solidaire"
echo "================================================="
echo "Ce script est fourni par Lelièvre Antoine dans le cadre de ces missions de conseiller numérique à la Ville de Poitiers."
echo "L'utilisation de ce script est soumise aux conditions suivantes :"
echo "- Ce script est fourni 'tel quel', sans aucune garantie."
echo "- L'utilisateur est responsable de l'utilisation de ce script."
echo "================================================="
echo ""

# Répertoire du bureau de l'utilisateur
BUREAU=~/Bureau

# Créer le répertoire Bureau si ce n'est pas déjà fait
mkdir -p $BUREAU

# Fonction pour créer un fichier .desktop
creer_raccourci() {
    nom_application=$1
    fichier_raccourci=$BUREAU/$nom_application.desktop

    # Détection du fichier .desktop et de l'icône en fonction de l'application
    if [ "$nom_application" == "OnlyOffice Word" ]; then
        fichier_application="/usr/share/applications/Word.desktop"  # Fichier pour OnlyOffice Word
    elif [ "$nom_application" == "Firefox" ]; then
        fichier_application="/usr/share/applications/firefox.desktop"
    elif [ "$nom_application" == "Dolphin" ]; then
        fichier_application="/usr/share/applications/org.kde.dolphin.desktop"  # Fichier pour Dolphin
    elif [ "$nom_application" == "VLC" ]; then
        fichier_application="/usr/share/applications/vlc.desktop"  # Fichier pour VLC
    elif [ "$nom_application" == "OnlyOffice Excel" ]; then
        fichier_application="/usr/share/applications/Excel.desktop"  # Fichier pour OnlyOffice Excel
    else
        fichier_application="/usr/share/applications/$nom_application.desktop"
    fi

    # Vérifier si le fichier .desktop existe avant de le copier
    if [ -f "$fichier_application" ]; then
        cp "$fichier_application" "$fichier_raccourci"
        echo "Raccourci créé pour $nom_application."
    else
        echo "Erreur : Le fichier .desktop de $nom_application n'a pas été trouvé."
    fi

    # Vérifier si le fichier .desktop a bien été copié avant de le rendre exécutable
    if [ -f "$fichier_raccourci" ]; then
        chmod +x "$fichier_raccourci"
    else
        echo "Erreur : Le fichier .desktop pour $nom_application n'a pas pu être créé."
    fi
}

# Fonction pour installer une application via apt si elle n'est pas installée
installer_application() {
    app_name=$1
    paquet=$2

    if ! command -v $app_name &> /dev/null
    then
        echo "$app_name n'est pas installé. Installation en cours..."
        sudo apt update
        sudo apt install -y $paquet
    else
        echo "$app_name est déjà installé."
    fi
}

# Fonction pour désactiver OneDrive et supprimer ses sources de mise à jour
desactiver_onedrive() {
    echo "Désactivation de la source de mise à jour de OneDrive en priorité..."
    # Suppression de la source OneDrive
    sudo rm -f /etc/apt/sources.list.d/onedrive.list

    # Vérification si OneDrive est installé et suppression complète
    if command -v onedrive &> /dev/null
    then
        echo "OneDrive est installé. Suppression en cours..."
        
        # Désinstallation complète de OneDrive
        sudo apt remove --purge -y onedrive
        sudo apt autoremove -y
        
        # Suppression des fichiers de configuration de OneDrive
        rm -rf ~/.config/onedrive
        rm -rf ~/OneDrive
        
        # Supprimer le fichier .desktop de OneDrive dans /usr/share/applications/
        sudo rm -f /usr/share/applications/onedrive.desktop
        
        # Supprimer le dossier d'installation de OneDrive (si installé manuellement ou par un autre moyen)
        sudo rm -rf /opt/onedrive
        
        echo "OneDrive a été complètement supprimé."
    else
        echo "OneDrive n'est pas installé."
    fi
}

# Fonction pour supprimer Microsoft Edge et ses raccourcis
supprimer_edge() {
    echo "Suppression de Microsoft Edge et de ses raccourcis..."
    
    # Supprimer le fichier .desktop de Microsoft Edge
    rm -f "$BUREAU/microsoft-edge.desktop"
    sudo rm -f /usr/share/applications/microsoft-edge.desktop
    
    # Supprimer les icônes dans le dock ou la barre des tâches (selon l'environnement)
    rm -f ~/.local/share/applications/microsoft-edge.desktop
    echo "Icône de Microsoft Edge supprimée du bureau et de la barre des tâches."

    # Supprimer Edge s'il est installé
    if command -v microsoft-edge &> /dev/null; then
        sudo apt remove --purge -y microsoft-edge-stable
        sudo apt autoremove -y
        echo "Microsoft Edge désinstallé."
    else
        echo "Microsoft Edge n'est pas installé."
    fi
}

# Fonction pour ajouter Firefox à la barre des tâches et aux favoris Plasma
ajouter_firefox_plasma() {
    echo "Ajout de Firefox à la barre des tâches (Plasma) et aux favoris..."

    # Créer un raccourci .desktop pour Firefox dans le répertoire approprié
    cp /usr/share/applications/firefox.desktop ~/.local/share/applications/firefox.desktop

    # Ajouter Firefox à la barre des tâches sous KDE Plasma (Only Icon Task Manager)
    plasmapkg2 -t PlasmaApp /usr/share/applications/firefox.desktop

    # Ajouter Firefox dans le menu démarrer (Kicker) dans les favoris
    # Utilisation de `kwriteconfig5` pour ajouter Firefox aux favoris dans le menu Kicker
    kwriteconfig5 --file ~/.config/plasma-org.kde.plasma.desktop-appletsrc "FavoriteApps" "firefox.desktop"
    echo "Firefox ajouté à la barre des tâches et aux favoris."
}

# Récupérer le nom de l'ordinateur
nom_ordinateur=$(hostname)

# Récupérer le numéro de série
# Sur Linux, on utilise la commande dmidecode pour obtenir le numéro de série
num_serie=$(sudo dmidecode -t system | grep "Serial Number" | awk -F: '{print $2}' | xargs)

# Récupérer la marque et le modèle de l'ordinateur
marque_ordinateur=$(sudo dmidecode -t system | grep "Manufacturer" | awk -F: '{print $2}' | xargs)
modele_ordinateur=$(sudo dmidecode -t system | grep "Product Name" | awk -F: '{print $2}' | xargs)

# Récupérer le processeur
processeur=$(sudo dmidecode -t processor | grep "Version" | head -n 1 | awk -F: '{print $2}' | xargs)

# Mettre à jour le système et les paquets installés
echo "Mise à jour du système et des paquets..."
sudo apt update && sudo apt upgrade -y
sudo apt dist-upgrade -y
sudo apt autoremove -y
echo "Mise à jour terminée."

# Désactiver OneDrive et supprimer sa source de mise à jour
desactiver_onedrive

# Supprimer l'icône de Microsoft Edge du bureau et de la barre des tâches
supprimer_edge

# Installer Firefox
installer_application "firefox" "firefox"

# Installer Dolphin (gestionnaire de fichiers KDE)
installer_application "dolphin" "dolphin"

# Installer OnlyOffice (version Desktop)
installer_application "onlyoffice" "onlyoffice-desktopeditors"

# Installer VLC
installer_application "vlc" "vlc"

# Installer Excel (si nécessaire)
installer_application "onlyoffice-excel" "onlyoffice-desktopeditors"

# Ajouter des raccourcis après l'installation
# Ajouter un raccourci pour Dolphin
creer_raccourci "Dolphin" "dolphin"

# Ajouter un raccourci pour Firefox
creer_raccourci "Firefox" "firefox"

# Ajouter un raccourci pour OnlyOffice Word
creer_raccourci "OnlyOffice Word" "onlyoffice"

# Ajouter un raccourci pour OnlyOffice Excel
creer_raccourci "OnlyOffice Excel" "onlyoffice"

# Ajouter un raccourci pour VLC
creer_raccourci "VLC" "vlc"

# Ajouter Firefox à la barre des tâches Plasma et aux favoris
ajouter_firefox_plasma

# Fonction pour installer le pilote WiFi rtl8821cu
installer_wifi() {
    echo "==> Suppression des anciennes versions du pilote..."
    sudo dkms remove rtl8821cu/5.12.0.4 --all 2>/dev/null
    sudo rm -rf /usr/src/rtl8821cu-5.12.0.4
    echo "==> Nettoyage terminé."

    echo "==> Téléchargement du pilote rtl8821cu..."
    git clone https://github.com/brektrou/rtl8821CU.git /tmp/rtl8821CU
    cd /tmp/rtl8821CU || exit 1

    echo "==> Ajout des sources au répertoire DKMS..."
    sudo mkdir -p /usr/src/rtl8821cu-5.12.0.4
    sudo cp -R . /usr/src/rtl8821cu-5.12.0.4

    echo "==> Ajout, construction et installation avec DKMS..."
    sudo dkms add -m rtl8821cu -v 5.12.0.4
    sudo dkms build -m rtl8821cu -v 5.12.0.4
    sudo dkms install -m rtl8821cu -v 5.12.0.4

    echo "==> Chargement du module rtl8821cu..."
    sudo modprobe 8821cu

    echo "==> Configuration pour charger le module au démarrage..."
    echo "8821cu" | sudo tee -a /etc/modules > /dev/null

    echo "==> Vérification de l'installation..."
    if lsmod | grep -q "8821cu"; then
        echo "Le module rtl8821cu est installé et chargé avec succès !"
    else
        echo "Erreur : le module rtl8821cu n'a pas été chargé correctement."
    fi

    echo "==> Nettoyage des fichiers temporaires..."
    cd ~
    rm -rf /tmp/rtl8821CU
}

# Affichage du message "Votre ordinateur est prêt !" avec le nom, numéro de série, modèle, marque et processeur
echo -e "\033[0;32mVotre ordinateur ($nom_ordinateur) est prêt !"
echo -e "Numéro de série : $num_serie"
echo -e "Marque : $marque_ordinateur"
echo -e "Modèle : $modele_ordinateur"
echo -e "Processeur : $processeur\033[0m"
echo -e "Wifi installé"
