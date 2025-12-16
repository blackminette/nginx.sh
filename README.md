# nginx.sh

## Description

`nginx.sh` est un script Bash conçu pour **simplifier l’installation et la gestion de Nginx** sur un système Linux. Il permet de :

- Installer Nginx si celui-ci n’est pas présent sur la machine.
- Démarrer et activer le service Nginx au démarrage du système.
- Créer, supprimer et afficher des **server blocks** facilement via un menu interactif.
- Tester et recharger la configuration Nginx automatiquement après chaque modification.

Le script offre une interface simple et colorée pour gérer vos sites web locaux sans avoir à manipuler manuellement les fichiers de configuration de Nginx.

## Scripts complémentaires

Dans le cadre de ce projet, j’ai également **tenté de créer un second script fun**, `generate_ASCII_art.sh`, pour générer des dessins en ASCII art à partir de descriptions textuelles. Cependant, **j’ai été bloqué par l’accès aux requêtes API** (OpenRouter/Hugging Face), ce qui m’a empêché de finaliser pleinement cette fonctionnalité.

## Prérequis

- Linux (Debian/Ubuntu recommandé)
- `sudo` pour installer et configurer Nginx
- (Optionnel pour le second script) `jq` et clé API OpenRouter, si l’on souhaite tester le ASCII art

## Usage

1. Rendre le script exécutable :

```bash
chmod +x nginx.sh
```

2. Lancer le script :

```bash
./nginx.sh
```

3. Suivre le menu interactif pour :
   - Installer Nginx
   - Créer / Supprimer / Afficher des server blocks
   - Obtenir de l’aide sur l’utilisation du script

## Notes

- Ce projet est **à usage pédagogique / TP**.
- Le second script ASCII art reste expérimental et n’est pas fonctionnel pour le moment.

