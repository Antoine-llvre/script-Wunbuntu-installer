# Ordinateur Solidaire - Script d'installation et de configuration

Ce script, **Ordinateur Solidaire**, est conçu pour configurer un ordinateur dans le cadre des missions de conseiller numérique à la Ville de Poitiers. Il facilite l'installation et la configuration de plusieurs applications essentielles, ainsi que la gestion de certains éléments comme OneDrive et Microsoft Edge.

## Mentions légales

Ce script est fourni par **Lelièvre Antoine** dans le cadre de ses missions de conseiller numérique à la Ville de Poitiers.

**Conditions d'utilisation** :

- Ce script est fourni "tel quel", sans aucune garantie.
- L'utilisateur est responsable de l'utilisation de ce script.

---

## Fonctionnalités

Le script automatise les tâches suivantes :

1. **Mise à jour du système** :
   - Met à jour les paquets installés via `apt` (`apt update`, `apt upgrade`, etc.).

2. **Gestion d'applications** :
   - Installe les applications suivantes si elles ne sont pas déjà installées :
     - **Firefox**
     - **Dolphin** (Gestionnaire de fichiers KDE)
     - **OnlyOffice** (pour les applications bureautiques comme Word et Excel)
     - **VLC**
   
3. **Gestion de OneDrive** :
   - Désactive et désinstalle OneDrive, ainsi que sa source de mise à jour.

4. **Suppression de Microsoft Edge** :
   - Supprime Microsoft Edge de l'ordinateur, y compris les raccourcis et les fichiers associés.

5. **Création de raccourcis sur le bureau** :
   - Crée des raccourcis `.desktop` sur le bureau pour chaque application installée.

6. **Ajout de Firefox aux favoris Plasma** :
   - Ajoute Firefox à la barre des tâches et aux favoris dans l'environnement de bureau KDE Plasma.

---

## Prérequis

Le script est conçu pour être utilisé sur un système basé sur Debian/Ubuntu (par exemple, Ubuntu, Linux Mint, etc.). Il nécessite les droits d'administrateur (`sudo`) pour installer des paquets et effectuer certaines opérations système.

Les applications installées via ce script sont :

- **Firefox** : Navigateur web.
- **Dolphin** : Gestionnaire de fichiers KDE.
- **OnlyOffice** : Suite bureautique.
- **VLC** : Lecteur multimédia.

---

## Installation

1. Clonez le dépôt sur votre machine :

   ```bash
   git clone https://github.com/USER/ORDINATEUR-SOLIDAIRE.git
   cd ORDINATEUR-SOLIDAIRE

2. Rendez le script exécutable :

   ```bash
   chmod +x ordinateur_solidaire.sh

3. Exécutez le script en tant qu'administrateur (avec sudo) :

  ```bash
  sudo ./ordinateur_solidaire.sh
