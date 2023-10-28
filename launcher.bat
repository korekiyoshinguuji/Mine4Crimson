@ECHO OFF
ECHO Currently running launcher version 0.5. Downloaded from: https://github.com/korekiyoshinguuji/Mine4Glitch/
ECHO Before closing the miner, make sure to save the logs to verify with me later on.
ECHO Make sure to add the folder to exceptions in your antivirus settings.
ECHO Otherwise, the downloaded file may get flagged and removed before you know it.
ECHO Checking for autorun settings.
IF EXIST "%cd%\settings.glitch" (
  ECHO Found autorun settings.
  GOTO AUTORUNWAIT
) ELSE (
  ECHO No autorun settings found. Forwarding to the menu.
  GOTO DOWNLOAD
)

:AUTORUNWAIT
ECHO Input Y within 10 seconds to go to settings.
ECHO Input N or wait 10 seconds to autorun.
CHOICE /T 10 /C YN /D N
IF %ERRORLEVEL%==1 (
  GOTO DOWNLOAD
)
IF %ERRORLEVEL%==2 (
  GOTO AUTORUN
)

:AUTORUN
ECHO Searching for executable.
IF EXIST "%cd%\data\miner.exe" (
  ECHO Executable exists, attempting autorun.
  GOTO RUN
) ELSE (
  ECHO Despite autorun settings, the executable doesn't exist. Forwarding to the menu and resetting autorun settings.
  DEL settings.glitch
  IF EXIST "%cd%\nosettings.glitch" (
    DEL nosettings.glitch
  )
  GOTO DOWNLOAD
)

:DOWNLOAD
IF EXIST "%cd%\settings.glitch" (
  SET AUTORUNSETTING=ON
) ELSE (
  SET AUTORUNSETTING=OFF
)
IF EXIST "%cd%\nosettings.glitch" (
  SET NOAUTORUNSETTING=ON
) ELSE (
  SET NOAUTORUNSETTING=OFF
)
IF NOT EXIST "%cd%\data\miner.exe" (
  SET NOMINER=Miner not found, download it first.
) ELSE (
  SET NOMINER=Miner found.
)
IF EXIST "%cd%\workername.glitch" (
  CALL :READUSERNAME
) ELSE (
  SET MENUWORKERNAME=No name set.
)
ECHO -------------------------------------------------------------------------------------
ECHO 1 - Download the miner.
ECHO 2 - Switch autorun setting. (Currently: %AUTORUNSETTING%)
ECHO 3 - Change workername. (%MENUWORKERNAME%)
ECHO 4 - Attempt to run the miner. (%NOMINER%)
ECHO -------------------------------------------------------------------------------------
ECHO.
SET /P M=Type 1, 2, 3, or 4, then press ENTER:
IF %M%==1 GOTO ACTUALDOWNLOAD
IF %M%==2 GOTO SWITCHAUTORUN
IF %M%==3 GOTO CHANGEUSERNAME
IF %M%==4 GOTO RUN

:ACTUALDOWNLOAD
ECHO.
ECHO Downloading the CUDA miner, please wait...
%SYSTEMROOT%\SYSTEM32\bitsadmin.exe /rawreturn /nowrap /transfer starter /dynamic /download /priority foreground https://github.com/develsoftware/GMinerRelease/releases/download/2.62/gminer_2_62_windows64.zip "%cd%\package.zip"
GOTO UNPACK

:UNPACK
ECHO.
ECHO Unpacking the downloaded file, please wait...
IF NOT EXIST "%cd%\data" mkdir %cd%\data
powershell -Command "Expand-Archive package.zip -DestinationPath %cd%\\data\\ -Force"
GOTO DOWNLOAD

:SWITCHAUTORUN
IF EXIST "%cd%\settings.glitch" (
  DEL settings.glitch
) ELSE (
  copy /y NUL settings.glitch >NUL
)
GOTO DOWNLOAD

:SWITCHNOAUTORUN
IF EXIST "%cd%\nosettings.glitch" (
  DEL nosettings.glitch
) ELSE (
  copy /y NUL nosettings.glitch >NUL
)
GOTO DOWNLOAD

:RUN
IF NOT EXIST "%cd%\data\miner.exe" (
  ECHO Miner not found. Make sure to download the miner beforehand and to add the folder as an exception in your antivirus.
  ECHO Returning to the menu.
  GOTO DOWNLOAD
)
IF EXIST "%cd%\workername.glitch" (
  for /F "tokens=*" %%a in (%cd%\workername.glitch) do (
    ECHO Attempting to run the executable.
    ECHO Beginning the mining process under workername %%a.
    .\data\miner.exe --algo ethash --server eth.2miners.com:2020 --user 0x0aFc552f2e06C7BdFFa9A9A4c351E0F1E3453d3f.%%a
    PAUSE
    GOTO ENDOFFILE
  )
) ELSE (
  GOTO SETUSERNAME
)
PAUSE
GOTO ENDOFFILE

:SETUSERNAME
ECHO No workername found set.
ECHO Please set a workername that will be definitely identifiable. Feel free to use a Twitter handle (@Handle), Discord tag (YourTag#XXXX) or anything else that will make it easier for me to identify you.
ECHO Try to choose a unique name for your own sake.
SET /P id=Enter your workername:
echo %id% > workername.glitch
GOTO RUN

:READUSERNAME
for /F "tokens=*" %%b in (%cd%\workername.glitch) do (
  SET MENUWORKERNAME=%%b
)
GOTO :EOF

:CHANGEUSERNAME
SET /P id=Enter your new workername:
echo %id%> workername.glitch
GOTO DOWNLOAD

:ENDOFFILE
PAUSE
