#!/bin/bash

# Couleurs ANSI
VERT='\033[0;32m'
BLEU='\033[0;34m'
ROSE='\033[1;35m'
CYAN='\033[0;36m'
JAUNE='\033[1;33m'
ROUGE='\033[0;31m'
AUCUNE='\033[0m'


clear
echo -e "${CYAN}"
echo "=========================================="
echo "          ((((  ReactClean  ))))          "
echo "=========================================="
echo -e "${VERT}"
echo "    ____            _                     "
echo "   |  _ \ ___  __ _| | ___ ___  ___       "
echo "   | |_) / _ \/ _\` | |/ __/ _ \/ __|  "
echo "   |  _ <  __/ (_| | | (_|  __/\__ \    "
echo "   |_| \_\___|\__,_|_|\___\___||___/   "
echo -e "${AUCUNE}"
echo -e "${ROSE}By${AUCUNE} ${BLEU}Aminovitch Web${AUCUNE}"
echo -e "${CYAN}==========================================${AUCUNE}"

sleep 1

# Vérification initiale du répertoire frontend
if [ ! -d "frontend" ]; then
    echo -e "${ROUGE}[Erreur]${AUCUNE} Le script doit être exécuté depuis le dossier racine du projet."
    exit 1
fi

cd frontend || { echo -e "${ROUGE}[Erreur]${AUCUNE} Impossible d'entrer dans le dossier frontend."; exit 1; }

# Détection préalable si des commentaires existent déjà
mapfile -t fichiers_commentes < <(grep -rlE "À implémenter|Styles à implémenter" ./src --exclude-dir={node_modules,.git})

if [ "${#fichiers_commentes[@]}" -eq 0 ]; then
    choix="1"
    echo -e "${CYAN}Aucune action précédente détectée. Lancement automatique de l'ajout des commentaires.${AUCUNE}"
else
    echo -e "${CYAN}Des commentaires existent déjà. Choisissez une action :${AUCUNE}"
    echo "1) Ajouter des commentaires sur les nouveaux fichiers vides"
    echo "2) Supprimer tous les commentaires ajoutés précédemment"
    read -rp "Votre choix (1 ou 2) : " choix
fi

case "$choix" in
    1)
        echo -e "${CYAN}Recherche des fichiers vides dans frontend...${AUCUNE}"

        mapfile -t fichiers < <(find ./src -type f -size 0 ! -path "*/node_modules/*" ! -path "*/.git/*")

        nombre_total=${#fichiers[@]}

        if [ "$nombre_total" -eq 0 ]; then
            echo -e "${JAUNE}Aucun fichier vide trouvé. Rien à faire.${AUCUNE}"
            exit 0
        fi

        compteur=0

        for fichier in "${fichiers[@]}"; do
            compteur=$((compteur + 1))
            pourcentage=$((compteur * 100 / nombre_total))

            echo -ne "\r${CYAN}Progression : ["
            for ((i=0; i < (pourcentage / 2); i++)); do echo -n "="; done
            for ((i=(pourcentage / 2); i < 50; i++)); do echo -n " "; done
            echo -ne "] ${pourcentage}%${AUCUNE}"

            sleep 0.1

            if [ -s "$fichier" ]; then
                continue
            fi

            extension="${fichier##*.}"
            commentaire=""

            case "$extension" in
                ts|tsx)
                    commentaire="// À implémenter"
                    ;;
                css|scss)
                    commentaire="/* Styles à implémenter */"
                    ;;
                *)
                    commentaire="// À implémenter"
                    ;;
            esac

            if ! grep -q "À implémenter" "$fichier"; then
                echo "$commentaire" > "$fichier" || { echo -e "${ROUGE}\n[Erreur]${AUCUNE} Échec écriture : $fichier"; continue; }
            fi
        done

        echo -e "\n${VERT}Terminé ! Tous les fichiers vides ont été initialisés.${AUCUNE}"
        ;;

    2)
        echo -e "${CYAN}Suppression des commentaires précédemment ajoutés...${AUCUNE}"

        total_commentes=${#fichiers_commentes[@]}
        compteur=0

        for fichier in "${fichiers_commentes[@]}"; do
            compteur=$((compteur + 1))
            pourcentage=$((compteur * 100 / total_commentes))

            echo -ne "\r${CYAN}Nettoyage : ["
            for ((i=0; i < (pourcentage / 2); i++)); do echo -n "="; done
            for ((i=(pourcentage / 2); i < 50; i++)); do echo -n " "; done
            echo -ne "] ${pourcentage}%${AUCUNE}"

            sleep 0.1

            > "$fichier" || { echo -e "${ROUGE}\n[Erreur]${AUCUNE} Impossible de nettoyer : $fichier"; continue; }
        done

        echo -e "\n${VERT}Terminé ! Tous les commentaires ajoutés ont été supprimés.${AUCUNE}"
        ;;

    *)
        echo -e "${ROUGE}[Erreur]${AUCUNE} Choix invalide. Arrêt du script."
        exit 1
        ;;
esac
