@echo off
title Changer son adresse MAC
color A
setlocal EnableDelayedExpansion
chcp 65001 > nul
cls


echo Veux-tu que tout se fasse automatiquement ou pas ? [O - Oui / n - Non / a - Annuler]
echo L'action de changer d'adresse MAC nécessite un redémarrage ultérieure de l'ordinateur.
set choix = O

if %choix% == "O" (
	rem Etape potentiellement skipable
	echo Une adresse de carte réseau ressemble à ça : 0004
	set /p carte_reseau = Saisir la valeur de la carte réseau : 
	echo Valeur de la carte réeau récupérée.
	echo.
	rem Fin

	@for /f %%a in ('getmac /NH /FO Table') do (
		@for /f %%b in ("%%a") do (
			if /i not "%%b" == "Support déconnecté" (
				set "MAC=%%b"
			)
		)
	)
	echo Adresse MAC récupérée
	echo.

	for /f "tokens=1,2,3,4,5,6 delims=-" %%a in ("%MAC%") do set string_1=%%a & set string_2=%%b & set string_3=%%c & set string_4=%%d & set string_5=%%e & set string_6=%%f
	:: for /f "tokens=1,2,3,4,5,6 delims=-" %%a in ("%MAC%") do set string_1=%%a&set string_2=%%b&set string_3=%%c&set string_4=%%d&set string_5=%%e&set string_6=%%f
	set /a MAC_sans_ = %string_1% + %string_2% + %string_3% + %string_4% + %string_5% + %string_6%
	echo Symboles moins enlevés
	echo.

	set /a MAC = 0x%MAC_sans_%
	echo Adresse MAC convertie en décimal
	echo.

	set /a MAC = %MAC% + 1
	echo Adresse MAC en décimal modifiée
	echo.

	:: ICI
	set LOOKUP=0123456789abcdef
	set HEXSTR=
	set PREFIX=

	if "%1" EQU "" (
		set "%2=0"
		goto:eof
	)

	set /a A=%1 || exit /b 1
	if !A! lss 0 set /a A=0xfffffff + !A! + 1 & set PREFIX=f

	:loop
	set /a B=!A! %% 16 & set /a A=!A! / 16
	set HEXSTR=!LOOKUP:~%B%,1!%HEXSTR%
	if %A% gtr 0 goto :loop
	set "%2=%PREFIX%%HEXSTR%"
	goto:eof
	echo Convertion en héxadécimal terminée
	echo.

	set pas = 2
	:: Initialise le numéro pour le nom de la variable
	set nombre = 1
	:loop 
	:: Récupère le premier caractère de la chaîne
	set tmp = !str:~0,%pas%!
	:: Vire le premier caractère de la chaîne
	set str = !str:~%pas%!
	:: Définit var1 lors du 1er tour, var2 lors du 2ème tour, etc
	set var!nombre! = !tmp!
	:: Vérifie qu'on ait pas déjà tout traité
	if "%str%" == "" goto fin
	:: Incrémente pour le tour suivant
	set /a nombre += 1
	goto loop
	:fin

	set /a MAC = %var_1% + "-" + %var_2% + "-" + %var_3% + "-" + %var_4% + "-" + %var_5% + "-" + %var_6%
	echo Concaténation de l'adresse héxadecimal terminée
	echo.

	reg add HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Class\{4D36E972-E325-11CE-BFC1-08002BE10318}\%carte_reseau% /v NetworkAddress /d %MAC% /f
	echo Adresse MAC mofifiée

	timeout /t 03 > nul

	shutdown -r
)

if %choix% == "n" (
	rem Etape potentiellement skipable
	echo Une adresse de carte réseau ressemble à ça : 0004
	set /p carte_reseau = Saisir la valeur de la carte réseau : 
	echo Valeur de la carte réeau récupérée.
	echo.
	rem Fin

	getmac /v
	echo.
	echo Tu devrais avoir un affichage de ce style-là :
	echo Nom de la conne Carte réseau    Adresse physique    Nom du transport
	echo =============== =============== =================== ==========================================================
	echo Wi-Fi           Intel(R) Wirele 0C-DD-24-8A-73-1B   N/A
	echo.
	echo Caractères utilisables : 0-9, A-F
	set /p MAC = Saisir la nouvelle valeur de l'adresse MAC : 

	reg add HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Class\{4D36E972-E325-11CE-BFC1-08002BE10318}\%carte_reseau% /v NetworkAddress /d %MAC% /f
	rem reg add HKEY_LOCAL_MACHINE\SYSTEM\ControlSet0001\Control\Class\{4D36E972-E325-11CE-BFC1-08002BE10318}\%carte_reseau% /v NetworkAddress /d %MAC% /f
	echo Adresse MAC mofifiée

	timeout /t 03 > nul

	shutdown -r
)

else (
	echo Annulation

	timeout /t 05 > nul
)

echo Une erreur s'est produite.
	
timeout /t 05 > nul



rem Récupérer la valeur de la carte réseau - 

rem Récupérer l'adresse MAC de la carte réseau - OK
rem Enlever les "-" de l'adresse MAC - OK
rem Passer l'adresse MAC en décimal - OK

rem Modifier l'adresse MAC pour en avoir une nouvelle - OK
rem Passer l'adresse MAC en héxadécimal - OK
rem Ajouter des "-" à l'adresse MAC - OK

rem Enregistrer l'adresse MAC dans l'ordinateur - OK