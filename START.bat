@echo off
setlocal

set "SCRIPTDIR=%~dp0"
set "HTMLFILE=%SCRIPTDIR%index.html"
set "ICONFILE=%SCRIPTDIR%Icon.ico"

echo.
echo ==========================================
echo StarClass Desktop Shortcut Creator
echo ==========================================
echo Script dir: %SCRIPTDIR%
echo Target:     %HTMLFILE%
echo Icon:       %ICONFILE%
echo ==========================================
echo.

if not exist "%HTMLFILE%" (
    echo [ERROR] index.html NOT FOUND next to this .bat
    echo Place make_shortcut.bat in the same folder as index.html.
    echo.
    exit /b 1
)

echo [OK] index.html found

if exist "%ICONFILE%" (
    echo [OK] Icon.ico found
) else (
    echo [WARN] Icon.ico NOT found - shortcut will use default browser icon
)

:: Write temp VBScript using Windows' real Desktop folder
:: NOTE: ^& escapes the ampersand so cmd doesn't treat it as a command separator
echo Set WshShell = CreateObject("WScript.Shell") > "%TEMP%\MakeStarClass.vbs"
echo DesktopPath = WshShell.SpecialFolders("Desktop") >> "%TEMP%\MakeStarClass.vbs"
echo ShortcutPath = DesktopPath ^& "\StarClass.lnk" >> "%TEMP%\MakeStarClass.vbs"
echo TargetPath = "%HTMLFILE%" >> "%TEMP%\MakeStarClass.vbs"
echo IconPath = "%ICONFILE%" >> "%TEMP%\MakeStarClass.vbs"
echo WorkDir = "%SCRIPTDIR%" >> "%TEMP%\MakeStarClass.vbs"
echo Set oShortcut = WshShell.CreateShortcut(ShortcutPath) >> "%TEMP%\MakeStarClass.vbs"
echo oShortcut.TargetPath = TargetPath >> "%TEMP%\MakeStarClass.vbs"
echo oShortcut.IconLocation = IconPath ^& ",0" >> "%TEMP%\MakeStarClass.vbs"
echo oShortcut.WorkingDirectory = WorkDir >> "%TEMP%\MakeStarClass.vbs"
echo oShortcut.Description = "StarClass" >> "%TEMP%\MakeStarClass.vbs"
echo oShortcut.Save >> "%TEMP%\MakeStarClass.vbs"
echo WScript.Echo "Shortcut written to: " ^& ShortcutPath >> "%TEMP%\MakeStarClass.vbs"

cscript //nologo "%TEMP%\MakeStarClass.vbs"
del "%TEMP%\MakeStarClass.vbs" 2>nul

echo.
endlocal
