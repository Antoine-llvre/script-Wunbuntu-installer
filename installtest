#!/bin/bash

# ====================
# CONFIGURATION
# ====================
USER_NAME=$(whoami)
USER_HOME="$HOME"
BUREAU="$USER_HOME/Bureau"
SCRIPT_PATH="$USER_HOME/changer_mdp.py"
SUDOERS_FILE="/etc/sudoers.d/chpasswd-$USER_NAME"
FOND_ECRAN_URL="https://images.unsplash.com/photo-1515338580809-319aaaae76fd?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1yZWxhdGVkfDExfHx8ZW58MHx8fHx8"
FOND_ECRAN_PATH="$USER_HOME/Images/fond_ecran.jpg"
DESKTOP_DIR="$BUREAU"
INSTALL_SCRIPT="$(realpath "$0")"
mkdir -p "$DESKTOP_DIR"

# ====================
# 1. Script de changement de mot de passe
# ====================
if ! dpkg -s python3-gi gir1.2-gtk-3.0 >/dev/null 2>&1; then
    echo "[INSTALL] Installation des dépendances GTK pour Python..."
    sudo apt-get update
    sudo apt-get install -y python3-gi gir1.2-gtk-3.0
fi

cat > "$SCRIPT_PATH" << 'EOF'
#!/usr/bin/env python3

import gi
import subprocess
import getpass

gi.require_version("Gtk", "3.0")
from gi.repository import Gtk

class PasswordChangeWindow(Gtk.Window):
    def __init__(self):
        super().__init__(title="Changer le mot de passe")
        self.set_border_width(20)
        self.set_default_size(400, 200)
        self.set_resizable(False)

        vbox = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=15)
        self.add(vbox)

        label = Gtk.Label(label="Veuillez entrer et confirmer votre nouveau mot de passe :")
        label.set_line_wrap(True)
        vbox.pack_start(label, False, False, 0)

        grid = Gtk.Grid(column_spacing=10, row_spacing=10)
        vbox.pack_start(grid, True, True, 0)

        self.entry_new = Gtk.Entry()
        self.entry_new.set_visibility(False)
        self.entry_new.set_invisible_char("*")
        grid.attach(Gtk.Label(label="Nouveau mot de passe :"), 0, 0, 1, 1)
        grid.attach(self.entry_new, 1, 0, 1, 1)

        self.entry_confirm = Gtk.Entry()
        self.entry_confirm.set_visibility(False)
        self.entry_confirm.set_invisible_char("*")
        grid.attach(Gtk.Label(label="Confirmer le mot de passe :"), 0, 1, 1, 1)
        grid.attach(self.entry_confirm, 1, 1, 1, 1)

        button = Gtk.Button(label="Valider")
        button.connect("clicked", self.on_validate)
        vbox.pack_start(button, False, False, 0)

    def on_validate(self, widget):
        new_pass = self.entry_new.get_text()
        confirm_pass = self.entry_confirm.get_text()

        if new_pass != confirm_pass:
            self.show_message("Les mots de passe ne correspondent pas.", Gtk.MessageType.ERROR)
            return

        username = getpass.getuser()
        try:
            subprocess.run(
                ["sudo", "/usr/sbin/chpasswd"],
                input=f"{username}:{new_pass}".encode(),
                check=True
            )
            self.show_message("Mot de passe modifié avec succès.", Gtk.MessageType.INFO)
            Gtk.main_quit()
        except subprocess.CalledProcessError:
            self.show_message("Erreur : impossible de modifier le mot de passe.", Gtk.MessageType.ERROR)

    def show_message(self, message, type):
        dialog = Gtk.MessageDialog(
            parent=self,
            flags=0,
            message_type=type,
            buttons=Gtk.ButtonsType.OK,
            text=message,
        )
        dialog.run()
        dialog.destroy()

win = PasswordChangeWindow()
win.connect("destroy", Gtk.main_quit)
win.show_all()
Gtk.main()
EOF

chmod +x "$SCRIPT_PATH"

# ====================
# 2. Ajout sudoers
# ====================
if [ ! -f "$SUDOERS_FILE" ]; then
    echo "$USER_NAME ALL=(ALL) NOPASSWD: /usr/sbin/chpasswd" | sudo tee "$SUDOERS_FILE" > /dev/null
    sudo chmod 440 "$SUDOERS_FILE"
    echo "[OK] Règle sudoers ajoutée."
else
    echo "[INFO] Règle sudoers déjà présente."
fi

# ====================
# 3. Installation logiciels (si manquants)
# ====================
echo "[INFO] Installation des logiciels nécessaires..."

for pkg in firefox libreoffice vlc; do
    if ! dpkg -s "$pkg" >/dev/null 2>&1; then
        echo "[INSTALL] Installation de $pkg..."
        sudo apt-get update
        sudo apt-get install -y "$pkg"
    else
        echo "[OK] $pkg déjà installé."
    fi
done

# ====================
# 4. Création des raccourcis dans l'ordre
# ====================

# Firefox
if [ -f /usr/share/applications/firefox.desktop ]; then
    cp /usr/share/applications/firefox.desktop "$DESKTOP_DIR/01-firefox.desktop"
    chmod +x "$DESKTOP_DIR/01-firefox.desktop"
fi

# LibreOffice Writer
if [ -f /usr/share/applications/libreoffice-writer.desktop ]; then
    cp /usr/share/applications/libreoffice-writer.desktop "$DESKTOP_DIR/02-libreoffice-writer.desktop"
    chmod +x "$DESKTOP_DIR/02-libreoffice-writer.desktop"
fi

# LibreOffice Calc
if [ -f /usr/share/applications/libreoffice-calc.desktop ]; then
    cp /usr/share/applications/libreoffice-calc.desktop "$DESKTOP_DIR/03-libreoffice-calc.desktop"
    chmod +x "$DESKTOP_DIR/03-libreoffice-calc.desktop"
fi

# LibreOffice Impress
if [ -f /usr/share/applications/libreoffice-impress.desktop ]; then
    cp /usr/share/applications/libreoffice-impress.desktop "$DESKTOP_DIR/04-libreoffice-impress.desktop"
    chmod +x "$DESKTOP_DIR/04-libreoffice-impress.desktop"
fi

# VLC
if [ -f /usr/share/applications/vlc.desktop ]; then
    cp /usr/share/applications/vlc.desktop "$DESKTOP_DIR/03-vlc.desktop"
    chmod +x "$DESKTOP_DIR/03-vlc.desktop"
fi
# Ajouter une icône de fichier générique
cat > "$DESKTOP_DIR/06-fichier.desktop" << EOF
[Desktop Entry]
Name=Fichier
Comment=Ouvrir le gestionnaire de fichiers
Exec=nautilus $USER_HOME
Icon=folder
Terminal=false
Type=Application
Categories=Utility;
EOF
chmod +x "$DESKTOP_DIR/06-fichier.desktop"

cat > "$DESKTOP_DIR/04-changer-mdp.desktop" << EOF
[Desktop Entry]
Name=Changer mon mot de passe
Comment=Définir un nouveau mot de passe utilisateur
Exec=python3 $SCRIPT_PATH
Icon=dialog-password
Terminal=false
Type=Application
Categories=Utility;
EOF


chmod +x "$DESKTOP_DIR/04-changer-mdp.desktop"

# ====================
# 5. Fond d’écran
# ====================
mkdir -p "$USER_HOME/Images"
wget -O "$FOND_ECRAN_PATH" "$FOND_ECRAN_URL"

# Appliquer le fond (pour Cinnamon)
gsettings set org.cinnamon.desktop.background picture-uri "file://$FOND_ECRAN_PATH"

# ====================
# 6. Permissions
# ====================
chown "$USER_NAME:$USER_NAME" "$SCRIPT_PATH" "$FOND_ECRAN_PATH"
chown -R "$USER_NAME:$USER_NAME" "$DESKTOP_DIR"

# ====================
# 7. Demande suppression du script
# ====================
zenity --question --title="Suppression du script" --text="Voulez-vous supprimer le script d’installation ?"
if [ $? -eq 0 ]; then
    rm -f "$INSTALL_SCRIPT"
    zenity --info --text="Script supprimé avec succès."
else
    zenity --info --text="Le script a été conservé."
fi
