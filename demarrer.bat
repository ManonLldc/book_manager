@echo off
:: Désactive l'affichage des commandes dans la fenêtre CMD.
:: Sans cette ligne, chaque commande serait affichée avant d'être exécutée.

start http://localhost:3000
:: Ouvre le navigateur par défaut à l'adresse de ton application.
:: La page peut afficher une erreur quelques secondes si Rails n'a pas encore fini de démarrer.
:: Une fois le serveur prêt, il suffit d'actualiser la page.

wsl -d Ubuntu-24.04 bash -lic "cd ~/book_manager && bundle exec rails server"
:: wsl                  : lance le Sous-système Windows pour Linux (WSL).
:: -d Ubuntu-24.04      : indique la distribution Linux à utiliser.
:: bash                 : démarre le shell Bash.
:: -l                   : ouvre une session "login", ce qui charge les fichiers de configuration
::                        (comme ~/.bashrc ou ~/.profile) et rend Ruby/Bundler disponibles.
:: -i                   : ouvre un shell interactif, comme si tu avais ouvert un terminal Ubuntu.
:: -c "..."             : exécute la commande placée entre guillemets puis s'arrête.
::
:: cd ~/book_manager    : se place dans le dossier de ton projet Rails.
:: &&                   : exécute la commande suivante uniquement si le changement de dossier a réussi.
:: bundle exec rails server
::                      : démarre le serveur Rails en utilisant les versions des gems
::                        définies dans ton projet (Gemfile).

pause
:: Empêche la fenêtre CMD de se fermer immédiatement lorsque le serveur s'arrête.
:: Elle affiche "Appuyez sur une touche pour continuer...".