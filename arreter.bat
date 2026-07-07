@echo off
:: Arrête le serveur Puma utilisé par Rails

wsl -d Ubuntu-24.04 bash -lc "pkill -f 'puma.*book_manager'"

echo.
echo Le serveur Rails a ete arrete.

:: Ferme la fenêtre actuelle
exit