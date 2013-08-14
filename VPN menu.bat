@echo off
:: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: 
title VPN menu

:: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: ::
:Autostart																			   ::
::																					   ::
:: :: To autostart a Remote Connection upon logon, create the following file :: ::	   ::
:: %systemprofile%/Program Files/Startup/vpn										   ::
::																					   ::
:: :: With the following contents :: ::												   ::	
:: ECHO # Starting VPN #															   ::	
:: set "autostart=goto :ALL"														   ::
:: start %CMDCMDLINE% /c %HOMEDRIVE%\menu.bat										   ::
:: exit																				   ::
::																					   ::
:: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: ::

%autostart%

:: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: 
:menu

ECHO.
ECHO   ##############################################
ECHO  #                                              #
ECHO #           Welcome to VPN menu example          #
ECHO  #                                              #
ECHO   ##############################################
ECHO.
ECHO     %date%                 %time%
ECHO.
ECHO               1 - ALL
ECHO                 2 - VPN
ECHO                 3 - Mount Shares
ECHO                 4 - Open Folders
ECHO                 5 - Start Programs
ECHO                 6 - Undo Everything
ECHO.
ECHO               Q - Quit
ECHO.

set "end=goto :end"

:: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: 
:user input

set /p userinp=choose a number (1-6):

echo # # # 2nd selection # # # %userinp2%
if "%userinp%"=="1" goto ALL
if "%userinp%"=="2" goto VPN
if "%userinp%"=="3" goto Mount Shares
if "%userinp%"=="4" goto Open Folders
if "%userinp%"=="5" goto Start Programs
if "%userinp%"=="6" goto Undo Everything

if "%userinp%"=="q" goto exit

:: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: 
:fail

ping 1.1.1.1 -n 1 -w 100 > nul
echo.
echo [] - - - - - - - - - - - []
echo.
echo [] That is not an option []
echo.
echo []   Please try again    [] 
echo.
echo [] - - - - - - - - - - - []
echo.
ping 1.1.1.1 -n 1 -w 2500 > nul

goto :menu

:: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: 
:ALL

ECHO + Running ALL + + + + + + + + + + + + + +   %time%
ECHO.

:begin
	set "end=echo   = = = SUCCESS = = =                      %time%" 

ping 1.1.1.1 -n 1 -w 1000 > nul

:: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: 
:VPN

ECHO + Initiating VPN + + + + + + + + + + + + +  %time%
ECHO.
	
:begin
	set "begin=:VPN"
	set "connection_name=VPN_example"
	set "username=martinc"		
	set "password=lamepassword"

:check
echo   + Checking for %connection_name%         %time%
ping 1.1.1.1 -n 1 -w 1000 > nul
rasdial | findstr %connection_name%

  IF "%action%" == "goto connect" THEN (
	goto :connect
) ELSE (
	goto :disconnect
)

:connect
if %ERRORLEVEL% == 0 echo + + %connection_name% connected & goto :next
if not %ERRORLEVEL% == 0 echo - - %connection_name not connected & %action%

echo   + Connecting to %connection_name%
ping 1.1.1.1 -n 1 -w 1000 > nul
rasdial %connection_name% %username% %password%
goto %begin%
pause

:disconnect
if %ERRORLEVEL% == 0 echo + + %connection_name% connected & %action%
if not %ERRORLEVEL% == 0 echo - - %connection_name not connected & goto :next

echo   - Disconnecting %connection_name%        %time%
ping 1.1.1.1 -n 1 -w 1000 > nul
rasdial %connection_name% /disconnect
goto %begin%

:next
ECHO.
%end%

:: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: ::  
:Mount Shares

ECHO + Mounting Shares + + + + + + + + + + + + + %time%
ECHO.

:begin
	set "begin=:Mount Shares"
	set share_letter="U:"
	set share_path="\\192.168.0.10\path\to_the\desired folder"
	set password="samba_pwd"
	set username="domain.local\samba_username"

ECHO   + Checking for shares                    %time%
ping 1.1.1.1 -n 1 -w 1000 > nul
fsutil fsinfo drives | findstr %share_letter%

if %ERRORLEVEL% == 0 goto :remove
if not %ERRORLEVEL% == 0 goto :mount

:remove
ECHO   - Removing shares                        %time%
ping 1.1.1.1 -n 1 -w 1000 > nul
net use %share_letter% /delete /yes
goto %begin%

:mount
ECHO   + Mounting shares                        %time%
ping 1.1.1.1 -n 1 -w 1000 > nul
net use %share_letter% %share_path% %password% /user:%username% /PERSISTENT:NO

if %ERRORLEVEL% == 0 goto :next
if not %ERRORLEVEL% == 0 echo   ? Failed, trying again . . . & goto %begin%

:next
ECHO.
%end%

:: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: ::  
:Open Folders

ECHO + Opening Folders + + + + + + + + + + + + + %time%
ECHO.

:begin
	set "begin=:Open Folders"
	set "share_letter=U:"
	set "folder1=%share_letter%\scripts"
	set "folder2=%share_letter%\different\folder"
	set "folder3=%share_letter%\yet another\directory"

ECHO   + Opening %folder1%                      %time%
ping 1.1.1.1 -n 1 -w 100 > nul
"%windir%\explorer.exe" %folder1% 

ECHO   + Opening %folder3%                      %time%
ping 1.1.1.1 -n 1 -w 100 > nul
"%windir%\explorer.exe" %folder2%

ECHO   + Opening %folder3%                      %time%
ping 1.1.1.1 -n 1 -w 100 > nul
"%windir%\explorer.exe" %folder3%

:next
ECHO.
%end%

:: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: ::  
:Start Programs

: Processes

ECHO + Starting Programss + + + + + + + + + + + %time%
ECHO.

:: :: :: :: :: :: :: :: :: :: :: :: :: :: :: ::  
:notepad

:begin
	set "begin=:notepad"
	set "program=%WINDIR%\notepad.exe"

echo   + Checking for %program%                 %time%
ping 1.1.1.1 -n 1 -w 1000 > nul
tasklist | findstr "%program%"
if %ERRORLEVEL% == 0 goto :next
if not %ERRORLEVEL% == 0 goto :start

:start
echo   + Starting %program%                     %time%
ping 1.1.1.1 -n 1 -w 1000 > nul
%program%

:next
ECHO.
%end%

:: :: :: :: :: :: :: :: :: :: :: :: :: :: :: ::  

:: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: 
:Undo Everything

ECHO . . . This will Undo Everything . . . 
ECHO.
PAUSE

ECHO - Ending Processes  - - - - - - - - - - - - %time%
ECHO.

:begin
	set "begin=:notepad"
	set "program=%WINDIR%\notepad.exe"

echo   - Checking for %program%
ping 1.1.1.1 -n 1 -w 100 > nul
tasklist | findstr "%program%"
if %ERRORLEVEL% == 0 goto :kill
if not %ERRORLEVEL% == 0 goto :next

:kill
echo   - Killing %program%                      %time%
taskkill /IM %program% /f
if %ERRORLEVEL% == 0 echo    - %program% ended - & goto :next
if not %ERRORLEVEL% == 0 goto %begin%

:next
ECHO.

ECHO - Removing all network shares - - - - - - - %time%
ECHO.

:Removing all network shares

:begin
	set "begin=Removing all network shares"
	set "share_letter=U:"
	set "share_path=\\192.168.0.10\path\to_the\desired folder"
	set "password=samba_pwd"
	set "username=domain.local\samba_username"

ECHO   - Checking for %share_letter%
ping 1.1.1.1 -n 1 -w 1000 > nul
fsutil fsinfo drives | findstr %share_letter%

if %ERRORLEVEL% == 0 goto :remove
if not %ERRORLEVEL% == 0 echo   - No shares & goto :next

:remove
ECHO   - Removing %share_letter%                %time%
ping 1.1.1.1 -n 1 -w 1000 > nul
net use %share_letter% /delete /yes
if %ERRORLEVEL% == 0 goto %begin%
if not %ERRORLEVEL% == 0 echo "No shares" & goto :next

:next
ECHO.

ECHO - Disconnecting VPN - - - - - - - - - - - - %time%
ECHO.

:Disconnecting VPN

:begin
	set "begin=:Disconnecting VPN"
	set "connection_name=VPN_example"
	set "username=martinc"		
	set "password=lamepassword"

echo   - Checking for %connection_name%         %time%
ping 1.1.1.1 -n 1 -w 1000 > nul
::ipconfig | findstr "192.168.168"
rasdial | findstr %connection_name%

if %ERRORLEVEL% == 0 goto :disconnect
if not %ERRORLEVEL% == 0 echo    - Disconnected & goto :next

:disconnect
echo   - Disconnecting %connection_name%        %time%
ping 1.1.1.1 -n 1 -w 1000 > nul
rasdial %connection_name% /disconnect

goto %begin%

:next
ECHO.
%end%

:: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: 
:done

ECHO.
ECHO # # # # # # # # # # #                      %time%
ECHO Thank You Come Again
ECHO # # # # # # # # # # #
ECHO.

ECHO Press any key to exit
ECHO.
pause>nul
exit

:: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: :: 
:end
echo   = = = SUCCESS = = =                      %time%
echo.
ping 1.1.1.1 -n 1 -w 1000 > nul
goto :menu

EOF

